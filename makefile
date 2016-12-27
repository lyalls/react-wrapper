######## Src Builder ######## 
# Created at:    2016-11-14 #
# Created by: Lin Sun       #
# Last modified: 2016-12-27 #
# Modified by: Lin Sun      #
#############################
SHELL:=/bin/bash
# Please modify the src dir path
h5SrcDir=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/webapp/trunk/resources/web
ifneq "${h5src}" ""
	h5SrcDir=${h5src}
endif

appSrcDir=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/client_v2/iOS/trunk/BaoCai_New_Test
ifneq "${src}" "" 
	appSrcDir = ${src}
endif

doUpdateSourceFile=false
ifeq "${updateSrc}" "true"
	doUpdateSourceFile=true
endif

doCompileSource=true
ifeq "${compileSrc}" "false"
		doCompileSource=false
endif

doDistribute=false
ifeq "${dist}" "true"
	doDistribute=true
endif

webpackConfigFile=./src/apps/webpack.config.js
appIndexTemplateFile=./src/apps/index.js
platformPolygonFile=./src/apps/platform.js

appIntegrationBase=./integrations

# Do local test, DON'T modify original codes
wechat: appSrcDir=${h5SrcDir}
wechat: appIntegrationDir=./integrations/wechat
wechat: appTmpDir=./src/apps/wechat/tmp
wechat: appTemplateDir=./src/apps/wechat/templates
wechat: components="home:newhome" # "<component name>:<target template file name> <component name>:<target template file name> ..."
wechat: target=wechat
wechat: targetNameInAppIndex=Wechat
wechat: syncFromH5=${doUpdateSourceFile}

ios: appIntegrationDir=./integrations/ios
ios: appTmpDir=./src/apps/ios/tmp
ios: appTemplateDir=./src/apps/ios/templates
ios: components="home"
ios: target=ios
ios: targetNameInAppIndex=IOS
ios: syncFromH5=false


# DEBUG #
# REQUIRED PARAMETER: page=<page name>
debug: appSrcDir=${h5SrcDir}
debug: appIntegrationDir=./integrations/debug
debug: appTmpDir=./src/apps/debug/tmp
debug: appTemplateDir=./src/apps/mobile/templates
debug: components=${page}
debug: target=debug
debug: targetNameInAppIndex=Debug
debug: syncFromH5=false
# DEBUG #


