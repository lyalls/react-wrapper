/* 
 Created on : 2015-5-8, 12:50:24
 Author     : zhaoqiying
 */
// 
// Here is how to define your module 
// has dependent on mobile-angular-ui

var WebApp = {};
WebApp.status = 0;
WebApp.statusPresent = 0;
var app = WebApp.Instance = angular.module('Baocai', [
    'ngRoute',
    'mobile-angular-ui',
    // touch/drag feature: this is from 'mobile-angular-ui.gestures.js'
    // it is at a very beginning stage, so please be careful if you like to use
    // in production. This is intended to provide a flexible, integrated and and 
    // easy to use alternative to other 3rd party libs like hammer.js, with the
    // final pourpose to integrate gestures into default ui interactions like 
    // opening sidebars, turning switches on/off ..
    'mobile-angular-ui.gestures',
    'angular-md5',
    'angular-loading-bar',
    'angular-progress-arc',
    //'ngDialog',
    //ui.bootstrap还在使用，1、用户页的导航条 2、充值、取现弹窗
    'ui.bootstrap',
    'cgNotify',
    'ngCookies',
    'highcharts-ng',
]);
// 
// You can configure ngRoute as always, but to take advantage of SharedState location
// feature (i.e. close sidebar on backbutton) you should setup 'reloadOnSearch: false' 
// in order to avoid unwanted routing.
// 
WebApp.Router = {
    HOME: '/', //首页、详情
    LOGIN: '/login', //登录
    LOGOUT: '/logout',
    REGISTER: '/reg', //注册
    REG_PROVISION: '/reg/provision',
    REG_NAME: '/reg/name', //用户密码设置
    VALIDATE_ID_CARD: '/reg/id/card', //实名认证
    REGISTER_SUCCESS: '/reg/sucess', //注册成功
    USER: '/users', //账户
    USER_PAYMENT: '/users/payments', //主人红包
    INVEST: '/invest', //投资
    INVEST_COUPONS: '/invest/coupons', //选择优惠券
    INVEST_LIST: '/invest/list',
    INVEST_GENERAL: '/invest/general',
    INVEST_DETAIL: '/invest/detail',
    INVEST_PERSON_LIST: '/invest/person/list', //投资人列表
    INVEST_BORROWER_DETAIL: '/invest/borrower/detail',
    INVEST_PRODUCT_RISKS: '/invest/product/risk',
    INVEST_PAYMENT_METHODS: '/invest/payment/method',
    RESET_VALIDATE_CODE: '/reset/validate/code', //重新设置交易密码
    RESET_NEW_PASSWORD: '/reset/new/password', //设置新密码
    POPUP_VALIDATE_ID: '/popup/validate/id',
    SET_PAY_PASSWORD: '/set/pay/password', //设置交易密码
    PRIVILEGE: '/privilege', //加息规则
    ABOUTUS: '/aboutus',
    APP_DOWNLOAD: '/download',
    USER_RECHARGE: '/users/recharge', //充值
    POPUP_ID_CARD: '/popup/id/card',
    BANK_RETURNS: '/bank/returns', //40倍银行收益
    HOLDING: '/holding', //上市公司控股
    SAFEGUARD: '/safeguard', //100%本息保障
    USER_SET: '/user/set', //个人设置
    USER_ASSET: '/user/asset', //个人资产
    MORE_BONUSE: '/more/bonuse', //更多红包
    CHANGE_LOGIN_PASSWORD: '/change/login/password', //修改登录密码
    CHANGE_DEAL_PASSWORD: '/change/deal/password', //修改交易密码
    SET_DEAL_PASSWORD: '/set/deal/password', //重新设置交易密码
    FIND_DEAL_PASSWORD: '/find/deal/password', //找回交易密码
    FIND_DEAL_PASSWORD2: '/find/deal/password2', //找回交易密码2
    COLLECTION_MONEY: '/collection/money', //代收资金
    SPECIAL_RIGHTS: '/special/rights', //主人特权、特权小金库
    RESULT: '/users/result', //结果详情
    USER_PRESENT: '/users/present', //取现
    USER_CARD: '/users/card', //添加银行卡
    USER_BANK: '/users/bank', //补全银行卡信息
    SMART_BID: '/smart/bid', //智能投标说明
    MONTH_GET: '/month/get', //每月随取1次
    EXPERIENCE: '/financing/experience', //体验标
    CASE_DOUGH: '/case/dough',
    CASE_DOUGH_RULES: '/case/dough/rules',
    CASE_DOUGH_INVESTS: '/case/dough/invests',
    EXPERIENCE_LIST: '/experience/list',
    USER_RED_PACKETS: '/users/red/packets', //红包券
    USER_RED_PACKETS_DETAILS: '/users/red/packets/details', //红包券详情
    INVEST_SUCCESS: '/invest/success', //投资
    CONPUS_RULE: '/conpus/rule', //优惠券规则
    INVESTS_SUCCESS: '/invests/success', //体验标投资成功
    INVEST_ENOUGH: '/invest/enough',
    TRADE_RECORD: '/users/trade/record', //交易记录
    THE_MONEY_GOES: '/the/money/goes',
    PHONE_CHECK: '/phone/check',
    OAUTH2_LOGIN: '/oauth2/login',
    INCREASE_LIST: '/increase/list',  // 加息券列表
    INCREASE_RULES: '/increase/rules',
    USERS_ACCOUNT: '/users/account',	//用户账户
    PROJECT_INTRO:'/project/intro',		//项目详情-项目介绍
    PROJECT_BORROWER:'/project/borrower',	//项目详情-借款人信息
    PROJECT_RECORDS:'/project/records',	//项目详情-投资记录
    PICTURE_VIEW:'/image/view',
    go: function (page, $location) {
        var uri = WebApp.Router[page.toUpperCase()];
        if (uri) {
            $location.path(uri);
        }
    },
    goback: function () {
        history.go(-1);
    }
};
// Rounter config
WebApp.Instance.config(function ($routeProvider) {
    // Baocai Project router
    $routeProvider
            .when(WebApp.Router.HOME, {
                //templateUrl: 'financing.html',
                templateUrl: 'newhome.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.LOGIN, {
                templateUrl: 'login.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.OAUTH2_LOGIN, {
                templateUrl: 'login_oauth2.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.LOGOUT, {
                templateUrl: 'home.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.REGISTER, {
                templateUrl: 'reg.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.REG_PROVISION, {
                templateUrl: 'reg_provision.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.REG_NAME, {
                templateUrl: 'reg_name.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.VALIDATE_ID_CARD, {
                templateUrl: 'reg_id_card.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.REGISTER_SUCCESS, {
                templateUrl: 'reg_success.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER, {
                templateUrl: 'users.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PRIVILEGE, {
                templateUrl: 'privilege.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_PAYMENT, {
                templateUrl: 'users_repayment.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.RESET_VALIDATE_CODE, {
                templateUrl: 'reset_validate_code.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.RESET_NEW_PASSWORD, {
                templateUrl: 'reset_new_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CONPUS_RULE, {
                templateUrl: 'conpusrule.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST, {
                templateUrl: 'invests.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_COUPONS, {
                templateUrl: 'invests_coupons.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_LIST, {
                //templateUrl: 'invest_list.html',
                templateUrl: 'product-list.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_DETAIL, {
                //templateUrl: 'invests_detail.html',
                templateUrl: 'product_detail.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_GENERAL, {
                templateUrl: 'invests_general.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_PERSON_LIST, {
                templateUrl: 'invests_person_list.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_BORROWER_DETAIL, {
                templateUrl: 'invests_borrower_detail.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_PRODUCT_RISKS, {
                templateUrl: 'invests_product_risks.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_PAYMENT_METHODS, {
                templateUrl: 'invests_payment_method_detail.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.POPUP_VALIDATE_ID, {
                templateUrl: 'popup.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.SET_PAY_PASSWORD, {
                templateUrl: 'set_pay_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.ABOUTUS, {
                templateUrl: 'aboutus.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_RECHARGE, {
                templateUrl: 'user_recharge.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.POPUP_ID_CARD, {
                templateUrl: 'popup_id_card.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.APP_DOWNLOAD, {
                templateUrl: 'download.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.BANK_RETURNS, {
                templateUrl: 'bank_returns.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.SAFEGUARD, {
                templateUrl: 'safeguard.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_SET, {
                templateUrl: 'user_set.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_ASSET, {
                templateUrl: 'user_asset.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.MORE_BONUSE, {
                templateUrl: 'more_bonuse.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CHANGE_LOGIN_PASSWORD, {
                templateUrl: 'change_login_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CHANGE_DEAL_PASSWORD, {
                templateUrl: 'change_deal_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.SET_DEAL_PASSWORD, {
                templateUrl: 'set_deal_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.FIND_DEAL_PASSWORD, {
                templateUrl: 'find_deal_password.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.FIND_DEAL_PASSWORD2, {
                templateUrl: 'find_deal_password2.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.COLLECTION_MONEY, {
                templateUrl: 'collection_money.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.SPECIAL_RIGHTS, {
                templateUrl: 'special_rights.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.HOLDING, {
                templateUrl: 'holding.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.RESULT, {
                templateUrl: 'result.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_PRESENT, {
                templateUrl: 'user_present.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_CARD, {
                templateUrl: 'user_card.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_BANK, {
                templateUrl: 'user_bank.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.SMART_BID, {
                templateUrl: 'smart_bid.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.MONTH_GET, {
                templateUrl: 'month_get.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.EXPERIENCE, {
                templateUrl: 'financing_experience.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CASE_DOUGH, {
                templateUrl: 'case_dough.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CASE_DOUGH_RULES, {
                templateUrl: 'case_dough_rules.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.CASE_DOUGH_INVESTS, {
                templateUrl: 'case_dough_invest.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.EXPERIENCE_LIST, {
                templateUrl: 'experience_list.html',
                reloadOnSearch: false
            })
            //red-packets
            .when(WebApp.Router.USER_RED_PACKETS, {
                templateUrl: 'users_red_packets.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USER_RED_PACKETS_DETAILS, {
                templateUrl: 'users_red_packets_details.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_SUCCESS, {
                templateUrl: 'invest_success.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVESTS_SUCCESS, {
                templateUrl: 'invests_success.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INVEST_ENOUGH, {
                templateUrl: 'invest_enough.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.TRADE_RECORD, {
                templateUrl: 'trade_record.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.THE_MONEY_GOES, {
                templateUrl: 'the_money_goes.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PHONE_CHECK, {
                templateUrl: 'phone_check.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INCREASE_LIST, {
                templateUrl: 'increase_list.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.INCREASE_RULES, {
                templateUrl: 'increase_rules.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.USERS_ACCOUNT, {
                templateUrl: 'users_account.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PROJECT_INTRO, {
                templateUrl: 'project_intro.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PROJECT_BORROWER, {
                templateUrl: 'project_borrower.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PROJECT_RECORDS, {
                templateUrl: 'project_records.html',
                reloadOnSearch: false
            })
            .when(WebApp.Router.PICTURE_VIEW, {
                templateUrl: 'imageView.html',
                reloadOnSearch: false
            })
            .otherwise({
                redirectTo: '/'
            });

});
/*----------------------------------------------------------------------------------------------------------------------
 APPLICATION CONFIG
 
 An object that contains general application configuration
 ----------------------------------------------------------------------------------------------------------------------*/
