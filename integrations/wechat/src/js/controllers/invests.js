//
// For this trivial demo we have just a unique Controller 
// for everything
//
WebApp.Instance.controller('InvestsController', function (Oauth2Service,$rootScope, $scope, $location, md5, $modal, InvestsService, notify, $window, $log, $timeout,$cookies, $interval) {
    $rootScope.investAmount = '';
    $scope.pageSize = 10;
    $scope.pageIndex = 1;
    $scope.investsList = [];
    $scope.passwordConfirm = "";
    $scope.nowPage = 1;
    $scope.if_tender_tip_show = false;
    var colors = {
        'fangchan': "#4da9f6",
        'gou': "#ff7b42",
        'yzd': "#14cb80",
        'hangye': "#14cb80",
        'pingan': "#93e15f",
        'peizi': '#b80ef7'
    };

    $scope.progressColor = function (p) {
        return  colors[p] ? colors[p] : '#b80ef7';
    };
    
    $scope.FontColor = function (p) {
        if (p === "fangchan") {
            return {style_l: 'k_blue', style_n: 'k_num_blue'};
        } else if (p === "gou") {
            return {style_l: 'k_orange', style_n: 'k_num_orange'};
        } else if (p === "yzd") {
            return {style_l: 'k_green2', style_n: "k_num_green2"};
        } else if (p === "hangye") {
            return {style_l: 'k_yellow', style_n: "k_num_yellow"};
        } else if (p === "pingan") {
            return {style_l: 'k_green', style_n: "k_num_green"};
        } else {
            return {style_l: 'k_purple', style_n: "k_num_purple"};
        }
    };
        
    $scope.getData = function () {
        var enough_id = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money', '');
        var enough_amount = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money', '');
        var enough_pwd = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money_pwd', '');
        $scope.enough_amount=enough_amount;
    };

    $scope.enough_tender = function () {
        var enough_id = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_id', '');
        var enough_amount = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money', '');
        var enough_pwd = WebApp.tmpValue.setOrGetStoreVal('Detail_not_enough_money_pwd', '');
        var pwd = md5.createHash(enough_pwd || "");       
        InvestsService.tender_enough({
            borrowId: enough_id,
            bidAmount: enough_amount,
            payPassword: pwd
        }, function (data) {
            //noValidateIDCardWarn("", "investSuccess");
            WebApp.Value.getStoreVal('interestTotal', data.interestTotal, $location, $timeout);
            $timeout(function () {
                $location.path(WebApp.Router.INVEST_SUCCESS);
            }, 0);
            var bidAmounts = WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', '');

        }, function (data) {
            if (data.message == "tender_account_error") {
                $log.log(WebApp.Router.INVEST_ENOUGH);
                if (typeof ($scope.selected) !== "undefined") {
                    $modalInstance.close($scope.selected.item);
                } else {
                    $modalInstance.dismiss('cancel');
                }
                $timeout(function () {
                    $location.path(WebApp.Router.INVEST_ENOUGH);
                }, 0);
            } else if (data.message == "交易密码错误") {
                noValidateIDCardWarn("", "notRightPassWord");
            } else {
                notify.closeAll();
                notify({message: data.message, duration: WebApp.duration});
            }
            $scope.doTenderStatus = 0;
        });
    };

    $scope.clickaddlist = function(){        
        InvestsService.getInvestsList({
            pageSize: 10*$scope.nowPage,
            pageIndex: 1
        }, function (data) {
            $scope.investsList = [];
            for (var i = 0; i < data.list.length; i++) {
                data.list[i].tenderSchedule = WebApp.Utils.toReverse(data.list[i].tenderSchedule);
                data.list[i].annualRate = WebApp.Utils.toReverse(data.list[i].annualRate,2);
                if (data.list[i].isLimit && data.list[i].limitTime > 0) {
                	data.list[i].timer = returnTime(data.list[i]);
                	(function(i) {
                		data.list[i].TimerId = $interval(function() {
				          		data.list[i].limitTime = (+data.list[i].limitTime) -1;
				          		data.list[i].timer = returnTime(data.list[i]);
				          	}, 1000);
                	})(i);
                }
                $scope.investsList.push(data.list[i]);
            }
            $scope.nowPage++;
        });
    }
    
    function returnTime(data) {
    	var time = data.limitTime;
    	if (time <= 0) $interval.cancel(data.TimerId);
    	var h = Math.floor(time/3600);
    	var m = Math.floor(time%3600/60);
    	var s = Math.floor(time%3600%60);
    	return h + '时' + m + '分' + s + '秒';
    }

    $scope.generalList = function () {
        $scope.colorOfProgress = {house: 'k_blue', business: 'k_green', guarantee: 'k_yellow', silver: 'k_orange', gray: 'k_gray'};
        $scope.colorOfFont = {house: 'k_num_blue', business: 'k_num_green', guarantee: 'k_num_yellow', silver: 'k_num_orange', gray: 'k_num_gray'};
        InvestsService.getInvestsList({
            pageSize: $scope.pageSize,
            pageIndex: $scope.pageIndex
        }, function (data) {
            for (var i = 0; i < data.list.length; i++) {
                data.list[i].tenderSchedule = WebApp.Utils.toReverse(data.list[i].tenderSchedule);
                data.list[i].annualRate = WebApp.Utils.toReverse(data.list[i].annualRate,2);
                $scope.investsList.push(data.list[i]);
                if (i === 0) {
                    var id = WebApp.Value.getStoreVal('Detail_borrowId', data.list[i].id, $location, $timeout);
                }
            }
            $scope.pageIndex++;
        });
    };


    $scope.updateGeneralList = function () {
        $scope.pageIndex = 1;
        $scope.pageSize = 10;
        InvestsService.getInvestsList({
            pageSize: $scope.pageSize,
            pageIndex: $scope.pageIndex
        }, function (data) {
            var tmp = [];
            for (var i = 0; i < data.list.length; i++) {
                data.list[i].tenderSchedule = WebApp.Utils.toReverse(data.list[i].tenderSchedule);
                data.list[i].annualRate = WebApp.Utils.toReverse(data.list[i].annualRate,2);
                tmp.push(data.list[i]);
            }
            $scope.investsList = tmp;
        });
    };
    //投资列表进度条数据转换
    $scope.toReverse = function (number) {
        WebApp.Utils.toReverse(number);
    };
    //投资详情
    $scope.getInvestDetail = function (borrowId,pname,ifnew) {
    		if (arguments.length >= 4 && arguments[3] > 0) return;
        if(pname)
        {
            WebApp.tmpValue.setOrGetStoreVal('Detail_tender_plan_name',pname);
        }
        if(ifnew==0 || ifnew==1)
        {   
            WebApp.tmpValue.setOrGetStoreVal('Detail_tender_if_new',ifnew+'');
        }
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_DETAIL);
        }, 0);
    };

    //借款人详情
    $scope.getBorrowerDetail = function (borrowId) {
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_BORROWER_DETAIL);
        }, 0);
    };
    //风控信息
    $scope.getProductRiskDetail = function (borrowId) {
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_PRODUCT_RISKS);
        }, 0);
    };
    //还款模式
    $scope.getPaymentMethodDetail = function (borrowId) {
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_PAYMENT_METHODS);
        }, 0);
    };
    //投资人列表
    $scope.getInvestPersonList = function (borrowId, tenderSchedule) {
    		if (arguments.length > 2 && arguments[2] !== null) $rootScope.limitData = arguments[2] || null;
        if (borrowId) {
            WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
            $log.log(tenderSchedule);
            if (tenderSchedule) {
                WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedules', tenderSchedule);
            } else {
                WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedules', '0');
            }
        }
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        tenderSchedule = WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedules', '');
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_PERSON_LIST);
        }, 0);
    };
    $scope.getTenderInfoDetail = function (borrowId) {
				if (arguments.length >= 2 && arguments[1] > 0) return;
        if (borrowId) {
            WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
        }
        if (arguments.length > 1) {
        	var time = arguments[1];
        }
        
        var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST);
        }, 0);
    };


    //获得总投资人数
    $scope.getTenderPeopleNum = function (plans) {
        InvestsService.getTenderPeopleNum({plans: plans}, function (data) {
            $scope.tenderPeopleNum = data.tenderPeopleNum;
        }, function (data) {
        });

    };

    $scope.getTenderHasOrNot = function () {
        InvestsService.getIfHasTender(function (data) {
            $scope.if_tender_tip_show = data.isShow;
        }, function (data) {
        });

    };

