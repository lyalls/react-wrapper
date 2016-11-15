//register
WebApp.Instance.controller('RegisterController', function ($scope, $location, md5, RegisterService, notify, $log, $interval, $timeout) {
    $scope.errorMessage = "";
    $scope.countdown = "";
    $scope.errorNameMessage = "";
    $scope.errorIDMessage = "";
    $scope.checkCodeIsError = false;
    $scope.checkRealNameIsError = false;
    $scope.counter = null;
    $scope.expireTimer = null;
    $scope.needshowdialog = false;
    $scope.maskCom = false;

    $scope.save = function()
    {
        $scope.needshowdialog = false;
        $scope.maskCom = false;
    }
    $scope.sendValidCode=function()
    {

        RegisterService.doCheckValidCode({cpt:$scope.validCode},function(data)
        {
            if(data.result=="error")
            {
                $scope.validPicUrl = "/validator/captchasrc?"+Math.random();
                notify.closeAll();
                notify({message:data.msg , duration: WebApp.duration});
                $scope.validCode ="";
                return;
            }
            $scope.needshowdialog = false;
            $scope.maskCom = false;
            //发送验证码成功
            RegisterService.doRegisterPhoneCode({phone: $scope.phone}, function (data) {
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

            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        });


    }
    $scope.closedLightbox=function(){
        $scope.needshowdialog = false;
        $scope.maskCom = false;
    }

     function validatePhone(callback) {
        $scope.validatePhoneCheck = false;
        var mobilePhoneExp = /^(13|14|15|17|18)\d{9}$/;
        var validity = mobilePhoneExp.test($scope.phone);
        if (!validity) {
            $scope.validatePhoneShow = true;
            notify.closeAll();
            notify({message: "手机号码格式不正确", duration: WebApp.duration});
            return false;
        }
        RegisterService.checkPhone({phone: $scope.phone}, function (data) {
            notify.closeAll();
           if(callback)
           {
               callback();
           }

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return false;
        });
        return true;
    };
    //验证新注册用户名
    $scope.validateUserName = function () {
        
        return true;
    };
    //验证密码
    $scope.validatePassWord = function () {
        if (!$scope.setPassword) {
            notify.closeAll();
            notify({message: '密码不能为空', duration: WebApp.duration});
            return false;
        }
        var passwordDigitExp = /^.{6,16}$/;
        var passwordNumberExp = /^\d+$/;
        var passwordElementExp = /^[a-zA-Z]+$/;
        var digit_validity = passwordDigitExp.test($scope.setPassword);
        var number_validity = passwordNumberExp.test($scope.setPassword);
        var content_validity = passwordElementExp.test($scope.setPassword);
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
        $scope.needshowdialog = true;
        return true;
    };
    //验证真实姓名
    $scope.validateRealName = function () {
        if (!$scope.realName) {
            notify.closeAll();
            notify({message: '真实姓名不能为空', duration: WebApp.duration});
            return false;
        }
        var realNameExp = /^[\u4E00-\u9FA5]+$/;
        var validity = realNameExp.test($scope.realName);
        if (!validity) {
            notify.closeAll();
            notify({message: '姓名格式不正确', duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //验证身份证号码
    $scope.validateIdNumberShow = false;
    $scope.validateIdNumber = function () {
        if (!$scope.IDCard) {
            notify.closeAll();
            notify({message: '身份证号不能为空', duration: WebApp.duration});
            return false;
        }
        var exp = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/;
        var validity = exp.test($scope.IDCard);
        if (!validity) {
            notify.closeAll();
            notify({message: '身份证号格式不正确', duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //跳过身份验证
    $scope.goSuccess = function () {
        notify.closeAll();
        $timeout(function () {
            $location.path(WebApp.Router.REGISTER_SUCCESS);
        }, 0);
    };
    $scope.validPicUrl = "/validator/captchasrc";
    $scope.validPicChange = function()
    {
        $scope.validPicUrl = "/validator/captchasrc?"+Math.random();
    }

    //获取验证码
    $scope.statusClock = true;
    $scope.phoneValidateCode = function () {

        validatePhone(function()
        {
               $scope.validPicUrl = "/validator/captchasrc?"+Math.random();
               $scope.validCode ="";
               $scope.needshowdialog = true;
        });
    };
/*

 */

    //注册协议
    $scope.acceptProvision = function () {
        RegisterService.doRegisterProtocol(function (data) {
            $scope.pContent = data.protocolContent;


        });
    };
    //手机号验证码验证
    $scope.phoneValidateStatus = 0;
    $scope.invitationCode = "";
    $scope.phoneValidate = function () {
        if ($scope.phoneValidateStatus !== 0) {
            $timeout(function () {
                $scope.phoneValidateStatus = 0;
            }, 2000);
            return;
        }
        $scope.phoneValidateStatus = 1;
//        if (!$scope.validatePhone()) {
//            //notify.closeAll();
//            //notify({message:"请正确填写信息！", duration: WebApp.duration});
//            $scope.phoneValidateStatus = 0;
//            return;
//        }
        WebApp.tmpValue.setOrGetStoreVal("k_invitation", $scope.invitationCode);
        RegisterService.doRegisterPhone({phone: $scope.phone, code: $scope.code}, function (data) {
            $scope.phoneValidateStatus = 0;
            notify.closeAll();
            //WebApp.ClientStorage.store('vcode', data.vcode);
            WebApp.tmpValue.setOrGetStoreVal("k_vcode", data.vcode);

            $timeout(function () {
                $location.path(WebApp.Router.REG_NAME);
            }, 0);

        }, function (data) {
            $scope.phoneValidateStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });

    };
    //doRegister
    $scope.registerStatus = 0;
    $scope.register = function () {
        if (!$scope.setPassword) {
            notify.closeAll();
            notify({message: '密码不能为空', duration: WebApp.duration});
            $scope.registerStatus = 0;
            return;
        }
        if ($scope.registerStatus !== 0) {
            $timeout(function () {
                $scope.registerStatus = 0;
            }, 2000);
            return;
        }
        $scope.registerStatus = 1;
        if (!$scope.validatePassWord()) {
            $scope.registerStatus = 0;
            return;
        }
//        if (!$scope.checkInvitationCOde()) {
//            $scope.registerStatus = 0;
//            return;
//        }
        var password = md5.createHash($scope.setPassword || "");
        var vcode = WebApp.tmpValue.setOrGetStoreVal("k_vcode", "");
        //var invitationCode=WebApp.tmpValue.setOrGetStoreVal("k_invitation", "");
        var invitationCode = $scope.invitationCode;
        RegisterService.doRegister({password: password, invitationCode: invitationCode, vcode: vcode}, function (data) {
            $scope.registerStatus = 0;
            $timeout(function () {
                $location.path(WebApp.Router.REGISTER_SUCCESS);
            }, 0);
            WebApp.ClientStorage.setCurrentToken(data.token);
            dplus.track("注册",{source:"H5"});
        }, function (data) {
            $scope.registerStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    $scope.registerRealnameStatus = 0;
    $scope.registerRealname = function () {
        $scope.IDCard = $scope.IDCard.toUpperCase();
        if (!$scope.realName) {
            notify.closeAll();
            notify({message: '真实姓名不能为空', duration: WebApp.duration});
            $scope.registerRealnameStatus = 0;
            return;
        }
        if (!$scope.IDCard) {
            notify.closeAll();
            notify({message: '身份证号不能为空', duration: WebApp.duration});
            $scope.registerRealnameStatus = 0;
            return;
        }
        if ($scope.registerRealnameStatus !== 0) {
            $timeout(function () {
                $scope.registerRealnameStatus = 0;
            }, 2000);
            return;
        }
        $scope.registerRealnameStatus = 1;
        if (!$scope.validateRealName()) {
            $scope.registerRealnameStatus = 0;
            return;
        }
        if (!$scope.validateIdNumber()) {
            $scope.registerRealnameStatus = 0;
            return;
        }

        var realName = $scope.realName;
        var IDCard = $scope.IDCard;
        RegisterService.registerRealname({realName: realName, IDCard: IDCard}, function (data) {
            $scope.registerRealnameStatus = 0;
            notify.closeAll();
            //WebApp.ClientStorage.setCurrentUser(data).realNameAuth = true;
            WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', data).realNameAuth = true;
            $timeout(function () {
                $location.path(history.go(-1));
            }, 0);

        }, function (data) {
            $scope.registerRealnameStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.registerRealnameRegStatus = 0;
    $scope.registerRealnameReg = function () {
        if (!$scope.realName) {
            notify.closeAll();
            notify({message: '真实姓名不能为空', duration: WebApp.duration});
            $scope.registerRealnameRegStatus = 0;
            return;
        }
        if (!$scope.IDCard) {
            notify.closeAll();
            notify({message: '身份证号不能为空', duration: WebApp.duration});
            $scope.registerRealnameRegStatus = 0;
            return;
        }
        if ($scope.registerRealnameRegStatus !== 0) {
            $timeout(function () {
                $scope.registerRealnameRegStatus = 0;
            }, 2000);
            return;
        }
        $scope.registerRealnameRegStatus = 1;
        if (!$scope.validateRealName()) {
            $scope.registerRealnameRegStatus = 0;
            return;
        }
        if (!$scope.validateIdNumber()) {
            $scope.registerRealnameRegStatus = 0;
            return;
        }
        var realName = $scope.realName;
        var IDCard = $scope.IDCard;
        RegisterService.registerRealname({realName: realName, IDCard: IDCard}, function (data) {
            notify.closeAll();
            //WebApp.ClientStorage.setCurrentUser(data).realNameAuth = true;
            WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', data).realNameAuth = true;
            $timeout(function () {
                $location.path(WebApp.Router.REGISTER_SUCCESS);
            }, 0);

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //验证邀请码
    $scope.invitationCode = "";
    $scope.checkInvitationCOde = function () {
        var invitationCode = $scope.invitationCode;
        if (!$scope.invitationCode) {
            return true;
        }
        RegisterService.checkInvitationCOde({invitationCode: invitationCode}, function (data) {
            notify.closeAll();
            return true;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return false;
        });
        return true;
    };
    //密码显示
    $scope.typePass = 'password';
    $scope.imgPass = './images/pw-eye-gray.png';
    $scope.showPass = function(){
    	
    	if($scope.typePass == 'password'){
    		$scope.typePass = 'text';
        	$scope.imgPass = './images/pw-eye-gold.png';
    	}else if($scope.typePass == 'text'){
    		$scope.typePass = 'password';
        	$scope.imgPass = './images/pw-eye-gray.png';
    	}
    	
    	
    }

});
