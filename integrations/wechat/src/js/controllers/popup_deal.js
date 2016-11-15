//var app = WebApp.Instance;
//app.controller('doTenderCon', function ($scope, $timeout, $location, md5, InvestsService) {
//    $scope.payPassword = "";
//    $scope.popup_pay = true;
//    $scope.pay_success = false;
//    $scope.error_password = false;
//    $scope.pay_exception = false;
//    $scope.doTender = function (borrowId) {
//        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
//        var bidAmount = WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', '');
//        var payPassword = md5.createHash($scope.payPassword || "");
//        bidAmount = bidAmount.toString();
//        InvestsService.tender({
//            borrowId: borrowId,
//            bidAmount: bidAmount,
//            payPassword: payPassword
//        }, function (data) {
//            $scope.popup_pay = false;
//            $scope.pay_success = true;
//            $scope.error_password = false;
//            $scope.pay_exception = false;
//
//        }, function (data) {
//            if (data.code == 400) {
//                $scope.popup_pay = false;
//                $scope.pay_success = false;
//                $scope.error_password = true;
//                $scope.pay_exception = false;
//            } else {
//                $scope.popup_pay = false;
//                $scope.pay_success = false;
//                $scope.error_password = false;
//                $scope.pay_exception = true;
//            }
//        });
//    };
//    $scope.init_popup = function () {
//        $scope.payPassword = "";
//        $scope.popup_pay = true;
//        $scope.pay_success = false;
//        $scope.error_password = false;
//        $scope.pay_exception = false;
//
//    };
//
//});



var app = WebApp.Instance;

app.controller('ModalInstanceCtrl', function ($rootScope,$scope, $log, $modalInstance, $modal, $timeout, $location, $route, md5, notify, InvestsService, items,$cookies) {
    $scope.items = items;
    $scope.selected = {
      item: $scope.items
    };

    if(WebApp.projectData)
    {   
        $scope.tenderAccountMax = WebApp.projectData.tenderAccountMax;
    }
    $scope.investNotSuccessMsg = WebApp.tmpValue.setOrGetStoreVal('investNotSuccessMsg');

    $scope.ok = function () {
        WebApp.status=0;
        $modalInstance.close($scope.selected.item);
    };
    $scope.gotoInvests = function () {
        WebApp.status=0;
        $modalInstance.close($scope.selected.item);
        $route.reload();

    };

    $scope.cancel = function () {
        WebApp.status=0;
        $modalInstance.dismiss('cancel');
    };

    $scope.reload = function () {
        $modalInstance.close($scope.selected.item);
        $route.reload();
    };

    $scope.pathAll = {rechargeM: WebApp.Router.USER_RECHARGE, validateIDCard: WebApp.Router.POPUP_ID_CARD, setPayPassword: WebApp.Router.SET_PAY_PASSWORD, enoughMoney: WebApp.Router.HOME, investHistory: WebApp.Router.INVEST_PERSON_LIST};
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            $location.path(path);
        }, 0);
        $modalInstance.close($scope.selected.item);
    };
    $scope.interestTotal = 0;
    $scope.errorPopuMessage = {};
    $scope.doTenderStatus = 0;
    $scope.doTender = function (borrowId) {
        if ($scope.doTenderStatus !== 0) {
            $timeout(function () {
                $scope.doTenderStatus = 0;
            }, 2000);
            return;
        }
        $scope.doTenderStatus = 1;
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_id', borrowId);
        WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
        var bidAmount = WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', '');
        //WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount_increase', $scope.bouns.increase.id);
        var    increaseid = WebApp.tmpValue.invest_increase
        var bonusid =  WebApp.tmpValue.invest_bonus;

        var payPassword = md5.createHash($scope.payPassword || "");
        var facode = $cookies.get("f_active_code"+borrowId);
        WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money_pwd', $scope.payPassword);
        bidAmount = bidAmount.toString();
        WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money', bidAmount);
        InvestsService.tender({
            borrowId: borrowId,
            bidAmount: bidAmount,
            bonusTicketId:bonusid,
            increaseTicketId:increaseid,
            payPassword: payPassword,
            activeZXCode:facode
        }, function (data) {
            if (typeof ($scope.selected) !== "undefined") {
                $modalInstance.close($scope.selected.item);
            } else {
                $modalInstance.dismiss('cancel');
            }
            //noValidateIDCardWarn("", "investSuccess");
            WebApp.Value.getStoreVal('shareData', data, $location, $timeout);
            WebApp.Value.getStoreVal('borrowId', borrowId, $location, $timeout);
            $timeout(function () {
                $location.path(WebApp.Router.INVEST_SUCCESS);
            }, 0);
            var bidAmounts = WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', '');
            dplus.track("投资", {"投资金额": bidAmounts});
            $scope.doTenderStatus = 0;

        }, function (data) {
            if (data.message == "tender_account_error") {
                $log.log(WebApp.Router.INVEST_ENOUGH);
                if (typeof ($scope.selected) !== "undefined") {
                    $modalInstance.close($scope.selected.item);
                } else {
                    $modalInstance.dismiss('cancel');
                }
                noValidateIDCardWarn("", "mustBigThanNumber");;
            } else if (data.message == "交易密码错误") {
                noValidateIDCardWarn("", "notRightPassWord");
            } else if(data.message == "投资金额大于账号余额")
            {
                $modalInstance.dismiss('cancel');
                noValidateIDCardWarn("", "noEnoughMoney");
            } else if(data.message.indexOf("此标最大投标金额不能大于") == 0)
            {
                $modalInstance.dismiss('cancel');
                WebApp.tmpValue.setOrGetStoreVal('investNotSuccessMsg', data.message);
                noValidateIDCardWarn("", "investNotSuccessWithMsg");
            } else if(data.message.indexOf("当前项目的最大投资金额为") == 0){
                $modalInstance.dismiss('cancel');
                WebApp.tmpValue.setOrGetStoreVal('investNotSuccessMsg', data.message);
                noValidateIDCardWarn("", "investNotSuccessWithMsg");
            }
            else {
                var data_message = data.message;
                if(data_message == '可用金额不足')
                {
                    data_message = '主人，您的账户余额不足，请充值后进行投资！';
                }
                notify.closeAll();
                notify({message: data_message, duration: WebApp.duration});
            }
            $scope.doTenderStatus = 0;
        });
    };

    function noValidateIDCardWarn(size, templateUrls) {
        $scope.animationsEnabled = true;
        var modalInstance = $modal.open({
            animation: $scope.animationsEnabled,
            templateUrl: templateUrls,
            controller: 'ModalInstanceCtrl',
            size: size,
            resolve: {
                items: function () {
                    return $scope.items;
                }
            }

        });
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at:' + new Date());
        });
    }
    
});

