/*=====================================
=   配置文件
*   Author ： zhaoqiying
*   Date   ： 2015-05-21
=====================================*/
module.exports = function (config) {
    ////////////////////////////////////////////  
    config.websrc = 'www/**/*';
    config.public = '../../public';
    config.index = '../views';

    // Inject cordova script into html
    config.cordova = false;

    // Images minification
    config.minify_images = false;
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    // Development web server
    config.server.host = 'localhost';
    config.server.port = '9000';

    // Set to false to disable it:
    // config.server = false;
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    // Weinre Remote debug server

    config.weinre.httpPort = 9001;
    config.weinre.boundHost = 'localhost';
    config.weinre.verbose = true;
    config.weinre.debug = true;
    // Set to false to disable it:
    // config.weinre = false;
    ////////////////////////////////////////////    
    // 3rd party components
    // Underscore
    //jquery
    config.vendor.js.push('./bower_components/jquery/dist/jquery.js');
    config.vendor.js.push('./bower_components/iscroll/build/iscroll-zoom.js');
    config.vendor.js.push('./bower_components/mobile-angular-ui/dist/js/mobile-angular-ui.gestures.js');
//    config.vendor.js.push('./bower_components/underscore/underscore.js');
    config.vendor.js.push('./bower_components/angular-cookies/angular-cookies.js');
    config.vendor.js.push('./bower_components/angular-md5/angular-md5.js');
    config.vendor.js.push('./bower_components/angular-loading-bar/src/loading-bar.js');
    config.vendor.js.push('./bower_components/angular-progress-arc/angular-progress-arc.js');
    config.vendor.js.push('./bower_components/angular-bootstrap/ui-bootstrap-tpls.js');
    config.vendor.js.push('./bower_components/angular-notify/dist/angular-notify.js');
    ////////////////////////////////////////////
};