WebApp.Instance.factory('HttpInterceptor', ["$q", function ($q) {
        return {
            request: function (config) {
                var token = WebApp.ClientStorage.getCurrentToken();
                if (token) {
                    config.headers['X-Authorization'] = token;
                }
                return config;
            },
            responseError: function (response) {
                if (!angular.isObject(response.data)) {
                    response.data = {code: 500, message: "访问出错，请重试！", data: null, time: ''};
                }
                return $q.reject(response);
            }
        };
    }]);
// 
WebApp.Instance.config(function ($httpProvider) {
    $httpProvider.interceptors.push('HttpInterceptor');
});
// Loading Bar
WebApp.Instance.config(function (cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
    cfpLoadingBarProvider.latencyThreshold = 50;
});

WebApp.Instance.run(['$rootScope', '$window', '$location', '$log', '$timeout', 'AccountService', function ($rootScope, $window, $location, $log, $timeout, AccountService) {

        var locationChangeStartOff = $rootScope.$on('$locationChangeStart', locationChangeStart);

        function locationChangeStart(event) {
            if(WebApp.mInstance)
            {
                WebApp.mInstance.close();
                WebApp.mInstance = null;
            }

            var Uphone = WebApp.ClientStorage.getCurrentUser();
            if(!Uphone){
                AccountService.myAccountINfo(function (data) {
                    Uphone = data;
             }, function (data) {
             });
            }
            var nowUrl = $location.absUrl();
            var spliturl = nowUrl.split('baocai.com')[1];

            if (Uphone != null)
            {
                if (Uphone.phone == "" && spliturl != '/#/phone/check')
                {
                    $timeout(function () {
                        $location.path(WebApp.Router.PHONE_CHECK);
                    }, 0);
                }
            }
        }

    }]);
