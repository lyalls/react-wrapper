//
// For this trivial demo we have just a unique Controller 
// for everything
//
WebApp.Instance.controller('LoginController', function ($rootScope, $scope, $location, md5, LoginService, AccountService,RegisterService, notify, $timeout, $routeParams,$interval,$cookies) {
    notify.closeAll();
    $scope.keywords = "";
    $scope.password = "";
    $scope.errorMessage = "";
    $scope.valueTest = false;
    $scope.has_phone_check = true;
    $scope.has_phone_check_ok = false;    

    //登录
    $scope.loginStatus = 0;
    $scope.login = function () {
        if (!$scope.keywords || !$scope.password) {
            notify.closeAll();
            notify({message: "账号或密码不能为空", duration: WebApp.duration});
            $scope.loginStatus = 0;
            return;
        }
        if ($scope.loginStatus !== 0) {
            $timeout(function () {
                $scope.loginStatus = 0;
            }, 2000);
            return;
        }
        $scope.loginStatus = 1;
        var password = md5.createHash($scope.password || "");
        var keywords = $scope.keywords;
        $scope.checked = true;

        LoginService.doLogin({keywords: keywords, password: password}, function (data) {
            notify.closeAll();

            $scope.validateLoginName = false;
            $scope.checked = "true";
            //保存登录用户Token
            
            WebApp.ClientStorage.setCurrentToken(data.token);

            //保存登录用户信息
            WebApp.ClientStorage.setCurrentUser(data);
            WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', data);
            //页面跳转

            if(data.phone=="")
            {
                $scope.has_phone_check = false;
                return false;
            };
            // login_url 
            var login_url = $cookies.get('login_url');
            if(login_url)
            {
                $cookies.remove('login_url');
                 $timeout(function () {
                    $location.path(login_url);
                }, 0);
            }
            else
            {
                $timeout(function () {
                    $location.path(WebApp.Router.HOME);
                }, 0);
            }   


        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});

        });
        //登录埋点
        window._hmt && window._hmt.push(['_trackEvent', 'login', 'click', 'phone', keywords]);
    };

    //忘记密码
    $scope.toForget = function () {
        notify.closeAll();
        $timeout(function () {
            $location.path(WebApp.Router.RESET_VALIDATE_CODE);
        }, 0);
    };

    //退出登录
    $scope.logout = function () {
        LoginService.doLogout(function (data) {
            notify.closeAll();
            //WebApp.ClientStorage.clear();
            WebApp.ClientStorage.setCurrentToken("");
            WebApp.ClientStorage.setCurrentUser("");

            $timeout(function () {
                $location.path(WebApp.Router.HOME);
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //跳转到手机验证页面
    $scope.toPhonecheck = function (){
        notify.closeAll();
        $timeout(function () {
            $location.path(WebApp.Router.PHONE_CHECK);
        }, 0);
    };    

    $scope.statusClock = true;

    $scope.toGetPhonecheckCode = function (){
        var mobilePhoneExp = /^(13|14|15|17|18)\d{9}$/g;
        var fphone = $scope.phonenumber;
        var validity = mobilePhoneExp.test(fphone);    
        if (!validity) {            
            notify.closeAll();
            notify({message: "手机号码格式不正确", duration: WebApp.duration});
            return false;
        };

        RegisterService.checkPhone({phone: fphone}, function (data) {            
            LoginService.getPhonecode({
                phone: fphone
            },function(data){                      
            $scope.countdown = 60;
            $interval.cancel($scope.counter);
            $scope.counter = $interval(function () {
                if ($scope.countdown > 0) {
                    $scope.statusClock = false;
                    $scope.countdown--;
                } else {
                    $scope.statusClock = true;
                    $interval.cancel($scope.counter);
                }
            }, 1000);

            },function(data){
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return false;
        });
        
    };

    $scope.phoneNumValidate = function(){      
       LoginService.phoneApprove({
                phone: $scope.phonenumber,
                code:$scope.code
           },function(data){

           $interval.cancel($scope.counter);
           $scope.has_phone_check_ok = true;

           var now_user_data = WebApp.ClientStorage.getCurrentUser();
           now_user_data.phone = $scope.phonenumber;
           WebApp.ClientStorage.setCurrentUser(data);


        },function(data){
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        })
    };

    $scope.gotoHome = function(){
        $timeout(function () {
            $location.path(WebApp.Router.HOME);
        }, 0);
    }

});