//    //投资逻辑
//    $scope.investBcw = {
//        hundredTimes: false,
//        isRightNumber: false,
//        verifiedRealName: false,
//        setPayPassWord: false,
//        enoughMoney: false,
//        doInvestBc: false,
//        doInvestBcSuccess: false,
//        doInvestNotSuccess: false,
//        notNull: false
//    };
//    $scope.init_invest = function () {
//        $rootScope.investAmount = '';
//        $scope.investBcw = {hundredTimes: false,
//            isRightNumber: false,
//            verifiedRealName: false,
//            setPayPassWord: false,
//            enoughMoney: false,
//            doInvestBc: false,
//            doInvestBcSuccess: false,
//            doInvestNotSuccess: false,
//            notNull: false
//        };
//    };
//    $scope.investBc = function (investAmount) {
//        if (investAmount >= 100) {
//            var availableAmount =  WebApp.tmpValue.setOrGetStoreVal('Detail_tenderAvi', '');
//            $log.log(availableAmount);
//            $log.log(investAmount);
//            if (availableAmount >= investAmount) {
//                WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', investAmount);
//                if (investAmount % 100 !== 0) {
//                    $scope.investBcw = {hundredTimes: true,
//                        isRightNumber: false,
//                        verifiedRealName: false,
//                        setPayPassWord: false,
//                        enoughMoney: false,
//                        doInvestBc: false,
//                        doInvestBcSuccess: false,
//                        doInvestNotSuccess: false,
//                        notNull: false
//                    };
//                    return;
//                }
//                var data = WebApp.ClientStorage.getCurrentUser();
//                if (data.realNameAuth === false) {
//                    $scope.investBcw = {hundredTimes: false,
//                        isRightNumber: false,
//                        verifiedRealName: true,
//                        setPayPassWord: false,
//                        enoughMoney: false,
//                        doInvestBc: false,
//                        doInvestBcSuccess: false,
//                        doInvestNotSuccess: false,
//                        notNull: false
//                    };
//                    return;
//                }
//                InvestsService.preCheck(function (data) {
//                    if (data.needSetPassword) {
//                        $scope.investBcw = {hundredTimes: false,
//                            isRightNumber: false,
//                            verifiedRealName: false,
//                            setPayPassWord: true,
//                            enoughMoney: false,
//                            doInvestBc: false,
//                            doInvestBcSuccess: false,
//                            doInvestNotSuccess: false,
//                            notNull: false
//                        };
//                        return;
//                    }
//                    var balance = WebApp.ClientStorage.getCurrentAccount();
//                    if (balance < investAmount) {
//                        $scope.investBcw = {hundredTimes: false,
//                            isRightNumber: false,
//                            verifiedRealName: false,
//                            setPayPassWord: false,
//                            enoughMoney: true,
//                            doInvestBc: false,
//                            doInvestBcSuccess: false,
//                            doInvestNotSuccess: false,
//                            notNull: false
//                        };
//                        return;
//                    } else {
//                        $scope.investBcw = {hundredTimes: false,
//                            isRightNumber: false,
//                            verifiedRealName: false,
//                            setPayPassWord: false,
//                            enoughMoney: false,
//                            doInvestBc: true,
//                            doInvestBcSuccess: false,
//                            doInvestNotSuccess: false,
//                            notNull: false
//                        };
//                    }
//                }, function (response, status, headers, config) {
//                    
//
//                });
//            } else {
//                $scope.investBcw = {hundredTimes: false,
//                    isRightNumber: true,
//                    verifiedRealName: false,
//                    setPayPassWord: false,
//                    enoughMoney: false,
//                    doInvestBc: false,
//                    doInvestBcSuccess: false,
//                    doInvestNotSuccess: false,
//                    notNull: false
//                };
//
//            }
//        } else if (!investAmount) {
//            $scope.investBcw = {hundredTimes: false,
//                isRightNumber: false,
//                verifiedRealName: false,
//                setPayPassWord: false,
//                enoughMoney: false,
//                doInvestBc: false,
//                doInvestBcSuccess: false,
//                doInvestNotSuccess: false,
//                notNull: true
//            };
//
//        } else {
//            $scope.investBcw = {hundredTimes: false,
//                isRightNumber: false,
//                verifiedRealName: false,
//                setPayPassWord: false,
//                enoughMoney: false,
//                doInvestBc: false,
//                doInvestBcSuccess: false,
//                doInvestNotSuccess: true,
//                notNull: false
//            };
//        }
//    };
//
    $scope.pathAll = {rechargeM: WebApp.Router.USER_RECHARGE,
        validateIDCard: WebApp.Router.POPUP_ID_CARD,
        setPayPassword: WebApp.Router.SET_PAY_PASSWORD,
        toHome: WebApp.Router.INVEST_LIST,
        investHistory: WebApp.Router.PROJECT_INTRO,
        invest:WebApp.Router.INVEST
    };
