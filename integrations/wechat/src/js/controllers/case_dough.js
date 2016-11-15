
WebApp.Instance.controller('CaseDoughController', function ($scope, md5, $log, $route, CaseDoughService, $modal, notify, $http, $timeout, $location) {
    $scope.personNum = "0";

    //体验标首页
    $scope.experienceBorrowShow = true;
    $scope.id = true;
    $scope.getExperienceBorrow = function () {
        CaseDoughService.getExperienceBorrow(function (data) {
            if (data.availableAmount == "0" || data.availableAmount == "0.00") {
                $scope.experienceBorrowShow = false;
            }
            data.annualRate = WebApp.Utils.toReverse(data.annualRate, 2);
            data.tenderSchedule = WebApp.Utils.toReverse(data.tenderSchedule);
            $scope.experienceBorrow = data;
            WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', data.id);
            if (data.id !== "0") {
                $scope.id = false;
            }

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getTenderPeopleNum = function () {
        CaseDoughService.getTenderPeopleNum(function (data) {
            $scope.tenderPeopleNum = data.tenderPeopleNum;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.investsRecordList = [];

    $scope.availShow = true;
    $scope.getInvestRecord = function () {
        $scope.personNum = "0";
        var borrowId = WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', '');
        var pageSize = 20;
        var pageIndex = 1;
        CaseDoughService.getInvestRecord({borrowId: borrowId, pageSize: pageSize, pageIndex: pageIndex}, function (data) {
            if (data.availableAmount == "0.00") {
                $scope.availShow = false;
            } else {
                $scope.availShow = true;
            }
            for (var i = 0; i < data.list.length; i++) {
                $scope.investsRecordList.push(data.list[i]);
            }
            $scope.investsPerson = data.list;
            $scope.personNum = data.pageCount;
        }, function (data) {
//            notify.closeAll();
//            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.sizeBottom = 20;
    $scope.indexBottom = 2;

    $scope.bottom = function () {
        $scope.borrowId = WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', '');
        CaseDoughService.getInvestRecord({
            borrowId: $scope.borrowId,
            pageSize: $scope.sizeBottom,
            pageIndex: $scope.indexBottom
        }, function (data) {
            if (data.availableAmount == "0.00") {
                $scope.availShow = false;
            } else {
                $scope.availShow = true;
            }
            if (data.list.length == 0) {
                return;
            }
            for (var i = 0; i < data.list.length; i++) {
                $scope.investsRecordList.push(data.list[i]);
            }
            $scope.investsPerson = $scope.investsRecordList;
            $scope.indexBottom++;
        });

    };
    $scope.top = function () {
        $scope.borrowId = WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', '');
        $scope.size = 20;
        $scope.index = 1;
        CaseDoughService.getInvestRecord({
            borrowId: $scope.borrowId,
            pageSize: $scope.size,
            pageIndex: $scope.index
        }, function (data) {
            if (data.availableAmount == "0.00") {
                $scope.availShow = false;
            } else {
                $scope.availShow = true;
            }
            $scope.investsRecordList = [];
            for (var i = 0; i < data.list.length; i++) {
                $scope.investsRecordList.push(data.list[i]);
            }
            $scope.investsPerson = $scope.investsRecordList;
            $scope.indexBottom = 2;
        });
    };






    $scope.isNew = true;
    $scope.getMoneyTotalShow = true;
    $scope.getMoneyTotal = function () {
        CaseDoughService.getMoneyTotal(function (data) {
            if (data.money == "0") {
                $scope.getMoneyTotalShow = false;
            }
            $scope.money = data.money;
        }, function (data) {
            if (data.code == '401') {
                $scope.isNew = false;
            }

        });
    };

    $scope.getMoneyLog = function () {
        CaseDoughService.getMoneyLog(function (data) {
            if (!data.list.length == 0) {
                for (var i = 0; i < data.list.length; i++) {
                    data.list[i].expiredTime = "有效期至" + data.list[i].expiredTime;
                    if (data.list[i].type == 1) {
                        data.list[i].type = "注册领取";
                    } else if (data.list[i].type == 0) {
                        data.list[i].type = "后台添加";
                    } else {
                        data.list[i].type = "参加XXX活动";
                    }

                    if (data.list[i].status == 2) {
                        data.list[i].expiredTime = "已过期";
                    }
                }
            }
            $scope.moneyLog = data.list;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getWaitAccountList = function () {

        CaseDoughService.getWaitAccountList(function (data) {
            $scope.waitAccountList = data.list;

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    $scope.getTenderInfo = function () {
        var borrowId = WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', '');
        CaseDoughService.getTenderInfo({borrowId: borrowId}, function (data) {
            $scope.availableAmount = data.availableAmount;
            WebApp.tmpValue.setOrGetStoreVal('availableAmount_money', data.availableAmount);
            $scope.availableBalance = data.availableBalance;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    var moneys = {moneys: "0", id: "0"};
    WebApp.tmpValue.setOrGetStoreVal('currentPeriod', moneys);
    $scope.getTenderMoneyList = function () {
        CaseDoughService.getTenderMoneyList(function (data) {

            $scope.model = data.list;
            if (!data.list.length == 0) {
                var self = this;
                $scope.billsDetailData = [];
                $scope.billsDetailTotalData = [];
                $scope.currentPeriod = $scope.model[0].money;
                $scope.change = function () {
                    notify.closeAll();
//                self.getDetailPagedDataAsync($scope.currentPeriod);
//                self.getDetailTotalData($scope.currentPeriod);
                    if ($scope.currentPeriod) {
                        var availableAmount = WebApp.tmpValue.setOrGetStoreVal('availableAmount_money', '');
                        if ($scope.currentPeriod.money > availableAmount) {
                            noValidateIDCardWarn("", "mustBigThanNumber");
                        }
                        $log.log($scope.currentPeriod);
                        var moneys = {moneys: $scope.currentPeriod.money, id: $scope.currentPeriod.id};
                        WebApp.tmpValue.setOrGetStoreVal('currentPeriod', moneys);

                    } else {
                        var moneys = {moneys: "0", id: "0"};
                        WebApp.tmpValue.setOrGetStoreVal('currentPeriod', moneys);
                        notify.closeAll();
                        notify({message: "请选择私房钱！", duration: WebApp.duration});

                    }

                };
            } else {
                $scope.model[0] = {money: "无"};
                $scope.currentPeriod = $scope.model[0].money;
            }

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    $scope.doTender = function () {
        
        var availableAmount = WebApp.tmpValue.setOrGetStoreVal('availableAmount_money', '');
        var currentPeriod = WebApp.tmpValue.setOrGetStoreVal('currentPeriod', '');
        if (currentPeriod.moneys == '0') {
            notify.closeAll();
            notify({message: "请选择私房钱！", duration: WebApp.duration});
            return;
        } else {

            if (currentPeriod.money > availableAmount) {
                noValidateIDCardWarn("", "mustBigThanNumber");
                return;
            }
            var borrowId = WebApp.tmpValue.setOrGetStoreVal('ids_experienceBorrow', '');
            var accountId = currentPeriod.id;
            CaseDoughService.doTender({borrowId: borrowId, accountId: accountId}, function (data) {
                WebApp.tmpValue.setOrGetStoreVal('recoverTime_money', data.recoverTime);
                //noValidateIDCardWarn("", "investSuccess");
                //WebApp.Value.getStoreVal('accountInterests', data.accountInterest, $location, $timeout);
                //WebApp.Value.getStoreVal('recoverTimes', data.recoverTime, $location, $timeout);
                WebApp.tmpValue.setOrGetStoreVal('Detail_accountInterests', data.accountInterest);
                WebApp.tmpValue.setOrGetStoreVal('Detail_recoverTimes', data.recoverTime);
                $timeout(function () {
                    $location.path(WebApp.Router.INVESTS_SUCCESS);
                }, 0);
                //$route.reload();
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });

        }

    };
    $scope.getValueSuccess = function () {
        //$scope.accountInterest=WebApp.Value.getStoreVal('accountInterests','', $location, $timeout);
        // $scope.recoverTime=WebApp.Value.getStoreVal('recoverTimes', '', $location, $timeout);
        $scope.accountInterest = WebApp.tmpValue.setOrGetStoreVal('Detail_accountInterests', '');
        $scope.recoverTime = WebApp.tmpValue.setOrGetStoreVal('Detail_recoverTimes', '');
    };
    $scope.pathAll = {listOfExperience: WebApp.Router.EXPERIENCE_LIST, experience: WebApp.Router.EXPERIENCE};
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            $location.url(path);
        }, 0);
    };
    function noValidateIDCardWarn(size, templateUrls) {
        $scope.animationsEnabled = true;
        var modalInstance = $modal.open({
            animation: $scope.animationsEnabled,
            templateUrl: templateUrls,
            controller: 'popUps',
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
    ;


});


WebApp.Instance.controller('popUps', function ($scope, $modalInstance, $log, $modal, $timeout, $location, md5, items) {
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

    $scope.pathAll = {listOfExperience: WebApp.Router.EXPERIENCE_LIST, experience: WebApp.Router.EXPERIENCE};
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            $location.url(path);
        }, 0);
        $modalInstance.close($scope.selected.item);
    };
    $scope.vvv = function () {
        $scope.recoverTime = WebApp.tmpValue.setOrGetStoreVal('recoverTime_money', '');
    };


});