/*----------------------------------------------------------------------------------------------------------------------
 *                              APPLICATION UI
 *
 ----------------------------------------------------------------------------------------------------------------------*/

WebApp.UI = {
    alert: function (data, $location, $timeout) {
        var msg = '网络出现问题，请重试。';
        if (angular.isObject(data)) {
            if (data.code >= 300) {
                if (data.code == 401) {
                    $timeout(function () {
                        $location.path(WebApp.Router.LOGIN);
                    }, 0);
                    return;
                }
                var message = data.message;
                if (angular.isArray(message)) {
                    msg = message[0];
                } else if (angular.isString(message)) {
                    msg = message;
                }
            }
        }
        alert(msg);
    }
};
//处理服务端返回信息
WebApp.dealHttp = function (data, $location, $timeout) {
    var msg = '网络出现问题，请重试';
    if (angular.isObject(data)) {
        if (data.code >= 300) {
            if (data.code == 401) {
                $timeout(function () {
                    $location.path(WebApp.Router.LOGIN);
                }, 0);
                return "请重新登录后重试";
            }
            if (data.code == 400) {
                var message = data.message;
                if (angular.isArray(message)) {
                    return message[0];
                } else if (angular.isString(message)) {
                    return message;
                }
            } else {
                return msg;
            }
        }
    }
};

