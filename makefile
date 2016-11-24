######## Src Builder ######## 
# Created at:    2016-11-14 #
# Created by: Lin Sun       #
# Last modified: 2016-11-22 #
# Modified by: Lin Sun      #
#############################
# Please modify the src dir path
h5SrcDir=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/webapp/trunk/resources/web
ifneq "${h5src}" ""
	h5SrcDir=${h5src}
endif

appSrcDir=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/client_v2/iOS/trunk/BaoCai_Dev
ifneq "${src}" "" 
	appSrcDir = ${src}
endif

doUpdateSourceFile=false
ifeq "${updateSrc}" "true"
	doUpdateSourceFile=true
endif

webpackConfigFile=./src/apps/webpack.config.js
appIndexFile=./src/apps/index.js
# Do local test, DON'T modify original codes
wechat: appSrcDir=${h5SrcDir}
wechat: appIntegrationDir=./integrations/wechat
wechat: appTmpDir=./src/apps/wechat/tmp
wechat: appTemplateDir=./src/apps/wechat/templates
wechat: components="home:newhome" # "<component name>:<target template file name> <component name>:<target template file name> ..."
wechat: target=wechat
wechat: targetNameInAppIndex=Wechat
wechat: syncFromH5=true

ios: appIntegrationDir=./integrations/ios
ios: appTmpDir=./src/apps/ios/tmp
ios: appTemplateDir=./src/apps/ios/templates
ios: components="home"
ios: target=ios
ios: targetNameInAppIndex=IOS
ios: syncFromH5=false