//    $scope.gotoShare = function()
//    {
//        //
//        $timeout(function () {
//                $location.path($scope.shareData.url);
//            }, 0);
//
//    };
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            WebApp.tmpValue.setOrGetStoreVal('objttype', 'records');
            $location.path(path);
        }, 0);
    };
    /*
     * 以下是关于投资、取现、充值的代码弹窗的代码
     * 
     */
    $scope.preCheck = function (investAmount, availibelMount, availableBalance) 
    {
        // 0.点击频率 检查
        if(WebApp.status!=0)
        {
            notify.closeAll();
            notify({message: "您点击太频繁啦", duration: WebApp.duration});
            $timeout(function () {
                WebApp.status = 0;
            }, 5000);
            return;
        }
        // 0.转值到number类型,否则字符串比较会出错
        if(typeof(investAmount) === 'string')
        {
            investAmount = parseFloat(investAmount);
        }
        if(typeof(availibelMount) === 'string')
        {
            availibelMount = parseFloat(availibelMount);
        }
        if(typeof(availableBalance) === 'string')
        {
            availableBalance = parseFloat(availableBalance);
        }
        
        // 1.投资金额检查
        // 1.1 是否输入空
        if(!investAmount)
        {
            noValidateIDCardWarn("", "emptyInput");
            return ;
        }
        // 1.2 投资金额是否足够
        if (availibelMount < investAmount) 
        {
            noValidateIDCardWarn("", "mustBigThanNumber");
            return ;
        }
        // 1.3 输入金额是否为100的倍数
        if (investAmount < 100 || investAmount % 100 !== 0) 
        {
           noValidateIDCardWarn("", "notMultiples");
           return;
        }
        //检查投资上限
        if($.isNumeric(WebApp.projectData.tenderAccountMax) && investAmount>WebApp.projectData.tenderAccountMax)
        {
            noValidateIDCardWarn("", "mustBigThantenderAccountMax");
            return;
        }

         
        WebApp.status=1;
        WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount', investAmount);
        $scope.checkCodeIsError = false;
        InvestsService.getLoginINfo(function (data) {
            WebApp.tmpValue.setOrGetStoreVal('Detail_User', data);
            // 2 是否实名验证
             if (data.realNameStatus == 0) {
                    noValidateIDCardWarn("", "ValidateIDCardVerify");
                    return;
                }
                if (data.realNameStatus == 2) {
                    noValidateIDCardWarn("", "ValidateIDCardnopass");
                    return;
                }
                if (data.realNameStatus == 3) {
                    noValidateIDCardWarn("", "noValidateIDCard1");
                    return;
                }
                // 3 是否设置交易密码
                if(data.payPwdStatus == 0)
                {
                    noValidateIDCardWarn("", "noSetPayPassword");
                    return ;
                }
                 // 4 余额是否足够
                 if(investAmount > availableBalance)
                 {
                      noValidateIDCardWarn("", "noEnoughMoney");
                      return ;
                 }
                
                 noValidateIDCardWarn("", "investPay");
        });
    };
    $scope.getInterestTotal=function(){
        $scope.shareData= WebApp.Value.getStoreVal('shareData','', $location, $timeout);
    };
    //弹出取现按钮（只是一个静态弹窗）
    $scope.popDraw = function () {
        noValidateIDCardWarn("", "drawMoney");
    };
    $scope.popMoneyDetail=function(){
        noValidateIDCardWarn("", "moneyDeatil");
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

        WebApp.mInstance = modalInstance;
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at:' + new Date());
        });
    }
});
/*
 * 1、 获取投资详情
 */