WebApp.Value = {
    getStoreVal: function (key, value, $location, $timeout) {
        if (!value) {
            value = WebApp.ClientStorage.retrieve(key);
            if (!value) {
                //  默认无参数跳转到首页
                $timeout(function () {
                    $location.path(WebApp.Router.HOME);
                }, 0);
            }
            return value;
        }
        WebApp.ClientStorage.store(key, value);
        return value;

    }

};

WebApp.tmpValue = {
    setOrGetStoreVal: function (key, value) {
        if (!value) {
            value = WebApp.ClientStorage.retrieve(key);
            return value;
        }
        WebApp.ClientStorage.store(key, value);
        return value;

    }

};

WebApp.duration = 3000;
/*----------------------------------------------------------------------------------------------------------------------
 *                              APPLICATION ROUTER
 *
 *  A module that manages the URL routes of the application. It exposes a convenient API for navigation to top-level
 *  application pages (Home, Users, Groups, etc)
 *--------------------------------------------------------------------------------------------------------------------*/
WebApp.Config = {
};
// *--------------------------------------------------------------------------------------------------------------------*//
/* 
 =============================================
 =============================================
 =============================================
 =============================================
 =============================================
 Author     : zhaoqiying
 */
// Application Core Fuctions
var ApplicationCore = (function () {
    "use strict";

    var ApplicationState = {
        INITIALIZING: "initializing",
        INITIALIZED: "initialized"
    },
    state;
    /**
     * Returns true if the specified name is a valid namespace string
     *
     * @param name          the name to use as a namespace
     * @return true if the string is a valid namespace; false otherwise
     */
    function isValidNamespace(name) {
        return (name.charAt(0) !== "." && name.charAt(name.length - 1) !== "." && (name.indexOf("..") === -1));
    }

    /**
     * Creates a namespace by splitting the provided string and parsing to generate the required structure.
     * The method checks for the validity of the path and also maintains the integrity of any existing object being
     * used as parent
     *
     * @param namespace         the namespace to create
     * @return the newly created namespace
     */
    function createNamespace(namespace) {

        if (!isValidNamespace(namespace)) {
            throw new Error("Please provide a valid namespace to create.");
        }

        var container = window,
                parts = namespace.split(".");

        for (var i = 0, len = parts.length; i < len; i++) {
            var part = parts[i];
            container = container[part] || (container[part] = {});
        }

        return container;
    }


    /**
     * Logs a message to the browser's console if it exists; otherwise outputs an alert message
     */
    function log() {
        try {
            console.log.apply(console, arguments);
        } catch (exception) {
            try {
                opera.postError.apply(opera, arguments);
            } catch (ex) {
                alert(Array.prototype.join.call(arguments, ""));
            }
        }
    }


    /**
     * Generates a sequential unique ID (number)
     *
     * @return an incremental integer
     */
    function generateUID() {
        return WebApp.UID++;
    }

    /**
     * Returns the current state of the application
     *
     * @return the current state of the application
     */
    function getApplicationState() {
        return state;
    }

    /**
     * Sets the initialization state of the WebApp application to the given value
     *
     * @param initialized               a flag that specifies whether the application is initialized
     */
    function setInitialized(initialized) {
        state = ApplicationState[(initialized) ? "INITIALIZED" : "INITIALIZING"];
    }


    /**
     * Returns true if the application is initialized; otherwise, returns false
     *
     * @return true if the application is initialized; otherwise, returns false
     */
    function isInitialized() {
        return (state === ApplicationState.INITIALIZED);
    }

    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
                .toString(16)
                .substring(1);
    }


    /**
     * Returns a unique UID
     *
     * @returns a unique UID
     */
    function guid() {
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                s4() + '-' + s4() + s4() + s4();
    }

    return {
        getApplicationState: getApplicationState,
        createNamespace: createNamespace,
        setInitialized: setInitialized,
        isInitialized: isInitialized,
        generateUID: generateUID,
        guid: guid,
        log: log
    };

})();
// merge
angular.extend(WebApp, ApplicationCore);