wechat ios:
	# Prepare the environment
	echo "SRC: " ${appSrcDir}
	if [[ ${doUpdateSourceFile} == true ]];then svn update ${appSrcDir}; fi
	mkdir -p ${appIntegrationDir}
	rm -rf ${appIntegrationDir}
	cp -r ${appSrcDir} ${appIntegrationDir}
	rm -rf ${appTmpDir}
	mkdir -p ${appTmpDir}
	cp ${webpackConfigFile} ${appTmpDir}
	# Copy CSS & image files && Fix “less import” problem
	if [[ ${syncFromH5} == true ]]; then \
		svn update ${h5SrcDir} ; \
		cp ${h5SrcDir}/src/images/* ./src/images; \
		cp ${h5SrcDir}/src/less/* ./src/css; \
		for file in `ls ./src/css`; do \
			sed 's/import "mobile-angular-ui/import "\.\.\/\.\.\/bower_components\/mobile-angular-ui/g' ./src/css/$${file} > ${appTmpDir}/tmp.less ;\
			mv ${appTmpDir}/tmp.less ./src/css/$${file};\
			if [[ $${file} == baocai.less ]]; then \
				sed '12,19 s/^/\/\//' ./src/css/$${file} > ${appTmpDir}/tmp.less && mv ${appTmpDir}/tmp.less ./src/css/$${file};\
			fi ;\
		done; \
	fi
	# Prepare the webpack config file
	rm -rf ${appTmpDir}/tmp.js ${appTmpDir}/tmpHead.js ${appTmpDir}/tmpTail.js
	sed '/index: __dirname/,$$ d' ${webpackConfigFile} > ${appTmpDir}/tmpHead.js
	sed '1,/index: __dirname/ d' ${webpackConfigFile} > ${appTmpDir}/tmpTail.js
	# Generate target pages according template, and, generate the webpack config file accordingly
	for comp in `echo ${components}`; do \
		compName=`echo $${comp}|awk '{print $$1}' FS=":"` ; \
		templateFileName=`echo $${comp}|awk '{print $$2}' FS=":"` ; \
		targetFileName=$${compName} ;\
		if [[ "$${templateFileName}" != "" ]];then targetFileName=$${templateFileName} ; fi ; \
		sed "s/bundle.index.js/bundle.$${targetFileName}.js/g" ${appTemplateDir}/index.html > ${appTmpDir}/$${targetFileName}.html ;\
		if [[ ${target} == wechat ]]; then \
			sed "15,19 d; s/pages\/home/pages\/$${compName}/g" ${appIndexFile} > ${appTmpDir}/$${targetFileName}.js ;\
		else \
			sed "s/pages\/home/pages\/$${compName}/g" ${appIndexFile} > ${appTmpDir}/$${targetFileName}.js ;\
		fi ; \
		sed "s/is${targetNameInAppIndex}: false/is${targetNameInAppIndex}: true/g" ${appTmpDir}/$${targetFileName}.js > ${appTmpDir}/tmp.js ;\
		mv ${appTmpDir}/tmp.js ${appTmpDir}/$${targetFileName}.js;\
		echo "        $${targetFileName}: __dirname + '/$${targetFileName}.js'," >> ${appTmpDir}/tmp.js ;\
	done
	# Compose the webpack.config.js and delete the temporary files
	cat ${appTmpDir}/tmpHead.js ${appTmpDir}/tmp.js ${appTmpDir}/tmpTail.js > ${appTmpDir}/webpack.config.js
	rm -rf ${appTmpDir}/tmp.js ${appTmpDir}/tmpHead.js ${appTmpDir}/tmpTail.js
	# Run the webpack to build target components
	export PATH=`pwd`/node_modules/.bin:$${PATH} && cd ${appTmpDir} && which webpack && webpack --config webpack.config.js --progress --colors --inline
	# Post-process for WeChat: 
		# Move the template files to wechat template direcotory; 
		# Modify index.html; 
		# Build the test project with these template files
	# Post-process for iOS:
		# Copy H5 files to iOS project, together with the controllers and webViewController
	if [[ ${target} == wechat ]]; then \
		for comp in `echo ${components}`; do \
			templateFileName=`echo $${comp}|awk '{print $$2}' FS=":"` ; \
			mv ${appTmpDir}/$${templateFileName}.html ${appIntegrationDir}/src/templates ;\
		done ;\
		sed '/<script src="js\/app.min.js/,$$ d' ${appIntegrationDir}/src/html/index.html > ${appTmpDir}/tmp.html ;\
		echo '<script src="/js/jquery-3.1.1.min.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<script src="/js/app.min.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<script src="/react/bundle.common.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<link ref="stylesheet" tyle="text/css" href="react/bundle.style.css">' >> ${appTmpDir}/tmp.html ;\
		sed '1,/<script src="js\/app.min.js/ d' ${appIntegrationDir}/src/html/index.html >> ${appTmpDir}/tmp.html ;\
		mv ${appTmpDir}/tmp.html ${appIntegrationDir}/src/html/index.html ;\
		export PATH=`pwd`/node_modules/.bin:$${PATH} && cd ${appIntegrationDir} && gulp build_q ;\
		cd - && cp ${appTemplateDir}/jquery-3.1.1.min.js ${appIntegrationDir}/www/js ;\
		cp -r ${appTmpDir}/react ${appIntegrationDir}/www/react ;\
	elif [[ ${target} == ios ]]; then \
		mkdir -p ${appIntegrationDir}/BaoCai/Components ;\
		for comp in `echo ${components}`; do \
			targetFileName=`echo $${comp}|awk '{print $1}' FS=":"`; \
			mv ${appTmpDir}/$${targetFileName}.html ${appIntegrationDir}/BaoCai/Components ;\
			cp ${appTemplateDir}/$${comp}/* ${appIntegrationDir}/BaoCai ;\
		done;\
		cp ${appTemplateDir}/UIWebViewController.* ${appIntegrationDir}/BaoCai ;\
		cp -r ${appTmpDir}/react ${appIntegrationDir}/BaoCai/Components/react ;\
		npm run server ;\
	fi
	rm -rf ${appTmpDir}
	# Start the integrated system for WeChat
	if [[ ${target} == wechat ]]; then cd ${appIntegrationDir} && npm start ; fi

######## Sync to SVN ######## 
# Last modified: 2016-11-14 #
# Created by: Lin Sun       #
#############################
svnPath=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/App_H5_React
ifneq "${svn}" ""
		svnPath="${svn}"
endif
syncToSVN:
	cd ${svnPath} && svn update && svn delete --force ./* && rm -rf ./*
	cd ${svnPath} && svn propset svn:ignore --recursive "node_modules" .
	cp -r ./* ${svnPath}
	cd ${svnPath} && svn add ./* 
	cd ${svnPath} && svn commit -m "Sync from git repository"
