/**
 * Created by lipeng on 16-9-21.
 */
WebApp.Instance.controller('NewhomeController',function($scope,$modal,md5,StagingService,NowhomeService,$log, notify, $http, $timeout, $location, $cookies, AccountService, $interval, $rootScope){
    $scope.goToUser = "#"+WebApp.Router.USERS_ACCOUNT;
    $scope.investsList = [];
    $scope.investsLen = 0;

    StagingService.getBannerData(function (data) {
        //最多显示4张轮播图片
        var len = data.length;
        if(len>4)
        {
            for(var i=0;i<len-4;i++)
            data.pop();
        }
        $scope.banners = data;
    }, function (data) {
        notify.closeAll();
        notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
    });

    $scope.financingData = {};


    //跳转到列表页
    $scope.gotolist = function ()
    {
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_LIST);
        }, 0);
    }

    //获取可投表 数据
    $scope.getInvestsList = function(){
        NowhomeService.getTopInverstsList(function (data) {
            $scope.investsList = [];
            var biao_tag = {'xins':'yellow-tag','xianl':'orange-tag','bld':'purple-tag','gou':'blue-tag','rongsan':'orange-l-tag','fangchan':'yellow-l-tag','newb':'red-dark-tag'};
            var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷'};
            //根据不同的标的类型显示不同的底色图标
            var biao_typenid_bgcss ={'rongsan':'bg-06','bld':'bg-03','fangchan':'bg-05','gou':'bg-04'};
            var biao_type_zi = '';
            var biao_type_zi_bgcss = '';
            var biao_type_zi_type = '';
            var is_zhiding = false;
            if(data.lastTenderInfo != 'undefined' && typeof(data.lastTenderInfo) != 'undefined')
                $scope.lastTenderInfo = data.lastTenderInfo;
            else
                $scope.lastTenderInfo =false;

            for (var i = 0; i < data.tenderList.length; i++) {

                data.tenderList[i].annualRate = WebApp.Utils.toReverse(data.tenderList[i].annualRate,2);
                //是否有置顶标
                if(i == 0)
                {
                    is_zhiding = data.is_zhiding;
                }
                else
                {
                    is_zhiding = false;
                }

                biao_type_zi = biao_typenid[data.tenderList[i].typeNid];
                biao_type_zi_bgcss = biao_typenid_bgcss[data.tenderList[i].typeNid];
                biao_type_zi_type = data.tenderList[i].typeNid;
                if(biao_type_zi == 'undefined' || typeof(biao_type_zi) == 'undefined') {
                    biao_type_zi = '新项目';
                    biao_type_zi_bgcss = 'bg-07';
                    biao_type_zi_type ='newb';
                }

                if(data.tenderList[i].tenderSchedule !=100 && data.tenderList[i].isNew ==1)
                {
                    biao_type_zi = '新手标';
                    biao_type_zi_bgcss = 'bg-01';
                    biao_type_zi_type = 'xins';
                }
                if(data.tenderList[i].isLimit == 1)
                {
                    biao_type_zi = '限量标';
                    biao_type_zi_bgcss = 'bg-02';
                    biao_type_zi_type = 'xianl';
                }
                if (data.tenderList[i].isLimit == 1 && data.tenderList[i].limitTime > 0) {

                    data.tenderList[i].timer = returnTime(data.tenderList[i]);
                    (function(i) {
                        data.tenderList[i].TimerId = $interval(function() {
                            data.tenderList[i].limitTime = (+data.tenderList[i].limitTime) -1;
                            data.tenderList[i].timer = returnTime(data.tenderList[i]);
                        }, 1000);
                    })(i);
                }

                data.tenderList[i].biao_type_zi = biao_type_zi;
                data.tenderList[i].biao_type_zi_bgcss = biao_type_zi_bgcss;
                data.tenderList[i].biaotag = biao_tag[biao_type_zi_type];
                data.tenderList[i].is_zhiding = is_zhiding;
                $scope.investsList.push(data.tenderList[i]);
            }

            $scope.investsLen = data.tenderList.length;
            //console.log($scope.investsList);
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
    //立即投资
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

WebApp.Instance.controller('homePop', function ($scope, $modalInstance, $log, $modal, $timeout, $location, md5, items) {
    $scope.items = items;
    $scope.selected = {
        item: $scope.items
    };

    $scope.ok = function () {
        $modalInstance.close($scope.selected.item);
    };
});