WebApp.UID = 1;
WebApp.createNamespace("WebApp.UI");
WebApp.createNamespace("WebApp.Model");
WebApp.createNamespace("WebApp.Controllers");
WebApp.createNamespace("WebApp.Directives");
WebApp.createNamespace("WebApp.Filters");
WebApp.createNamespace("WebApp.Router");



/*----------------------------------------------------------------------------------------------------------------------
 CLASS CREATION AND INHERITANCE
 
 This module defines an inheritance system for the application. The "inherits" method sets the prototype chain between a
 class and its superclass, and the "create" method generates a constructor function that contains the inheritance chain
 as well as references to its superclass and subclasses.
 
 This system also allows a subclass to invoke a method of its superclass by using the following syntax:
 this._super(arguments)
 ----------------------------------------------------------------------------------------------------------------------*/

WebApp.Class = {
    /**
     * Creates an inheritance chain for a subclass by inheriting properties from the superclass. It also adds a
     * convenient "superclass" reference to the superclass
     *
     * @param child         the subclass to create
     * @param parent        the superclass to inherit from
     * @return a subclass that inherits from the superclass specified
     */
    inherits: (function () {
        function F() {
        }

        return function (child, parent) {
            F.prototype = (angular.isFunction(parent)) ? parent.prototype : parent;
            child.prototype = new F();
            child.prototype.constructor = child;
            child.superclass = parent;

            return child;
        };

    })(),
    /**
     * Creates a controller with the given methods. It then establishes its inheritance if the parent parameter is
     * provided
     *
     * @param child                 the child controller to create
     * @param parent                the parent from which to inherit common methods
     * @param methods               the additional methods to define for the child controller
     * @throws an "InvalidArguments" exception if the number of arguments provided is less than 2
     * @returns a reference to the WebApp.Class module
     */
    createController: function (child, parent, methods) {
        var invalidParams = (arguments.length < 2);

        if (invalidParams) {
            throw {
                name: "InvalidArguments",
                message: "'createController' requires at least 2 parameters"
            };
        }

        var superclass, properties;

        if (arguments.length === 2) {
            properties = arguments[1];
            if (angular.isFunction(properties)) {
                WebApp.Class.inherits(child, properties);
            } else {
                WebApp.Class.addMethods(child, properties);
            }
        } else {
            superclass = parent;
            properties = methods;

            if (superclass) {
                WebApp.Class.inherits(child, superclass);
            }

            WebApp.Class.addMethods(child, properties);
        }

        return this;
    },
    /**
     * Adds the methods defined in the "methods" object to the prototype of this child
     *
     * @param child              the child constructor to add the methods to. Must be a function
     * @param methods            an object that contains the methods to add
     * @returns a reference to the WebApp.Class
     */
    addMethods: function (child, methods) {
        if (angular.isFunction(child)) {
            angular.extend(child.prototype, methods || {});
        }

        return this;
    },
    /**
     * Creates a new class from the specified argument objects. If the parent is provided, thenthe class inherits from the superclass and can invoke the superclass methods through the
     * "this._super" syntax
     *
     * @param parent            the superclass to inherit from (optional)
     * @param props             the mixin object containing the properties and methods to add to the
     *                          class' prototype
     * @return a new class with the specified properties and methods
     */
    create: function (parent, props) {
        var superclass = parent,
                properties = props,
                _superPrototype,
                inherits = WebApp.Class.inherits;
        var fnTest = /xyz/.test("function() { xyz; }") ? /\b_super\b/ : /.*/;

        /**
         If a single argument was provided, then we're creating a new class: use the argument as a mixin for the new
         class and set the superclass to null
         */
        if (arguments.length === 1) {
            superclass = null;
            properties = arguments[0];
        }

        /**
         If more than 1 argument are provided, save a reference to the prototype of the
         superclass in a "_superPrototype" variable; it'll be used later for augmenting
         the subclass' prototype
         */
        if (superclass && superclass.prototype) {
            _superPrototype = superclass.prototype;
        }

        /**
         * This is the main constructor function that will be augmented and returned. Sets a
         * "superclass" property that references the parent constructor, creates a "subclasses"
         * array to hold subclasses that will be created from it, and augments it with the superclass'
         * prototype
         */
        function Class() {
            this.initialize.apply(this, arguments);
        }

        Class.subclasses = [];

        /**
         * If a superclass was provided, set the inheritance chain and add this class
         * as a subclass of the parent
         */
        if (superclass) {
            inherits(Class, superclass);

            if (superclass.subclasses) {
                superclass.subclasses.push(Class);
            }
        }

        /**
         * Copy the properties of the provided mixin to those of the constructor's prototype.
         * If the value of a property is a function and the serialized body of the method
         * contains the "_super" keyword, then create a temporary "_super" property on the constructor
         * that invokes the parent's inherited method
         */
        // bugfix: make a function in the loop
        var callProperty = function (name, fn) {
            return function () {
                var temp = this._super || null;

                /** Add a new "_super" method that's the same but on the parent */
                this._super = _superPrototype[name];

                /**
                 * The method needs to be bound only once, so we remove it
                 * when we're done invoking it
                 */
                var returnValue = fn.apply(this, arguments);
                this._super = temp;

                return returnValue;
            };
        };
        for (var name in properties) {
            Class.prototype[name] = (angular.isFunction(properties[name]) &&
                    (_superPrototype && angular.isFunction(_superPrototype[name])) &&
                    (fnTest.test(properties[name]))) ?
                    callProperty(name, properties[name]) : properties[name];
        }

        if (!Class.prototype.initialize) {
            Class.prototype.initialize = Function.empty;
        }

        return Class;
    },
    /**
     * Returns true if the class instance specified implements the method specified; otherwise,
     * returns false
     *
     * @param instance              the instance to check for the implementation of the method
     * @param method                the method to look for in the instance specified
     * @return true if the instance implements the method specified; otherwise, returns false
     */
    implementsMethod: function (instance, method) {
        return (method in instance);
    }

};


