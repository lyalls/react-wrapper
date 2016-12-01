/**
 * Created by lipeng on 16-11-16.
 */
WebApp.Instance.controller('MycouponController',function($scope,$modal,md5,$log,AccountService,MycouponService,notify, $http, $timeout, $location, $cookies, $interval, $rootScope) {

    var UserInfo = WebApp.ClientStorage.getCurrentUser();
    if(!UserInfo)
    {
        AccountService.myAccountINfo(function (data) {
            UserInfo = data;
        }, function (data) {
            notify.closeAll();
            $cookies.put('login_url', WebApp.Router.MY_COUPON);
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return ;
        });
    }

    $scope.optiontag = "hong"; //默认红包券

    //标签切换
    $scope.changetag = function(tag)
    {
        if(tag == "jia") {
            $scope.optiontag = "jia";//加息券
            $scope.coupon_shiyong = $scope.Increase_shiyong;//去使用提示
        }
        else {
            $scope.optiontag = "hong";//红包券
            $scope.coupon_shiyong = $scope.Bouns_shiyong;//去使用提示
        }
    }


    $scope.BounsPageI = 1; //默认页码
    $scope.BounsPageS = 3; //默认个一页显示多少
    $scope.BounsList = [];
    $scope.Bouns_more = 1; //更多展示
    $scope.Bouns_pageCount = 0;
    $scope.Bouns_shiyong = 1;//去使用提示

    $scope.IncreasePageI = 1; //默认页码
    $scope.IncreasePageS = 3; //默认个一页显示多少
    $scope.IncreaseList = [];
    $scope.Increase_more = 1; //更多展示
    $scope.Increase_pageCount = 0;
    $scope.Increase_shiyong = 1;//去使用提示

    $scope.coupon_shiyong = 1;//去使用提示

    //获取红包列表
    $scope.getBounsList = function() {
        MycouponService.getBonusList({pageIndex:$scope.BounsPageI,pageSize:$scope.BounsPageS}, function (data) {

            var borrow_period = {'0':'不限','1':'1个月','2':'1-3个月','3':'3个月及以上','4':'6个月及以上'};
            for(var i=0;i<data.list.length;i++)
            {
                //投资期限
                if(data.list[i].borrowPeriod==0)
                    data.list[i].borrowPeriodName = borrow_period[data.list[i].borrowPeriod];
                else
                    data.list[i].borrowPeriodName = borrow_period[data.list[i].borrowPeriod]+'项目可用';
            }

            //如果一页都没有
            if(data.pageCount == 0)
            {
                //不显示更多按钮
                $scope.Bouns_more = 0;
                $scope.Bouns_shiyong = 0;//去使用提示

                //默认
                if($scope.optiontag=='hong')
                    $scope.coupon_shiyong = 0;//去使用提示
            }

            $scope.Bouns_pageCount = data.pageCount;
            //说明这是最后一页
            if(data.pageCount !=0 && data.pageCount == data.pageIndex)
            {
                $scope.Bouns_more = 0;
            }

            $scope.BounsList = $scope.BounsList.concat(data.list);

            data.pageIndex = parseInt(data.pageIndex);
            data.pageSize = parseInt(data.pageSize);
            $scope.BounsPageI = data.pageIndex+1;
            if($scope.BounsPageI>data.pageCount)
                $scope.BounsPageI = data.pageCount;
            $scope.BounsPageS = data.pageSize;


        }, function (data) {
        });
    }
    //获取加息列表
    $scope.getIncreaseList = function() {
        MycouponService.getIncreaseList({pageIndex:$scope.IncreasePageI,pageSize:$scope.IncreasePageS}, function (data) {

            //如果一页都没有
            if(data.pageCount == 0)
            {
                //不显示更多按钮
                $scope.Increase_more = 0;
                $scope.Increase_shiyong = 0;//去使用提示

                //默认
                if($scope.optiontag=='jia')
                    $scope.coupon_shiyong = 0;//去使用提示
            }

            $scope.Increase_pageCount = data.pageCount;
            //说明这是最后一页
            if(data.pageCount !=0 && data.pageCount == data.pageIndex)
            {
                $scope.Increase_more = 0;
            }

            $scope.IncreaseList = $scope.IncreaseList.concat(data.list);

            data.pageIndex = parseInt(data.pageIndex);
            data.pageSize = parseInt(data.pageSize);
            $scope.IncreasePageI = data.pageIndex+1;
            if($scope.IncreasePageI>data.pageCount)
                $scope.IncreasePageI = data.pageCount;
            $scope.IncreasePageS = data.pageSize;

        }, function (data) {
        });
    }

    //立即使用
    $scope.gohome = function()
    {
        $timeout(function () {
            $location.path(WebApp.Router.HOME);
        }, 0);
    }

});
