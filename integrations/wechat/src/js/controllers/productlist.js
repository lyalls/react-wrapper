/**
 * Created by lipeng on 16-9-23.
 */
WebApp.Instance.controller('ProductlistController', function ($rootScope, $scope, $location, md5, $modal, InvestsService, notify, $window, $log, $timeout,$cookies, $interval) {
    $rootScope.investAmount = '';
    $scope.pageSize = 10;
    $scope.pageIndex = 1;
    $scope.investsList = [];
    $scope.passwordConfirm = "";
    $scope.nowPage = 1;
    $scope.if_tender_tip_show = false;




    $scope.clickaddlist = function(){
        InvestsService.getH5InvestsList({
            pageSize: 10*$scope.nowPage,
            pageIndex: 1
        }, function (data) {
            $scope.investsList = [];
            var biao_tag = {'xins':'yellow-tag','xianl':'orange-tag','bld':'purple-tag','gou':'blue-tag','rongsan':'orange-l-tag','fangchan':'yellow-l-tag','newb':'red-dark-tag','memb':'member-tag'};
            var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷'};
            //根据不同的标的类型显示不同的底色图标
            var biao_typenid_bgcss ={'rongsan':'bg-06','bld':'bg-03','fangchan':'bg-05','gou':'bg-04'};
            var biao_type_zi = '';
            var biao_type_zi_bgcss = '';
            var biao_type_zi_type = '';
            for (var i = 0; i < data.list.length; i++) {
                data.list[i].tenderSchedule = WebApp.Utils.toReverse(data.list[i].tenderSchedule);
                data.list[i].annualRate = WebApp.Utils.toReverse(data.list[i].annualRate,2);

                biao_type_zi = biao_typenid[data.list[i].typeNid];
                biao_type_zi_bgcss = biao_typenid_bgcss[data.list[i].typeNid];
                biao_type_zi_type = data.list[i].typeNid;
                if(biao_type_zi == 'undefined' || typeof(biao_type_zi) == 'undefined') {
                    biao_type_zi = '新项目';
                    biao_type_zi_bgcss = 'bg-07';
                    biao_type_zi_type ='newb';
                }
                if(data.list[i].tenderSchedule !=100 && data.list[i].isNew ==1)
                {
                    biao_type_zi = '新手标';
                    biao_type_zi_bgcss = 'bg-01';
                    biao_type_zi_type = 'xins';
                }
                if(data.list[i].isLimit==1)
                {
                    biao_type_zi = '限量标';
                    biao_type_zi_bgcss = 'bg-02';
                    biao_type_zi_type = 'xianl';
                }
                if(data.list[i].tenderSchedule !=100 && data.list[i].isMember ==1)
                {
                    biao_type_zi = '会员标';
                    biao_type_zi_bgcss = 'bg-08';
                    biao_type_zi_type = 'memb';
                }
                if (data.list[i].isLimit==1 && data.list[i].limitTime > 0) {

                    data.list[i].timer = returnTime(data.list[i]);
                    (function(i) {
                        data.list[i].TimerId = $interval(function() {
                            data.list[i].limitTime = (+data.list[i].limitTime) -1;
                            data.list[i].timer = returnTime(data.list[i]);
                        }, 1000);
                    })(i);
                }

                //是否有置顶标
                if(i == 0)
                {
                    is_zhiding = data.iszd;
                }
                else
                {
                    is_zhiding = false;
                }


                if(data.list[i].statusMessage =='复审中' || data.list[i].statusMessage=='复审')
                {
                    data.list[i].img_type = 3;
                }

                if(data.list[i].statusMessage =='还款中' || data.list[i].statusMessage=='还款')
                {
                    data.list[i].img_type = 2;
                }

                if(is_zhiding)
                    data.list[i].img_type = 1;

                //起投金额
                var StartInvestTag = data.list[i].tenderAccountMin;
                if(StartInvestTag>=10000)
                {
                    StartInvestTag = parseInt(StartInvestTag/10000)+"万";
                }
                data.list[i].StartInvestTag = StartInvestTag;

                data.list[i].biao_type_zi = biao_type_zi;
                data.list[i].biao_type_zi_bgcss = biao_type_zi_bgcss;
                data.list[i].biaotag = biao_tag[biao_type_zi_type];
                $scope.investsList.push(data.list[i]);
            }
            //console.log(data);
            $scope.nowPage++;
        });
    }

    function returnTime(data) {
        var time = data.limitTime;
        if (time <= 0) $interval.cancel(data.TimerId);
        var h = Math.floor(time/3600);
        var m = Math.floor(time%3600/60);
        var s = Math.floor(time%3600%60);
        if(h<10)
            h='0'+h;
        if(m<10)
            m='0'+m;
        if(s<10)
            s='0'+s
        return h + ':' + m + ':' + s;
    }


    //投资详情
    $scope.getInvestDetail = function (borrowId,pname,ifnew,limitTime) {
        if (arguments.length >= 4 && arguments[3] > 0) {
            dialog();
            return; //限量标不给跳转
        }
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


    function dialog()
    {
        var modalInstance = $modal.open({
            animation: true,
            templateUrl: 'xlbDialog',
            controller:'homePop',
            size: 20,
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
    };

});


//标详情

WebApp.Instance.controller('ProductdetailController', function ($routeParams, $rootScope, $scope,$modal, $location, md5, InvestsService,AccountService, notify, $window, $timeout,$cookies,$log) {
    $scope.ifHasActiveCode = false;
    $rootScope.investsDetail = {};
    $scope.iftender = false;
    $scope.fnew = false;
    $scope.ismonth = false;
    
    var zxmts = false; //专享标，弹框 关闭是否跳转；
    var borrowId = $routeParams.id;
    if(borrowId == null || borrowId == '')
    {
        borrowId = WebApp.Value.getStoreVal('Detail_borrowId', '', $location, $timeout) ;
    }
    //console.log(borrowId);
    var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷'};
    InvestsService.getProductInfo(borrowId, function (data) {
        data.tenderSchedule = WebApp.Utils.toReverse(data.tenderSchedule);
        data.annualRate = WebApp.Utils.toReverse(data.annualRate,2);
        data.isNew = WebApp.tmpValue.setOrGetStoreVal('Detail_tender_if_new','');

        biao_type_zi = biao_typenid[data.typeNid];
        //objtypeNid,标的类型，用来在投资页判断合同信息
        WebApp.tmpValue.setOrGetStoreVal('objtypeNid', data.typeNid);
        $scope.typeNid = data.typeNid;
        if(biao_type_zi == 'undefined' || typeof(biao_type_zi) == 'undefined')
            biao_type_zi = '新项目';

        if(data.tenderSchedule !=100 && data.isMember ==1)
        {
            biao_type_zi = '会员标';
        }
        if(data.tenderSchedule !=100 && data.isNew ==1)
        {
            biao_type_zi = '新手标';
        }
        if(data.isLimit ==1)
        {
            biao_type_zi = '限量标';
             if(borrowId != '' && data.limitTime > 0)
             {
                 $location.path($location.host());
             }
        }
        data.availableAmount_num_new = data.availableAmount_num.replace(',','').slice(0,-3)
        data.availableAmount_num_new = parseInt(data.availableAmount_num_new);
        data.tenderAccountMin = parseInt(data.tenderAccountMin);
        if(data.isFullThreshold == 1 && parseInt(data.availableAmount) >=1)
        {
            data.availableAmount_num = data.availableAmount;
        }


        //起投金额
        var StartInvestTag = data.tenderAccountMin;
        if(StartInvestTag>=10000)
        {
            StartInvestTag = parseInt(StartInvestTag/10000)+"万";
        }
        data.StartInvestTag = StartInvestTag;

        $scope.biao_type_name = biao_type_zi;
        $rootScope.investsDetail = data;

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
        WebApp.tmpValue.setOrGetStoreVal('Project_Data', data);

        //如果是专享码 立即弹框
        if(data.borrowType == 2)
        {
            var f_active_code = $cookies.get('f_active_code'+borrowId);
            if(f_active_code)
            {
                $log.info('test:' + new Date());
            }
            else {
                $scope.ifHasActiveCode = true;
            }
        }

        //console.log(data);
    });


    //投资人详情
    $scope.getBorrowerInfo = function (borrowId) {
        //WebApp.tmpValue.setOrGetStoreVal('borrowId',borrowId);
        WebApp.Value.getStoreVal('borrowId', borrowId, $location, $timeout);
        WebApp.tmpValue.setOrGetStoreVal('objttype', 'borrower');
        $timeout(function () {
            $location.path(WebApp.Router.PROJECT_INTRO);
        }, 0);
    };

    //项目风控详情页
    $scope.getProjectInfo = function (borrowId) {
        //WebApp.tmpValue.setOrGetStoreVal('borrowId',borrowId);
        WebApp.Value.getStoreVal('borrowId', borrowId, $location, $timeout);
        WebApp.tmpValue.setOrGetStoreVal('objttype', 'intro');
        $timeout(function () {
            $location.path(WebApp.Router.PROJECT_INTRO);
        }, 0);
    };

    //投资记录页
    $scope.getRecordInfo = function (borrowId) {
        //WebApp.tmpValue.setOrGetStoreVal('borrowId',borrowId);
        WebApp.Value.getStoreVal('borrowId', borrowId, $location, $timeout);
        WebApp.tmpValue.setOrGetStoreVal('objttype', 'records');
        $timeout(function () {
            $location.path(WebApp.Router.PROJECT_INTRO);
        }, 0);
    };

    $scope.getTenderInfoDetail = function (borrowId) {
        zxmts = true;
        var UserInfo = WebApp.ClientStorage.getCurrentUser();
        if(!UserInfo)
        {
            AccountService.myAccountINfo(function (data) {
               UserInfo = data;
            }, function (data) {
                notify.closeAll();
                $cookies.put('login_url', WebApp.Router.INVEST_DETAIL);
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
                return ;
            });
        }
        if (borrowId>0) {

            //判断是新手标，专享码标
            var projectData =  WebApp.tmpValue.setOrGetStoreVal('Project_Data', '');
            var borrowType = projectData.borrowType;

            WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
            //专享码
            if(borrowType == 2){
                //弹出专享码框框
                //提取cook

                var f_active_code = $cookies.get('f_active_code'+borrowId);
                if(f_active_code)
                {
                    //跳转到投资页
                    $timeout(function () {
                        $location.path(WebApp.Router.INVEST);
                    }, 0);
                }
                else {
                    $scope.ifHasActiveCode = true;
                }
            }else if(borrowType == 1) {
                //是新手标，判断用户是否有新手资格
                InvestsService.getTenderInfo(borrowId, function (data) {
                    //新手码 (如果不是新手　弹框)
                    if (!data.isFirstTender ) {
                        dialog();
                    }
                    else
                    {
                        //跳转到投资页
                        $timeout(function () {
                            $location.path(WebApp.Router.INVEST);
                        }, 0);
                    }
                });
            }
            else{
                //跳转到投资页
                $timeout(function () {
                    $location.path(WebApp.Router.INVEST);
                }, 0);
            }

        }

    };

    $scope.clearerr = function(){
        $scope.errorinfo = '';
    };

    $scope.acode_back = function(){
        $scope.ifHasActiveCode = false;
        $timeout(function () {
            $location.path(history.go(-1));
        }, 0);
    };

    $scope.acode_confirm = function(){

        InvestsService.checkActiveCode({
            activezxcode:$scope.typeacode,
            borrowNid:borrowId
        },function(data){
            if(data.code=="200")
            {
                var expireDate = new Date();
                expireDate.setDate(expireDate.getDate() + 7);
                $cookies.put('f_active_code'+borrowId, $scope.typeacode, {'expires': expireDate});
                $scope.ifHasActiveCode = false;
                //跳转到投资页
                if(zxmts== true) {
                    $timeout(function () {
                        $location.path(WebApp.Router.INVEST);
                    }, 0);
                }
            }

        },function(data){
            if(data.code=="400")
            {
                $scope.errorinfo = data.message;
                return;
            }
        })
    };


    function dialog()
    {
        var modalInstance = $modal.open({
            animation: true,
            templateUrl: 'xszxDialog',
            controller:'homePop',
            size: 20,
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
    };

});