/*---------------------------------------------------------------------------------------------------------------------
 *                          COMPONENT MANAGER
 * A module that manages the registration of Angular components: controllers, directives, filters, etc. It exposes a
 * simplified API for creating those components
 *--------------------------------------------------------------------------------------------------------------------*/
(function (ng) {
    var controllers = {};


    /**
     * Registers a controller with the given name
     *
     * @param name                  the name of the controller to register
     * @param constructor           the constructor function for the controller (invoked by Angular)
     */
    function register(name, constructor) {
        var exists = (name in controllers);

        if (exists) {
            return;
        }

        controllers[name] = constructor;
        onControllerRegistered();
    }

    /**
     * Returns the controller attached to the DOM element with the given ID. This ID might be different than the name
     * of the controller (i.e. ng-controller="ngControllerID"), so it's recommend to give the container DIV the same ID
     * as the name of the controller (i.e. <div id="myController" ng-controller="myController")
     *
     * @param id                the ID of the DOM element to which the controller is attached
     * @returns a reference to the Angular controller attached to the DOM element with the given ID
     */
    function getByID(id) {
        var element = document.getElementById(id),
                isValidElement = angular.isElement(element);

        return (isValidElement) ? ng.element(element).controller() : null;
    }


    /**
     * Returns the scope for the controller attached to the DOM element with the given ID. The controller ID might be
     * different than the name of the controller (i.e. ng-controller="ngControllerID"), so it's recommend to give the container DIV the same ID
     * as the name of the controller (i.e. <div id="myController" ng-controller="myController")
     *
     * @param controllerID       the ID of the DOM element to which the controller is attached
     * @returns a reference to the Angular scope for the controller attached to the DOM element with the given ID
     */
    function getScope(controllerID) {
        var element = document.getElementById(controllerID),
                isValidElement = angular.isElement(element);

        return (isValidElement) ? ng.element(element).scope() : null;
    }

    /**
     * Returns the root scope of the application
     *
     * @returns the root scope of the application
     */
    function getRootScope() {
        return ng.element(document).scope();
    }


    /**
     * A callback method invoked when a new controller is registered. It invokes the Angular logic for creating
     * the new controller
     */
    function onControllerRegistered() {
        WebApp.Application.getInstance().controller(controllers);
    }

    WebApp.Controllers.register = register;
    WebApp.Controllers.getByID = getByID;
    WebApp.Controllers.getScope = getScope;
    WebApp.Controllers.getRootScope = getRootScope;

})(angular);