WebApp.Instance.controller('InvestDetailController', function ($routeParams, $rootScope, $scope, $location, md5, InvestsService, $window, $timeout) {
    $rootScope.investsListDetail = {};
    $scope.iftender = false;
    $scope.fnew = false;
    $scope.ismonth = false;        
    var nowplanName = WebApp.tmpValue.setOrGetStoreVal('Detail_tender_plan_name','');
    var plans = '';

    if(nowplanName=='月计划')
    {
       plans = 'month';
    }
    else if(nowplanName=='季计划')
    {
       plans = 'quarter'; 
    }
    else if(nowplanName=='年计划')
    {
       plans = 'year'; 
    }

    InvestsService.getTenderPeopleNum({plans: plans}, function (data) {
            $scope.detailtenderPeopleNum = data.tenderPeopleNum;
        }, function (data) {
    });

    var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    var getDetail = function (borrowId) {
        InvestsService.getInvestInfo(borrowId, function (data) {            
            data.tenderSchedule = WebApp.Utils.toReverse(data.tenderSchedule);
            data.annualRate = WebApp.Utils.toReverse(data.annualRate,2);
            data.planName = nowplanName;
            data.isNew = WebApp.tmpValue.setOrGetStoreVal('Detail_tender_if_new','');                                       
            $rootScope.investsListDetail = data;
            WebApp.tmpValue.setOrGetStoreVal('objtypeNid', data.typeNid); 
            
            if(data.investmentHorizon=='1个月')
            {
                $scope.ismonth = true;
            }

            if(data.tenderSchedule==100)
            {
                $scope.iftender = false;
            }
            else
            {
                $scope.iftender = true;
            }

            if(data.isNew=='1')
            {
                $scope.fnew = true;
            }
            else
            {
                $scope.fnew = false;
            }
            WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', data.tenderSchedule);
            WebApp.tmpValue.setOrGetStoreVal('Detail_id', data.id);
        });
    };
    getDetail(id);
});
/*
 * 1、 获取投资风险
 */
