/*
 * 冉海 20150602
 */

WebApp.Instance.controller('PaymentController', function ($rootScope, $scope, $modal, $window, $location, md5, PaymentService, InvestsService, notify, $log, $timeout) {
    //充值跳转
    $scope.toRecharge = function () {
        InvestsService.getLoginINfo(function (data) {
            
            if (data.realNameStatus == 0) {
                    rechargeWarn("", "ValidateIDCardVerify");
                    return;
            }

            if (data.realNameStatus == 2) {
                rechargeWarn("", "ValidateIDCardnopass");
                return;
            }

            if (data.realNameStatus == 3) {
                rechargeWarn("", "noValidateIDCard");
                return;
            }


            $timeout(function () {
                $location.path(WebApp.Router.USER_RECHARGE);
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //充值用户信息查询
    $scope.getRechargeInfo = function () {
        PaymentService.getRechargeInfo(function (data) {
            var payStatus = $location.search().res;
            //0 充值成功／１充值失败／２充值异常
//            if (payStatus && payStatus <= 2) {
//                if (payStatus === "0") {
//                    rechargeWarn("", "rechargeS");
//                } else if (payStatus === "1") {
//                    rechargeWarn("", "rechargeF");
//                } else {
//                    rechargeWarn("", "rechargeE");
//                }
//            }
            $rootScope.info = data;
            if (!data.type) {
                if (!payStatus) {
                    rechargeWarn(20, 'firstRecharge');
                }
            }
            WebApp.ClientStorage.setCurrentNoAgree(data.noAgree);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    // 提交订单
    $scope.$watch('orderData', function (newValue, oldValue, scope) {
        if (newValue) {
            document.forms['llpaysubmit'].req_data.value = newValue;
            document.forms['llpaysubmit'].submit();
        }
    });

    //生成订单
    $scope.createOrder = function () {
        var noAgree = WebApp.ClientStorage.getCurrentNoAgree();
        if (!noAgree || noAgree === 'undefined') {
            noAgree = null;
        } else {
            noAgree = noAgree.toString();
        }

        var accountNumber = null;
        if (!noAgree) {
            accountNumber = $scope.accountNumber;
            var reg = /^[0-9]{15,20}$/;
            if (!reg.test(accountNumber)) {
                $scope.accountNumber = '';
                rechargeWarn(20, 'checkAccountNumberEmpty');
                return false;
            }
        }

        var rechargeMoney = null;
        if ($scope.rechargeMoney) {
            rechargeMoney = $scope.rechargeMoney;
        }
        if ($scope.money) {
            rechargeMoney = $scope.money;
        }

        var reg = /^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;
        if (!reg.test(rechargeMoney)) {
            $scope.rechargeMoney = '';
            $scope.money = '';
            rechargeWarn(20, "checkMoney");
            return false;
        }
        if (parseInt(rechargeMoney) > 50000) {
            $scope.rechargeMoney = '';
            $scope.money = '';
            rechargeWarn(20, "checkMoreMoney");
            return false;
        }

        PaymentService.createOrder({
            accountNumber: accountNumber,
            noAgree: noAgree,
            rechargeMoney: rechargeMoney
        }, function (data) {
            $scope.orderData = angular.toJson(data);
        }, function (data) {
            $scope.errorMessage = data.message;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //银行卡查询
    $scope.ckeckAccountNumber = function () {
        var accountNumber = $scope.accountNumber;
        if (!accountNumber) {
            return false;
        }
        var reg = /^[0-9]{15,20}$/;
        if (!reg.test(accountNumber)) {
            $scope.accountNumber = '';
            rechargeWarn(20, 'checkAccountNumber');
            return false;
        }
        var errorCallBack = function (data) {
            $scope.accountNumber = '';
            rechargeWarn(20, 'checkAccountNumber');

        }
        accountNumber = accountNumber.toString();
        var successCallBack = function (data) {
            if (data.type == 0) {
                $scope.accountNumber = '';
                rechargeWarn(20, 'checkAccountNumber');
            }
        }
        PaymentService.ckeckAccountNumber({accountNumber: accountNumber}, successCallBack, errorCallBack);
    };

    $scope.ckeckMoney = function () {
        var rechargeMoney = null;
        var patt = /^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;
        var type = 1;
        if ($scope.rechargeMoney) {
            rechargeMoney = $scope.rechargeMoney;
        }
        if ($scope.money) {
            rechargeMoney = $scope.money;
            type = 2;
        }
        if (!patt.test(rechargeMoney) && rechargeMoney) {
            var len = rechargeMoney.length;
            var start = 0;
            var end = len - 1;
            var r = rechargeMoney.substring(start, end);
            if (rechargeMoney.substring(end, len) == '.' && rechargeMoney.substring(end - 1, end) != '.' && r.toString().indexOf('.') == -1) {
                r = rechargeMoney;
            }
            if (type == 1) {
                $scope.rechargeMoney = r;
            } else {
                $scope.money = r;
            }
        }
    };

    $scope.checkNumber = function () {
        var reg = /^[0-9]*$/;
        var number = $scope.accountNumber;
        if (!reg.test(number)) {
            var len = number.length;
            var start = 0;
            var end = len - 1;
            var r = number.substring(start, end);
            $scope.accountNumber = r;
        }
    };

    function rechargeWarn(size, templateUrls) {
        $scope.animationsEnabled = true;
        var modalInstance = $modal.open({
            animation: $scope.animationsEnabled,
            templateUrl: templateUrls,
            controller: 'popUp',
            size: size,
            resolve: {
                items: function () {
                    return $scope.items;
                }
            }
        });
        WebApp.mInstance = modalInstance;
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at:' + new Date());
        });
    }
    ;
});

WebApp.Instance.controller('popUp', function ($scope, $modalInstance, $log, $modal, $timeout, $location, md5, items) {
    $scope.items = items;
    $scope.selected = {
        item: $scope.items
    };

    $scope.ok = function () {
        $modalInstance.close($scope.selected.item);
    };

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

    $scope.pathAll = {userCenter: WebApp.Router.USER, validateIDCard: WebApp.Router.POPUP_ID_CARD, setPayPassword: WebApp.Router.SET_PAY_PASSWORD, enoughMoney: WebApp.Router.HOME, investHistory: WebApp.Router.INVEST_PERSON_LIST};
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            $location.url(path);
        }, 0);
        $modalInstance.close($scope.selected.item);
    };

    $scope.errorPopuMessage = {};

});