/*----------------------------------------------------------------------------------------------------------------------
 CLIENT STORAGE
 
 A module that manages the persistent storage of application data using the "localStorage" feature of HTML5,
 currently supported by most browsers (Safari, Chrome, Firefox, IE8+, etc).
 
 It exposes a unified API used to store and retrieve application data
 ----------------------------------------------------------------------------------------------------------------------*/

WebApp.ClientStorage = (function () {

    var sessionStorageSupported = ("sessionStorage" in window),
            TOKEN_KEY = 'X-Authorization',
            USER_KEY = 'm.baoca.user',
            ACCOUNT_KEY = 'm.baocai.user.mybaocai',
            BORROW_ID = 'm.baocai.invest.id',
            NO_AGREE = 'm.baocai.payment.noAgree';

    if (!sessionStorageSupported) {
        alert('不支持HTML5 sessionStorage, 请使用现代浏览器');
    }

    /**
     * Stores the given value in the specified key
     *
     * @param key               the key under which to store the value
     * @param {type} value      the value to store for the key
     * @returns the newly stored value
     */
    function store(key, value) {
        value = (angular.isString(value) || angular.isNumber(value)) ? value : JSON.stringify(value);
        try {
            sessionStorage.setItem(key, value);
        } catch (oException) {
            if (oException.name == 'QuotaExceededError') {
                alert('本网站不支持无痕浏览，访问时请关闭无痕浏览。');
                sessionStorage.clear();
                sessionStorage.setItem(key, value);
            }
        }
    }


    /**
     * Returns the value for the given key
     *
     * @param key               the key for which to return the value
     * @returns the value for the given key
     */
    function retrieve(key) {
        var value = (containsKey(key)) ? sessionStorage[key] : null,
                jsonData;

        if (!value) {
            return value;
        }

        try {

            jsonData = JSON.parse(value);
            value = jsonData;

        } catch (jsonException) {

        }

        return value;
    }


    /**
     * Removes the value for the given key
     *
     * @param key               the key for which to remove the value
     */
    function remove(key) {
        if (containsKey(key)) {
            removed = delete sessionStorage[key];
        }
    }


    /**
     * Returns the total number of elements in the local storage
     *
     * @returns the total number of elements in the local storage
     */
    function size() {
        return sessionStorage.length;
    }


    /**
     * Clears the content of the local storage
     */
    function clear() {
        return sessionStorage.clear();
    }


    /**
     * Returns true if there's a value stored in the given key; otherwise, returns false
     *
     * @param key
     * @returns true if there's a value stored in the given key; otherwise, returns false
     */
    function containsKey(key) {
        return (key in sessionStorage);
    }


    /**
     * Stores the current token
     *
     * @param token              the current token to store
     * @returns the newly stored token
     */
    function setCurrentToken(token) {
        return store(TOKEN_KEY, token);
    }


    /**
     * Returns the current token in the application
     *
     * @returns the current token in the application
     */
    function getCurrentToken() {
        return (containsKey(TOKEN_KEY)) ? retrieve(TOKEN_KEY) : null;
    }

    /**
     * Stores the current user
     *
     * @param user              the current user to store
     * @returns the newly stored user
     */
    function setCurrentUser(user) {
        return store(USER_KEY, user);
    }


    /**
     * Returns the current user in the application
     *
     * @returns the current user in the application
     */
    function getCurrentUser() {
        return (containsKey(USER_KEY)) ? retrieve(USER_KEY) : null;
    }

    function setCurrentAccount(account) {
        return store(ACCOUNT_KEY, account);
    }

    function getCurrentAccount() {
        return (containsKey(ACCOUNT_KEY) ? retrieve(ACCOUNT_KEY) : null);
    }

    /*
     * 
     * @param {type} agree
     * @returns {unresolved}用户前协议编号存储
     */
    function setCurrentNoAgree(agree) {
        return store(NO_AGREE, agree);
    }

    function getCurrentNoAgree() {
        return (containsKey(NO_AGREE) ? retrieve(NO_AGREE) : null);
    }



    return {
        store: store,
        retrieve: retrieve,
        remove: remove,
        size: size,
        clear: clear,
        containsKey: containsKey,
        setCurrentToken: setCurrentToken,
        getCurrentToken: getCurrentToken,
        setCurrentUser: setCurrentUser,
        getCurrentUser: getCurrentUser,
        setCurrentAccount: setCurrentAccount,
        getCurrentAccount: getCurrentAccount,
        setCurrentNoAgree: setCurrentNoAgree,
        getCurrentNoAgree: getCurrentNoAgree
    };
})();


