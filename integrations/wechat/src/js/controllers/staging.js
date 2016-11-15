
WebApp.Instance.controller('StagingController', function ($scope, md5, StagingService, InvestsService, $log, notify, $http, $timeout, $location, $cookies, AccountService, $interval, $rootScope) {
    $scope.isInBc = false;
    $scope.detailButton = false;
    $scope.accountButton = false;
    $scope.widthScreen = 220;
    $scope.hasReminder = false;
    $scope.haspaypassword = "0";
    $scope.nopaypwd_reminder_show = false;
    $scope.nowUser = WebApp.ClientStorage.getCurrentUser();

    if ($scope.nowUser != null)
    {
        AccountService.getUsersSettingInfo(function (data) {
            $scope.haspaypassword = data.paypwdStatus;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    }

    StagingService.getBannerData(function (data) {
        $scope.banners = data;
    }, function (data) {
        notify.closeAll();
        notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
    });


    var updateScreenWidth = function () {
        var width = document.documentElement.clientWidth;
        if (window.orientation) {
            if (window.orientation === 0 || window.orientation === 180) {
                if (width > 374) {
                    $scope.widthScreen = 284;
                }
                if (width <= 374) {
                    $scope.widthScreen = 220;
                }

            } else if (window.orientation === 90 || window.orientation === -90) {
                $scope.widthScreen = 284;

            }
        } else {
            if (width > 374) {
                $scope.widthScreen = 284;
            }
            if (width <= 374) {
                $scope.widthScreen = 220;
            }
        }

    };
    setInterval(function () {
        $scope.$apply(updateScreenWidth);
    }, 1000);
    updateScreenWidth();

    $scope.monthShow = true;
    $scope.quarterShow = true;
    $scope.yearShow = true;
    $scope.getFinaningData = function () {
        StagingService.getFinaningData(function (data) {
            if (data.length == 0) {
                return;
            }
            if (data.list.month[0].availableAmount == 0) {
                $scope.monthShow = false;
            }
            if (data.list.quarter[0].availableAmount == 0) {
                $scope.quarterShow = false;
            }
            if (data.list.year[0].availableAmount == 0) {
                $scope.yearShow = false;
            }
            data.list.month[0].annualRate = WebApp.Utils.toReverse(data.list.month[0].annualRate, 2);
            data.list.quarter[0].annualRate = WebApp.Utils.toReverse(data.list.quarter[0].annualRate, 2);
            data.list.year[0].annualRate = WebApp.Utils.toReverse(data.list.year[0].annualRate, 2);
            data.list.month[0].tenderSchedule = WebApp.Utils.toReverse(data.list.month[0].tenderSchedule);
            data.list.quarter[0].tenderSchedule = WebApp.Utils.toReverse(data.list.quarter[0].tenderSchedule);
            data.list.year[0].tenderSchedule = WebApp.Utils.toReverse(data.list.year[0].tenderSchedule);
            if (data.list.month[0].isLimit && data.list.month[0].limitTime > 0) {
                renderTime(data.list.month[0]);
            }
            if (data.list.quarter[0].isLimit && data.list.quarter[0].limitTime > 0) {
                renderTime(data.list.quarter[0]);
            }
            if (data.list.year[0].isLimit && data.list.year[0].limitTime > 0) {
                renderTime(data.list.year[0]);
            }
            $scope.financingData = data.list;
        });
    };

    function renderTime(data) {
		    data.timer = returnTime(data);
		    if (data.TimerId) $interval.cancel(data.TimerId);
		    (function () {
		        data.TimerId = $interval(function () {
		            data.limitTime = (+data.limitTime) - 1;
		            data.timer = returnTime(data);
		        }, 1000);
		    })();
		}
		
		function returnTime(data) {
		    var time = data.limitTime;
		    if (time <= 0) $interval.cancel(data.TimerId);
		    var h = Math.floor(time / 3600);
		    var m = Math.floor(time % 3600 / 60);
		    var s = Math.floor(time % 3600 % 60);
		    h = h < 10 ? '0' + h : h;
		    m = m < 10 ? '0' + m : m;
		    s = s < 10 ? '0' + s : s;
		    return h + '时' + m + '分' + s + '秒';
		}


    $scope.isLogin = function () {
        //if (WebApp.ClientStorage.getCurrentUser()) {
        if (WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', '')) {
            $scope.isInBc = true;
        }
    };

    $scope.initStatus = function () {
        $scope.detailButton = false;
        $scope.accountButton = false;
    };

    $scope.changeStatus = function (s) {
        $scope.detailButton = !s;
    };

    $scope.initaccountButton = function () {
        $scope.accountButton = false;
    };

    $scope.changeaccountButton = function (s) {
        $scope.accountButton = !s;
        if ($cookies.get("reminder") == undefined) {
            $scope.hasReminder = true;
        }
        else
        {
            $scope.hasReminder = false;
        }
    };

    $scope.signreminder = function () {
        $scope.hasReminder = false;
        var expireDate = new Date();
        expireDate.setDate(expireDate.getDate() + 365);
        $cookies.put('reminder', 'true', {'expires': expireDate});
    };

    $scope.nopaypwd_pop = function () {
        $scope.nopaypwd_reminder_show = true;
    };

    $scope.hide_nopaypwd_pop = function () {
        $scope.nopaypwd_reminder_show = false;
    };


    $scope.path = {one: WebApp.Router.BANK_RETURNS, two: WebApp.Router.SAFEGUARD, three: WebApp.Router.HOLDING, four: WebApp.Router.MONTH_GET, five: WebApp.Router.THE_MONEY_GOES};
    $scope.changeUrl = function (url) {
        $timeout(function () {
            $location.path(url);
        }, 0);
    };

    //自动投标设置
    $scope.errorMessageIsShow = {
        change_init: true,
        change_success: false,
        error_password: false,
        change_exception: false
    };
    $scope.init_change = function () {
        $scope.errorMessageIsShow = {
            change_init: true,
            change_success: false,
            error_password: false,
            change_exception: false
        };
    };
    $scope.setAutoTender = function () {
        InvestsService.getLoginINfo(function (data) {
            $scope.payPwdStatus = data.payPwdStatus;
            $log.log(data);
            if (data.payPwdStatus == 0) {
                notify.closeAll();
                notify({message: "您还未设置交易密码，暂时不支持智能投资状态的修改", duration: WebApp.duration});
            } else if (data.payPwdStatus == 1) {

                var status1 = 1;
                var status = WebApp.tmpValue.setOrGetStoreVal("k_autoStatus", "");
                if (status === 1) {
                    status1 = 0;
                } else if (status === 0) {
                    status1 = 1;
                }
                var paypassword = md5.createHash($scope.payPassword || "");
                //if (WebApp.ClientStorage.getCurrentUser()) {
                //if (WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', '')) {
                StagingService.setAutoTender({status: status1, paypassword: paypassword}, function (data) {
                    $scope.errorMessageIsShow = {
                        change_init: false,
                        change_success: true,
                        error_password: false,
                        change_exception: false
                    };
                    $scope.autoStatus = data.autoStatus;
                    var status = WebApp.tmpValue.setOrGetStoreVal("k_autoStatus", "");
                    if (status == 1) {
                        angular.element(document.getElementById("statusT")).html("否");
                        angular.element(document.getElementById("left")).html("否");
                        angular.element(document.getElementById("right")).html("是");
                        WebApp.tmpValue.setOrGetStoreVal("k_autoStatus", "0");
                    } else if (status == 0) {
                        angular.element(document.getElementById("statusT")).html("是");
                        angular.element(document.getElementById("left")).html("是");
                        angular.element(document.getElementById("right")).html("否");
                        WebApp.tmpValue.setOrGetStoreVal("k_autoStatus", "1");
                    }


                }, function (data) {
                    if (data.code == "400") {
                        $scope.errorMessageIsShow = {
                            change_init: false,
                            change_success: false,
                            error_password: true,
                            change_exception: false
                        };
                    } else {
                        $scope.errorMessageIsShow = {
                            change_init: false,
                            change_success: false,
                            error_password: false,
                            change_exception: true
                        };
                    }
                });
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });



        // }
    };
    //获取自动投标状态
    $scope.getAutoTenderStatus = function () {
        //if (WebApp.ClientStorage.getCurrentUser()) {
        //if (WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', '')) {
        StagingService.getAutoTenderStatus(function (data) {
            $scope.autoStatus = data.autoStatus;
            $scope.isInBc = true;
            WebApp.tmpValue.setOrGetStoreVal("k_autoStatus", data.autoStatus);
            if (data.autoStatus == 0) {
                $scope.left = "否";
                $scope.right = "是";
            } else if (data.autoStatus == 1) {
                $scope.left = "是";
                $scope.right = "否";
            }

        }, function (data) {
            $scope.isInBc = false;
        });
        //}
    };

    $scope.gotoinvestlist = function () {
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_LIST);
        }, 0);
    }


});
