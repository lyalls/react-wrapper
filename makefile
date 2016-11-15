svnPath=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/App_H5_React
ifneq "${svn}" ""
		svnPath="${svn}"
endif
##### WeChat Builder ######## 
# Last modified: 2016-11-14 #
# Created by: Lin Sun       #
#############################
# Please modify the src dir path
wechatSrcDir=/Users/sunl/Dev/PROJECTS/baocai/baocainet/mbaocai/webapp/trunk/resources/web
ifneq "${src}" ""
	wechatSrcDir="${src}"
endif
# Do local test, DON'T modify original codes
wechatTestDir=./integrations/wechat
wechatTmpDir=./src/apps/wechat/tmp
wechatTemplateDir=./src/apps/wechat/template
wechatPages="home:newhome" # <page name>:<target template file name>
export PATH=$PATH:`pwd`/node_modules/.bin
buildWechat:
	# Prepare the environment
	svn update ${wechatSrcDir}
	mkdir -p ${wechatTestDir}
	rm -rf ${wechatTestDir}
	cp -r ${wechatSrcDir} ${wechatTestDir}
	rm -rf ${wechatTmpDir}
	mkdir -p ${wechatTmpDir}
	cp ${wechatTemplateDir}/webpack.config.js ${wechatTmpDir}
	# Copy CSS & image files
	cp ${wechatSrcDir}/src/images/* ./src/images
	cp ${wechatSrcDir}/src/less/* ./src/css
	# Fix less import problem
	for file in `ls ./src/css`; do \
		sed 's/import "mobile-angular-ui/import "\.\.\/\.\.\/bower_components\/mobile-angular-ui/g' ./src/css/$${file} > ${wechatTmpDir}/tmp.less;\
		mv ${wechatTmpDir}/tmp.less ./src/css/$${file};\
	done
	# Prepare the webpack config file
	rm -rf ${wechatTmpDir}/tmp.js ${wechatTmpDir}/tmpHead.js ${wechatTmpDir}/tmpTail.js
	sed '/index: __dirname/,$$ d' ${wechatTemplateDir}/webpack.config.js > ${wechatTmpDir}/tmpHead.js
	sed '1,/index: __dirname/ d' ${wechatTemplateDir}/webpack.config.js > ${wechatTmpDir}/tmpTail.js
	# Generate target pages according template, and, generate the webpack config file accordingly
	for page in `echo ${wechatPages}`; do \
		pageName=`echo $${page}|awk '{print $$1}' FS=":"` ; \
		templateFileName=`echo $${page}|awk '{print $$2}' FS=":"` ; \
		sed "s/bundle.index.js/bundle.$${templateFileName}.js/g" ${wechatTemplateDir}/index.html > ${wechatTmpDir}/$${templateFileName}.html ;\
		sed "s/pages\/home/pages\/$${pageName}/g" ${wechatTemplateDir}/index.js > ${wechatTmpDir}/$${templateFileName}.js ;\
		echo "        $${templateFileName}: __dirname + '/$${templateFileName}.js'," >> ${wechatTmpDir}/tmp.js ;\
	done
	cat ${wechatTmpDir}/tmpHead.js ${wechatTmpDir}/tmp.js ${wechatTmpDir}/tmpTail.js > ${wechatTmpDir}/webpack.config.js
	rm -rf ${wechatTmpDir}/tmp.js ${wechatTmpDir}/tmpHead.js ${wechatTmpDir}/tmpTail.js
	# Run the webpack to build target pages
	cd ${wechatTmpDir} && webpack --config webpack.config.js --progress --colors --inline
	# Move the template files to wechat template direcotory
	for page in `echo ${wechatPages}`; do \
		templateFileName=`echo $${page}|awk '{print $$2}' FS=":"` ; \
		mv ${wechatTmpDir}/$${templateFileName}.html ${wechatTestDir}/src/templates ;\
	done
	# Modify index.html
	sed '/<script src="js\/app.min.js/,$$ d' ${wechatTestDir}/src/html/index.html > ${wechatTmpDir}/tmp.html
	echo '<script src="/js/jquery-3.1.1.min.js"></script>' >> ${wechatTmpDir}/tmp.html
	echo '<script src="/js/app.min.js"></script>' >> ${wechatTmpDir}/tmp.html
	echo '<script src="/react/bundle.common.js"></script>' >> ${wechatTmpDir}/tmp.html
	echo '<script src="/react/bundle.css.js"></script>' >> ${wechatTmpDir}/tmp.html
	sed '1,/<script src="js\/app.min.js/ d' ${wechatTestDir}/src/html/index.html >> ${wechatTmpDir}/tmp.html
	mv ${wechatTmpDir}/tmp.html ${wechatTestDir}/src/html/index.html
	# Build the test project with these template files
	#cd ${wechatTestDir} && rm -rf node_modules && npm i 
	cd ${wechatTestDir} && gulp build_q
	cp ${wechatTemplateDir}/jquery-3.1.1.min.js ${wechatTestDir}/www/js
	cp -r ${wechatTmpDir}/react ${wechatTestDir}/www/react
	rm -rf ${wechatTmpDir}
	cd ${wechatTestDir} && npm start

syncToSVN:
	cd ${svnPath} && svn update && svn delete --force ./* && rm -rf ./*
	cd ${svnPath} && svn propset svn:ignore --recursive "node_modules" .
	cp -r ./* ${svnPath}
	cd ${svnPath} && svn add ./* 
	cd ${svnPath} && svn commit -m "Sync from git repository"