/*----------------------------------------------------------------------------------------------------------------------
 CLIENT SESSION
 
 A module that manages the client-side session for a given user. It sets the duration of the session in
 
 It exposes a unified API used to store and retrieve application data
 ----------------------------------------------------------------------------------------------------------------------*/

WebApp.ClientSession = (function () {

    "use strict";

    var sessionTimer = null,
            ONE_MINUTE = 60 * 1000,
            duration = 30 * ONE_MINUTE,
            sessionActive = false;
    var callbacks = [];

    return {
        /**
         * Sets the duration of the session to the specified value, in seconds
         *
         * @param sessionDuration           the duration of the session, in seconds
         */
        setDuration: function (sessionDuration) {
            duration = sessionDuration * ONE_MINUTE;
            return this;
        },
        /**
         * Adds a callback method to invoke when a session event occurs
         *
         * @param callback                  the callback method to invoke when a session event occurs
         */
        addCallback: function (callback) {
            if (angular.isFunction(callback)) {
                callbacks.push(callback);
            }

            return this;
        },
        /**
         * Removes a previously registered session callback
         *
         * @param callback                  the session callback to remove
         */
        removeCallback: function (callback) {
            for (var i = callbacks.length - 1; i >= 0; i--) {
                if (callbacks[i] === callback) {
                    callbacks.splice(i, 1);
                }
            }

            return this;
        },
        /**
         * Initializes the client session: it sets the session timeout variable
         * and observes common browser events that cause the session timeout to
         * be reset (mousemove, window resize, etc)
         */
        start: function () {
            this.restartSessionTimer();
            this.observeBrowserEvents();
            sessionActive = true;

            this.sendNotification("session:started", {
                starTime: +new Date()
            });

            return this;
        },
        /**
         * Observes mouse move events that imply that there's an activity in the browser and that the session
         * timer should be reset
         */
        observeBrowserEvents: function () {
            angular.element(document).bind("mousemove", this.onBrowserActivity.bind(this));
            angular.element(document).bind("touchmove", this.onBrowserActivity.bind(this));
            return this;
        },
        /**
         * A callback method that is invoked when an activity occurs in the browser. It resets the session timer
         *
         * @param event                     the event that triggers the reset
         */
        onBrowserActivity: function (event) {
            if (sessionTimer) {
                clearTimeout(sessionTimer);
                sessionTimer = null;
            }

            this.restartSessionTimer();
        },
        /**
         * Starts or restarts the timer that ends the user's session after a given period of inactivity
         */
        restartSessionTimer: function () {
            sessionTimer = setTimeout(function () {
                this.stop();
            }.bind(this), duration);

            return this;
        },
        /**
         * Redirects the user to the store list page when the session times out
         */
        stop: function () {
            if (sessionTimer) {
                clearTimeout(sessionTimer);
                sessionTimer = null;
            }

            this.stopObservingBrowserEvents();
            sessionActive = false;

            this.sendNotification("session:ended", {
                endTime: +new Date()
            });
        },
        /**
         * Sends a notification when a session event occurs
         *
         * @param name                  the name of the notification to send
         * @param data                  an object that contains details of the notification
         */
        sendNotification: function (name, data) {
            data.eventName = name;

            callbacks.forEach(function (callback) {
                callback(data);
            });

            return this;
        },
        /**
         * Stops observing browser event
         */
        stopObservingBrowserEvents: function () {
            angular.element(document).unbind("mousemove");
            angular.element(document).unbind("touchmove");
            return this;
        },
        /**
         * Returns true if the client has an active session; otherwise, returns false.
         *
         * @returns true if the client has an active session; otherwise, returns false
         */
        isSessionActive: function () {
            return !!(sessionActive = WebApp.ClientStorage.retrieve("sessionActive"));
        }
    };

})();