WebApp.Instance.controller('BorrowerDetailController', function ($routeParams, $rootScope, $scope, $location, md5, InvestsService, $window, $timeout) {
    $scope.borrowerInfo = {};
    var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    var getBorrowerInfo = function (borrowId) {
        InvestsService.getBorrowerInfo(borrowId, function (data) {
            $scope.borrowerInfo = data;
        });
    };
    getBorrowerInfo(id);
});
/*
 * 1、 获取风控信息
 */
WebApp.Instance.controller('InvestProductRiskController', function ($rootScope, $scope, $sce, $location, md5, InvestsService, $window, $timeout) {
    $scope.investsRisk = {};
    var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    $scope.renderHtml = function (htmlCode) {
        return $sce.trustAsHtml(htmlCode);
    };
    var getInvestProductRisk = function (borrowId) {
        InvestsService.getProductRisk(borrowId, function (data) {
            $scope.investsRisk = data;
        });
    };
    // 获取详情
    getInvestProductRisk(id);
});
/*
 * 1、 获取还款模式
 */
WebApp.Instance.controller('PaymentMethodDetailController', function ($rootScope, $scope, $location, md5, InvestsService, $window, $timeout) {
    $scope.investsPaymentMethod = {};
    var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    var getPaymentMethod = function (borrowId) {
        InvestsService.getPaymentMethod(borrowId, function (data) {
            $scope.investsPaymentMethod = data;
        });
    };
    // 获取详情
    getPaymentMethod(id);
});
WebApp.Instance.controller('InvestRecordController', function ($routeParams, $rootScope, $scope, $location, md5, InvestsService, $window, $timeout, $interval) {
		$scope.productData = $rootScope.limitData || null;
		if ($scope.productData) renderTime($scope.productData);
		
		
    $scope.investsPerson = {};
    var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    $scope.tenderSchedules = WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedules', '');

    $scope.show = true;
    
    if ($scope.tenderSchedules == 100) {
        $scope.show = false;
    } else {
        $scope.show = true;
    }
    $scope.investsRecordList = [];
    $scope.ids = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
    var getInvestRecord = function (borrowId) {
        $scope.size = 20;
        $scope.index = 1;
        InvestsService.getInvestRecord({
            borrowId: borrowId,
            pageSize: $scope.size,
            pageIndex: $scope.index
        }, function (data) {
            for (var i = 0; i < data.list.length; i++) {
                $scope.investsRecordList.push(data.list[i]);
            }
            $scope.investsPerson = $scope.investsRecordList;
        });

    };
    // 获取详情
    getInvestRecord(id);

    $scope.sizeBottom = 20;
    $scope.indexBottom = 2;

    $scope.bottom = function () {
        $scope.borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        InvestsService.getInvestRecord({
            borrowId: $scope.borrowId,
            pageSize: $scope.sizeBottom,
            pageIndex: $scope.indexBottom
        }, function (data) {
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
        $scope.borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
        $scope.size = 20;
        $scope.index = 1;
        InvestsService.getInvestRecord({
            borrowId: $scope.borrowId,
            pageSize: $scope.size,
            pageIndex: $scope.index
        }, function (data) {
            $scope.investsRecordList=[];
            for (var i = 0; i < data.list.length; i++) {
                $scope.investsRecordList.push(data.list[i]);
            }
            $scope.investsPerson = $scope.investsRecordList;
            $scope.indexBottom = 2;
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
});
WebApp.Instance.controller('TenderInfoController', function ($routeParams, $modal, $rootScope, $scope, $location, md5, InvestsService, notify , $window, $timeout,$cookies) {
    $scope.nid = '';
    $scope.errorinfo = '';
    $scope.data={};
    $scope.data.increase = 0;
    $scope.data.bouns = 0;
    $scope.conusinfo = "";
    $scope.typeNid = WebApp.tmpValue.setOrGetStoreVal('objtypeNid');
    var proj = {};
    var increaselist = [];
    var bounsList = [];
    $scope.bouns={};
    WebApp.projectData =  WebApp.tmpValue.setOrGetStoreVal('Project_Data', '');
    proj.isAllowIncrease = WebApp.projectData.isAllowIncrease*1;//data.isAllowIncrease;
    proj.isBonusticket = WebApp.projectData.isBonusticket*1;//data.isBonusticket;
    function transInvestmentHorizon(num)
            {
              if(typeof(num) === "string")
             {
                 if(/(\d+)/.test(num)){
                 return RegExp.$1
                 }
                 else
                 {
                  return 0;
                 }
              } 
            else
           {
             return num;
            }
            }
    proj.investmentHorizon = transInvestmentHorizon(WebApp.projectData.investmentHorizon);
     if(WebApp.projectData.isAllowIncrease == 0 && 
             WebApp.projectData.isBonusticket == 0)
     {
        $scope.couposshow = false;
     }
     else
     {
        $scope.couposshow = true;
     }
     var id = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout);
     $scope.nid = id;
     $scope.contactUrl = $location.protocol()+'://mapi.baocai.com/v2/views/contract/protocol/'+id;
     var isloadingAmount = false;
     var needupdate = false;
     var Calc = function(data)
     {
            InvestsService.getBounsInfo(data,function(res)
            {
                var reg = new RegExp("([0-9]+(.[0-9]+)?)");
                 var rew = res.allReward;
                 if(reg.test(rew))
                 {
                    var allre = RegExp.$1;
                    if(reg.test(res.gainCalcDesc[1]))
                    {
                        $scope.data.increase = RegExp.$1;
                        $scope.data.bouns = Math.round((allre - RegExp.$1)*100)/100;
                    }
                 }
                 else
                 {
                    $scope.data.increase=0;
                    $scope.data.bouns=0;
                 }
                 isloadingAmount = false;
                 if(needupdate)
                 {
                    isloadingAmount = true;
                    needupdate = false;
                    data.borrowAmount = $scope.investAmount;
                    Calc(data);

                 }
            },function()
            {
                $scope.data.increase=0;
                $scope.data.bouns=0;
                isloadingAmount = false;
                if(needupdate)
                 {
                    isloadingAmount = true;
                    needupdate = false;
                    data.borrowAmount = $scope.investAmount;
                    Calc(data);
                 }
            });
     };
     //投资金额改变，
    $scope.investAmountChanged = function(notifyState)
    {
        //添加最低可投额限制
        if(WebApp.minLimitStatus == 1 && notifyState != 0)
        {
            notify.closeAll();
            $scope.investAmount = WebApp.projectData.availableAmount_num_new;
            notify({message: WebApp.minLimitMsg, duration: WebApp.duration});
            return;
        }
        proj.investCount = $scope.investAmount;
        //计算优惠券
        $scope.bouns = $scope.autoSelect($scope.investAmount);
        //优惠券
        if($scope.bouns && $scope.bouns.increase)
        {
            WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount_increase', $scope.bouns.increase.id);
            WebApp.tmpValue.invest_increase = $scope.bouns.increase.id;
        }
        else
        {
            WebApp.tmpValue.invest_increase = 0;
        }
        if($scope.bouns && $scope.bouns.bonus)
        {
           WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount_bonus', $scope.bouns.bonus.id);
            WebApp.tmpValue.invest_bonus = $scope.bouns.bonus.id;
        }
        else
        {
            WebApp.tmpValue.invest_bonus= 0;
        }
        $scope.conusinfo = "";
        //加息券
        if($scope.bouns.increase)
        {
            $scope.conusinfo = "加息"+$scope.bouns.increase.apr+"% ";
        }
        
        //红包券
        if($scope.bouns.bonus)
        {
            $scope.conusinfo += "" + $scope.bouns.bonus.money + "元红包";
        }

        //没有
        if($scope.bouns.increase == null && $scope.bouns.bonus == null)
        {
            if($scope.canConpusUse)
            {
                $scope.conusinfo = "不使用";
            }
            else
            {
                $scope.conusinfo = "";
            }
        }
        //计算奖励
        var data = {};
        data.borrowId = id;
        data.borrowAmount = $scope.investAmount;
        if($scope.bouns.bonus)
            data.bonusTicketId = $scope.bouns.bonus.id;
        else
        {
            data.bonusTicketId=0;
        }
        if($scope.bouns.increase)
        {
            data.increaseTicketId = $scope.bouns.increase.id;
        }
        else
        {
            data.increaseTicketId=0;
        }
        data.tenderUseTicketStyle = "hand";
        if(!isloadingAmount)
        {
            isloadingAmount = true;
            Calc(data);
        }
        else
        {
            needupdate = true;
        }
    }
    $scope.conpusReady = false;
    //有数据
    if(WebApp.proj)
    {
        $scope.conpusReady = true;
        proj = WebApp.proj;
        increaselist = proj.increaseList;
        bounsList = proj.bounsList;
        $scope.investAmount = proj.investCount;
        $scope.conusinfo = "";
        $scope.bouns = proj.bouns;
        $scope.canConpusUse = WebApp.proj.canConpusUse;
        //优惠券
        if($scope.bouns && $scope.bouns.increase)
        {
            WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount_increase', $scope.bouns.increase.id);
            WebApp.tmpValue.invest_increase = $scope.bouns.increase.id;
        }
        else
        {
            WebApp.tmpValue.invest_increase = 0;
        }
        if($scope.bouns && $scope.bouns.bonus)
        {
           WebApp.tmpValue.setOrGetStoreVal('Detail_investAmount_bonus', $scope.bouns.bonus.id);
            WebApp.tmpValue.invest_bonus = $scope.bouns.bonus.id;
        }
        else
        {
            WebApp.tmpValue.invest_bonus = 0;
        }

        //加息券
        if($scope.bouns.increase && $scope.bouns.increase.id !=0)
        {
            $scope.conusinfo = "加息"+$scope.bouns.increase.apr+"% ";
        }
        
        //红包券
        if($scope.bouns.bonus && $scope.bouns.bonus.id !=0)
        {
            $scope.conusinfo += "" + $scope.bouns.bonus.money + "元红包";
        }

        //没有
        if($scope.conusinfo == "")
        {
            if($scope.canConpusUse)
            {
                $scope.conusinfo = "不使用";
            }
            else
            {
                 $scope.conusinfo = "";
            }
        }

        //计算奖励
        var data = {};
        data.borrowId = id;
        data.borrowAmount = $scope.investAmount;
        if($scope.bouns.bonus)
            data.bonusTicketId = $scope.bouns.bonus.id;
        else
        {
            data.bonusTicketId=0;
        }
        if($scope.bouns.increase)
        {
            data.increaseTicketId = $scope.bouns.increase.id;
        }
        else
        {
            data.increaseTicketId=0;
        }
        data.tenderUseTicketStyle = "hand";
        InvestsService.getBounsInfo(data,function(res)
        {
            var reg = new RegExp("([0-9]+(.[0-9]+)?)");
             var rew = res.allReward;
             if(reg.test(rew))
             {
                var allre = RegExp.$1;
                if(reg.test(res.gainCalcDesc[1]))
                {
                    $scope.data.increase = RegExp.$1;
                    $scope.data.bouns = Math.round((allre - RegExp.$1)*100)/100;
                }
                else
                {
                    $scope.data.increase=0;
                    $scope.data.bouns=0;
                }
             }
        },function()
        {
          $scope.data.increase=0;
         $scope.data.bouns=0;
        });
    }
    else
    {
        //获取用户优惠券
        InvestsService.getUserCoupons(function(data)
        {
            increaselist = data.increaseList;
            bounsList = data.bounsList;
            proj.increaseList = increaselist;
            proj.bounsList = bounsList;
        })
    }
    WebApp.proj = null;
    $scope.formatNum = function(nStr)
    {
        nStr += ''; 
        x = nStr.split('.'); 
        x1 = x[0]; 
        x2 = x.length > 1 ? '.' + x[1] : ''; 
        var rgx = /(\d+)(\d{3})/; 
        while (rgx.test(x1)) { 
            x1 = x1.replace(rgx, '$1' + ',' + '$2'); 
        } 
        return x1 + x2; 
    };
    //优惠券自动选择
    $scope.autoSelect = function(numCount)
    {
        if(numCount == null || numCount=="")
        {
            numCount = 0;
        }

        numCount = numCount*1;
        if(typeof(numCount) != "number")
        {
            numCount=0;
        }
        var res = {};
        //允许使用加息券
        var incId = null;
        var curDD = 0;
        var endDD = '';
        $scope.canConpusUse = false;
        if(proj.isAllowIncrease==1)
        {
            for(var i = 0;i<increaselist.length;i++)
            {
                //判断时间是否可用
                var curdate = new Date();
                var startdate = new Date(increaselist[i].starttime*1000);
                var enddate = new Date(increaselist[i].endtime*1000);
                if(curdate <startdate || curdate > enddate)
                {
                    //不可用   
                    continue;
                }
                //判断金额
                if(numCount < increaselist[i].useMoney*1)
                {
                    continue;
                }
                $scope.canConpusUse = true;
                if(curDD < increaselist[i].apr*1 || incId == null)
                {
                    curDD = increaselist[i].apr*1;
                    incId = increaselist[i];
                    endDD = increaselist[i].endtime;
                }
                else if(curDD == increaselist[i].apr*1)
                {
                    //相等选择有效期短的
                    if(endDD > increaselist[i].endtime)
                    {
                        curDD = increaselist[i].apr*1;
                        incId = increaselist[i];
                        endDD = increaselist[i].endtime
                    }
                }
            }
        }
         res.increase = incId;
         incId = null;
         curDD = 0;
         endDD = '';
        //选择红包券
        if(proj.isBonusticket==1)
        {
            for(var i=0;i<bounsList.length;i++)
            {
                //检查是否首投
                if(bounsList[i].catName == "E" || bounsList[i].catName == "F" || bounsList[i].catName == "K")
                {
                    if(!proj.isFirstTender)
                    {
                        continue;
                    }
                }
                //检查期数
                if(bounsList[i].borrowPeriod == 1 && proj.investmentHorizon != 1)
                {
                    continue;
                }
                else if(bounsList[i].borrowPeriod == 2 && proj.investmentHorizon >3)
                {
                    continue;
                }
                else if(bounsList[i].borrowPeriod == 3 && proj.investmentHorizon <3)
                {
                    continue;
                }
                else if(bounsList[i].borrowPeriod == 4 && proj.investmentHorizon <6)
                {
                    continue;
                }
                
                //金额检查
                if(numCount*1 < bounsList[i].useMoney*1)
                {
                    continue;
                }
                //检查结束时间
                if(new Date(bounsList[i].expiredTime*1000) <  new Date())
                {
                    continue;
                }
                $scope.canConpusUse = true;
                if(curDD*1 < bounsList[i].money*1)
                {
                    curDD = bounsList[i].money*1;
                    incId = bounsList[i];
                    endDD = bounsList[i].expiredTime
                }
                else if(curDD*1 == bounsList[i].money*1)
                {
                    //相等选择有效期短的
                    if(endDD > bounsList[i].expiredTime)
                    {
                        curDD = bounsList[i].money*1;
                        incId = bounsList[i];
                        endDD = bounsList[i].expiredTime
                    }
                }
            }
        }
        res.bonus = incId;
        return res;
    };


    //借款合同页面
    $scope.gotoHet = function()
    {
        
    }

    //跳转到优惠券选择
    $scope.gotoSelectCoupos = function()
    {
        if(!$scope.conpusReady)
            return;
        var tmp = proj;
        WebApp.proj = proj;
        WebApp.proj.canConpusUse = $scope.canConpusUse;
        tmp.tenderInfo = $scope.tenderInfo;
        tmp.bouns = $scope.bouns;
        WebApp.tmpValue.setOrGetStoreVal('Bonus_Info', tmp);
        $timeout(function () {
                $location.path(WebApp.Router.INVEST_COUPONS);
            }, 0);
    }


    $scope.acode_back = function(){
        $timeout(function () {
            $location.path(history.go(-1));
        }, 0);
    };

    $scope.acode_confirm = function(){
        InvestsService.checkActiveCode({
            activezxcode:$scope.typeacode,
            borrowNid:$scope.nid
        },function(data){
            if(data.code=="200")
            {
                var expireDate = new Date();
                expireDate.setDate(expireDate.getDate() + 7);
                $cookies.put('f_active_code'+$scope.nid, $scope.typeacode, {'expires': expireDate});
                $scope.ifHasActiveCode = false;
            }        

        },function(data){
            if(data.code=="400")
            {
                $scope.errorinfo = data.message;
                return;
            }
        })
    };

    $scope.clearerr = function(){
        $scope.errorinfo = '';
    };


    
    
    var getTenderInfo = function (borrowId) {
        InvestsService.getTenderInfo(id, function (data) {
            WebApp.tenderInfo = data;
            $scope.tenderInfo = data;
            /*if(data.isActivezx=='1'){
                var now_active_code = $cookies.get("f_active_code"+$scope.nid);
                if(!now_active_code){
                    $scope.ifHasActiveCode = true;
                    WebApp.tenderInfo.ifHasActiveCode = true;
                }

                if(now_active_code)
                {
                    InvestsService.checkActiveCode({
                        activezxcode:now_active_code,
                        borrowNid:$scope.nid
                    },function(data){                         

                    },function(data){                       
                       $scope.ifHasActiveCode = true;   
                       WebApp.tenderInfo.ifHasActiveCode = true;                  
                    })
                }
            } */           
            

            proj.isFirstTender = data.isFirstTender;    
            proj.isAllowIncrease = WebApp.projectData.isAllowIncrease*1;//data.isAllowIncrease;
            proj.isBonusticket = WebApp.projectData.isBonusticket*1;//data.isBonusticket;
            $scope.conpusReady = true;
            WebApp.tmpValue.setOrGetStoreVal('Detail_tenderAccount', data.availableBalance);
        }, function (data) {
            WebApp.UI.alert(data, $location, $timeout);
        });
    };
    if(WebApp.tenderInfo && false)
    {
        $scope.conpusReady = true;
        $scope.tenderInfo = WebApp.tenderInfo;
        $scope.nid = WebApp.tenderInfo.borrowNid;
        $scope.ifHasActiveCode = WebApp.tenderInfo.ifHasActiveCode;
        WebApp.tenderInfo = null;
    }
    else
    {
         $scope.tenderInfo = {};
         $scope.tenderInfo.availableBalance =0;
         $scope.tenderInfo.availableAmount = 0;
        // 获取详情
        getTenderInfo(id);
    }
    
    WebApp.minLimitStatus = 0;
    if(WebApp.projectData.tenderAccountMin > 100 && WebApp.projectData.availableAmount_num_new <= WebApp.projectData.tenderAccountMin)
    {
        $scope.investAmount = WebApp.projectData.availableAmount_num_new;
        WebApp.minLimitStatus = 1;
        WebApp.minLimitMsg = '可投金额为'+$scope.investAmount+'元';
        $scope.investAmountChanged(0);
    }
    $scope.projectData = WebApp.projectData;
});






