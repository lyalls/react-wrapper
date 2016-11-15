
WebApp.Instance.controller('ResetController', function ($scope, $location, md5, ResetService, notify, $interval, $timeout) {

    $scope.phone = "";
    $scope.code = "";
    $scope.vcode = "";
    $scope.countdown = "";
    $scope.counter = null;
    $scope.expireTimer = null;
    $scope.errorNoPhone = "";
    $scope.statusClockReg = true;
    $scope.getResetPhone = function () {
        var phone = $scope.phone;
        ResetService.getResetPhoneCode({phone: phone}, function (data) {
            $scope.countdown = 60;
            $interval.cancel($scope.counter);
            $scope.counter = $interval(function () {
                if ($scope.countdown > 0) {
                    $scope.statusClockReg = false;
                    $scope.countdown--;
                } else {
                    $scope.statusClockReg = true;
                    $interval.cancel($scope.counter);
                }
            }, 1000);


        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });

    };
    $scope.getValidatePhoneCodeStatus = 0;
    $scope.getValidatePhoneCode = function () {
        if (!$scope.phone) {
            notify.closeAll();
            notify({message: "手机号不能为空", duration: WebApp.duration});
            $scope.getValidatePhoneCodeStatus = 0;
            return;
        }
        if (!$scope.code) {
            notify.closeAll();
            notify({message: "验证码不能为空", duration: WebApp.duration});
            $scope.getValidatePhoneCodeStatus = 0;
            return;
        }
        if ($scope.getValidatePhoneCodeStatus !== 0) {
            $timeout(function () {
                $scope.getValidatePhoneCodeStatus = 0;
            }, 2000);
            return;
        }
        $scope.getValidatePhoneCodeStatus = 1;
        var phone = $scope.phone;
        WebApp.tmpValue.setOrGetStoreVal("reset_phone", phone);
        var code = $scope.code;
        ResetService.validatePhoneCode({phone: phone, code: code}, function (data) {
            $scope.getValidatePhoneCodeStatus = 0;
            notify.closeAll();
            WebApp.tmpValue.setOrGetStoreVal("reset_vcode", data.vcode);
            $timeout(function () {
                $location.path(WebApp.Router.RESET_NEW_PASSWORD);
            }, 0);
        }, function (data) {
            $scope.getValidatePhoneCodeStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });

    };

    $scope.getResetPasswordStatus = 0;
    $scope.getResetPassword = function () {
        if ($scope.getResetPasswordStatus !== 0) {
            $timeout(function () {
                $scope.getResetPasswordStatus = 0;
            }, 2000);
            return;
        }
        $scope.getResetPasswordStatus = 1;
        if (!$scope.validatePassWord()) {
            $scope.getResetPasswordStatus = 0;
            return;
        }
        if (!$scope.passwordConfirm()) {
            $scope.getResetPasswordStatus = 0;
            return;
        }
        var phone = WebApp.tmpValue.setOrGetStoreVal("reset_phone", '');
        var password = md5.createHash($scope.password || "");
        var vcode = WebApp.tmpValue.setOrGetStoreVal("reset_vcode", '');
        ResetService.resetPassword({phone: phone, password: password, vcode: vcode}, function (data) {
            $scope.getResetPasswordStatus = 0;
            notify.closeAll();
            notify({message: "密码设置成功", duration: WebApp.duration});
            $timeout(function () {
                $location.path(WebApp.Router.LOGIN);
            }, 1000);
        }, function (data) {
            $scope.getResetPasswordStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //验证密码
    $scope.validatePassWord = function () {
        if (!$scope.password) {
            notify.closeAll();
            notify({message: '密码不能为空', duration: WebApp.duration});
            return false;
        }
        var passwordDigitExp = /^.{6,16}$/;
        var passwordNumberExp = /^\d+$/;
        var passwordElementExp = /^[a-zA-Z]+$/;
        var digit_validity = passwordDigitExp.test($scope.password.replace(/\s+/g, ""));
        var number_validity = passwordNumberExp.test($scope.password.replace(/\s+/g, ""));
        var content_validity = passwordElementExp.test($scope.password.replace(/\s+/g, ""));
        if (!digit_validity) {
            notify.closeAll();
            notify({message: '密码请输入6-16位英文数字组合', duration: WebApp.duration});
            return false;
        }
        if (number_validity) {
            notify.closeAll();
            notify({message: '密码请输入6-16位英文数字组合', duration: WebApp.duration});
            return false;
        }
        if (content_validity) {
            notify.closeAll();
            notify({message: '密码请输入6-16位英文数字组合', duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //验证重复密码
    $scope.passwordConfirm = function () {
        if (!$scope.repassword) {
            notify.closeAll();
            notify({message: '确认密码不能为空', duration: WebApp.duration});
            return false;
        }
        if ($scope.password !== $scope.repassword) {
            notify.closeAll();
            notify({message: '两次密码输入不一致', duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };


});