debug wechat ios:
	# Prepare the environment, copy source code if not debugging raw page
	if [[ ${target} != debug ]];then \
		npm install ;\
		echo "SRC: " ${appSrcDir} ;\
		if [[ ${doUpdateSourceFile} == true ]];then svn update ${appSrcDir}; fi ;\
		mkdir -p ${appIntegrationDir} ;\
		if [[ ${target} == ios && -d ${appIntegrationDir}/BaoCai.xcworkspace ]];then \
			rsync -av ${appSrcDir}/ ${appIntegrationDir} --exclude='*.xcworkspace' ;\
		elif [[ ${target} != debug ]];then \
			rsync -av ${appSrcDir}/ ${appIntegrationDir} ;\
		fi ;\
	else \
		rm -rf ${appIntegrationDir} ;\
		mkdir -p ${appIntegrationDir} ;\
	fi
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
			elif [[ $${file} == app.less ]]; then \
				echo '@import "slick.less";' >> ./src/css/$${file} ;\
				echo '@import "slick-theme.less";' >> ./src/css/$${file} ;\
				echo '@import "react.components.less";' >> ./src/css/$${file} ;\
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
			sed "15,19 d; s/pages\/home/pages\/$${compName}/g" ${appIndexTemplateFile} > ${appTmpDir}/$${targetFileName}.js ;\
		else \
			sed "s/pages\/home/pages\/$${compName}/g" ${appIndexTemplateFile} > ${appTmpDir}/$${targetFileName}.js ;\
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
	cp ${platformPolygonFile} ${appTmpDir}/react
	# Post-process for Debug: 
	# Post-process for WeChat: 
		# Move the template files to wechat template direcotory; 
		# Modify index.html; 
		# Build the test project with these template files
	# Post-process for iOS:
		# Copy H5 files to iOS project, together with the controllers and webViewController
	if [[ ${target} == debug ]];then \
		cp -r ${appTmpDir}/react ${appIntegrationDir} ;\
		cp -r ${appTmpDir}/*.html ${appIntegrationDir} ;\
		cp -r ${appTemplateDir}/server ${appIntegrationDir} ;\
		cp -r ${appTemplateDir}/package.json ${appIntegrationDir} ;\
		sed "s/index.html/${page}.html/g" ${appTemplateDir}/server.js > ${appIntegrationDir}/server.js ;\
	elif [[ ${target} == wechat ]]; then \
		for comp in `echo ${components}`; do \
			templateFileName=`echo $${comp}|awk '{print $$2}' FS=":"` ; \
			mv ${appTmpDir}/$${templateFileName}.html ${appIntegrationDir}/src/templates ;\
		done ;\
		sed '/<script src="js\/app.min.js/,$$ d' ${appIntegrationDir}/src/html/index.html > ${appTmpDir}/tmp.html ;\
		echo '<script src="/js/jquery-3.1.1.min.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<script src="/js/app.min.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<script src="/react/platform.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<script src="/react/bundle.common.js"></script>' >> ${appTmpDir}/tmp.html ;\
		echo '<link rel="stylesheet" type="text/css" href="/react/bundle.style.css">' >> ${appTmpDir}/tmp.html ;\
		sed '1,/<script src="js\/app.min.js/ d' ${appIntegrationDir}/src/html/index.html >> ${appTmpDir}/tmp.html ;\
		mv ${appTmpDir}/tmp.html ${appIntegrationDir}/src/html/index.html ;\
		if [[ "${doCompileSource}" == "true" ]];then \
			export PATH=`pwd`/node_modules/.bin:$${PATH} && cd ${appIntegrationDir} && gulp build_q ;\
		fi; \
		cd - && cp ${appTemplateDir}/jquery-3.1.1.min.js ${appIntegrationDir}/www/js ;\
		cp -r ${appTmpDir}/react ${appIntegrationDir}/www/ ;\
		if [[ ${doDistribute} == true ]];then \
			cp -r ${appIntegrationDir}/www/* ${h5SrcDir}/www/ ;\
		fi; \
	elif [[ ${target} == ios ]]; then \
		rm -rf ${appIntegrationDir}/BaoCai/Components ;\
		mkdir -p ${appIntegrationDir}/BaoCai/Components ;\
		for comp in `echo ${components}`; do \
			targetFileName=`echo $${comp}|awk '{print $1}' FS=":"`; \
			mv ${appTmpDir}/$${targetFileName}.html ${appIntegrationDir}/BaoCai/Components ;\
			if [[ $${comp} == home ]];then \
				cp ${appTemplateDir}/$${comp}/* ${appIntegrationDir}/BaoCai/UI/Home/Controller ;\
			fi ;\
		done;\
		cp ${appTemplateDir}/UIWebViewController* ${appIntegrationDir}/BaoCai/UI/Base/Controller ;\
		cp -r ${appTmpDir}/react ${appIntegrationDir}/BaoCai/Components/react ;\
	fi
	# Clear the temporary workspace
	rm -rf ${appTmpDir} ;
	# Start the integrated system for WeChat
	if [[ ${target} == wechat ]]; then \
		cd ${appIntegrationDir} && npm start ;\
	elif [[ ${target} == debug ]];then \
		cd ${appIntegrationDir} && npm run server ;\
	fi

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

########### Clear ###########
# Last modified: 2016-12-1  #
# Created by: Lin Sun       #
#############################
clear:
	rm -rf node_modules integrations
	for app in `ls ./src/apps`; do \
		if [[ -d ./src/apps/$${app}/tmp ]]; then \
			rm -rf ./src/apps/$${app}/tmp ;\
		fi ;\
	done

