/**
 * Created by lipeng on 16-11-9.
 */
WebApp.Instance.controller('MyinvestController',function($scope,$modal,md5,$log,AccountService,MyinvestService,notify, $http, $timeout, $location, $cookies, $interval, $rootScope) {

    var UserInfo = WebApp.ClientStorage.getCurrentUser();
    if(!UserInfo)
    {
        AccountService.myAccountINfo(function (data) {
            UserInfo = data;
        }, function (data) {
            notify.closeAll();
            $cookies.put('login_url', WebApp.Router.MY_INVEST);
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return ;
        });
    }

    var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷','isnew':'新手标','islimit':'限量标','newpro':'新项目'};
    var biao_typenid_class = {'rongsan':'invest-type-red','bld':'invest-type-purple','fangchan':'invest-type-gold','gou':'invest-type-blue','isnew':'invest-type-yellow','islimit':'invest-type-dark-red','newpro':'invest-type-red-new'};

    $scope.optiontag = "repaymenting"; //选项卡默认的 还款中

    $scope.roamNoPageI = 1; //默认页码
    $scope.roamNoPageS = 10; //默认个一页显示多少
    $scope.ing_datalist = [];

    //标签切换
    $scope.changetag = function(tag)
    {
        if(tag == "investing")
            $scope.optiontag = "investing";//投资中
        else if(tag == "repaymentend")
            $scope.optiontag = "repaymentend"; //已还款
        else
            $scope.optiontag = "repaymenting";//还款中

        WebApp.tmpValue.setOrGetStoreVal('My_Invest_Optiontag_Type',$scope.optiontag);
    }
    var tagType = WebApp.tmpValue.setOrGetStoreVal('My_Invest_Optiontag_Type');
    if(tagType)
    {
        $scope.optiontag = tagType;
    }
    else
    {
        WebApp.tmpValue.setOrGetStoreVal('My_Invest_Optiontag_Type',$scope.optiontag);
    }

    /**
     * type loan(投资中) roamNo(回收中) roamYes(已回购/已回收)
     * */
    //获取还款中的数据
    $scope.getRepaymenting = function()
    {
        pageIndex = $scope.roamNoPageI;
        pageSize = $scope.roamNoPageS; //设定默认值
        $scope.ing_more = 1; //默认显示 更多
        $scope.ing_tou = 0; //默认不显示 引导图标
        MyinvestService.getInvestsList({type:'roamNo',pageIndex:pageIndex,pageSize:pageSize},function (data) {

            for (var i = 0; i < data.tenderList.length; i++) {
                data.tenderList[i].typeNidZi = biao_typenid[data.tenderList[i].type_nid];
                data.tenderList[i].typeNidCss = biao_typenid_class[data.tenderList[i].type_nid];
                //默认新项目
                if(data.tenderList[i].typeNidZi == 'undefined' || typeof(data.tenderList[i].typeNidZi) == 'undefined') {
                    data.tenderList[i].typeNidZi = biao_typenid['newpro'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['newpro'];
                }
                //新手标
                if( parseInt(data.tenderList[i].is_new) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['isnew'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['isnew'];
                }
                //限量标
                if( parseInt(data.tenderList[i].is_limit) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['islimit'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['islimit'];
                }
            }

            //判断有没有标、
            if(data.pageCount == 0)
            {
                //不显示更多按钮
                $scope.ing_more = 0;
                //没有标 引导用户投标  显示
                $scope.ing_tou = 1;
            }

            //说明这是最后一页
            if(data.pageCount !=0 && data.pageCount == data.pageIndex)
            {
                $scope.ing_more = 0;
            }

            $scope.ing_datalist = $scope.ing_datalist.concat(data.tenderList);
            $scope.ing_type = data.tenderType;
            data.pageIndex = parseInt(data.pageIndex);
            data.pageSize = parseInt(data.pageSize);
            $scope.roamNoPageI = data.pageIndex+1;
            if($scope.roamNoPageI>data.pageCount)
                $scope.roamNoPageI = data.pageCount;
            $scope.roamNoPageS = data.pageSize;
        }, function (data) {
        });
    }



    $scope.loanNoPageI = 1; //默认页码
    $scope.loanNoPageS = 10; //默认个一页显示多少
    $scope.loaning_datalist = [];
    //获取投资中的数据
    $scope.getLoaning = function()
    {
        pageIndex = $scope.loanNoPageI;
        pageSize = $scope.loanNoPageS; //设定默认值
        $scope.loaning_more = 1; //默认显示 更多
        $scope.loaning_tou = 0; //默认不显示 引导图标
        MyinvestService.getInvestsList({type:'loan',pageIndex:pageIndex,pageSize:pageSize},function (data) {
            for (var i = 0; i < data.tenderList.length; i++) {
                data.tenderList[i].typeNidZi = biao_typenid[data.tenderList[i].type_nid];
                data.tenderList[i].typeNidCss = biao_typenid_class[data.tenderList[i].type_nid];
                //默认新项目
                if(data.tenderList[i].typeNidZi == 'undefined' || typeof(data.tenderList[i].typeNidZi) == 'undefined') {
                    data.tenderList[i].typeNidZi = biao_typenid['newpro'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['newpro'];
                }
                //新手标
                if( parseInt(data.tenderList[i].is_new) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['isnew'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['isnew'];
                }
                //限量标
                if( parseInt(data.tenderList[i].is_limit) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['islimit'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['islimit'];
                }
            }

            //判断有没有标、
            if(data.pageCount == 0)
            {
                //不显示更多按钮
                $scope.loaning_more = 0;
                //没有标 引导用户投标  显示
                $scope.loaning_tou = 1;
            }

            //说明这是最后一页
            if(data.pageCount !=0 && data.pageCount == data.pageIndex)
            {
                $scope.loaning_more = 0;
            }

            $scope.loaning_datalist = $scope.loaning_datalist.concat(data.tenderList);
            $scope.loaning_type = data.tenderType;
            data.pageIndex = parseInt(data.pageIndex);
            data.pageSize = parseInt(data.pageSize);
            $scope.loanNoPageI = data.pageIndex+1;
            if($scope.loanNoPageI>data.pageCount)
                $scope.loanNoPageI = data.pageCount;
            $scope.loanNoPageS = data.pageSize;
        }, function (data) {
        });
    }


    $scope.end_PageI = 1; //默认页码
    $scope.end_PageS = 10; //默认个一页显示多少
    $scope.end_datalist = [];
    //获取已还清的数据
    $scope.GetRepaymentend = function()
    {
        pageIndex = $scope.end_PageI;
        pageSize = $scope.end_PageS; //设定默认值
        $scope.end_more = 1; //默认显示 更多
        $scope.end_tou = 0; //默认不显示 引导图标
        MyinvestService.getInvestsList({type:'roamYes',pageIndex:pageIndex,pageSize:pageSize},function (data) {
            for (var i = 0; i < data.tenderList.length; i++) {
                data.tenderList[i].typeNidZi = biao_typenid[data.tenderList[i].type_nid];
                data.tenderList[i].typeNidCss = biao_typenid_class[data.tenderList[i].type_nid];
                //默认新项目
                if(data.tenderList[i].typeNidZi == 'undefined' || typeof(data.tenderList[i].typeNidZi) == 'undefined') {
                    data.tenderList[i].typeNidZi = biao_typenid['newpro'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['newpro'];
                }
                //新手标
                if( parseInt(data.tenderList[i].is_new) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['isnew'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['isnew'];
                }
                //限量标
                if( parseInt(data.tenderList[i].is_limit) == 1)
                {
                    data.tenderList[i].typeNidZi = biao_typenid['islimit'];
                    data.tenderList[i].typeNidCss = biao_typenid_class['islimit'];
                }
            }

            //判断有没有标、
            if(data.pageCount == 0)
            {
                //不显示更多按钮
                $scope.end_more = 0;
                //没有标 引导用户投标  显示
                $scope.end_tou = 1;
            }

            //说明这是最后一页
            if(data.pageCount !=0 && data.pageCount == data.pageIndex)
            {
                $scope.end_more = 0;
            }

            $scope.end_datalist = $scope.end_datalist.concat(data.tenderList);
            $scope.end_type = data.tenderType;
            data.pageIndex = parseInt(data.pageIndex);
            data.pageSize = parseInt(data.pageSize);
            $scope.end_PageI = data.pageIndex+1;
            if($scope.end_PageI>data.pageCount)
                $scope.end_PageI = data.pageCount;
            $scope.end_PageS = data.pageSize;
        }, function (data) {
        });
    }



    $scope.getMyInvestDetail = function(Type,borrowId,tenderId)
    {
        WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_Type',Type);
        WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_borrowId',borrowId);
        WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_tenderId',tenderId);
        $timeout(function () {
            $location.path(WebApp.Router.MY_INVEST_INFO);
        }, 0);
    }

});


WebApp.Instance.controller('MyinvestinfoController',function($scope,$modal,md5,$log,AccountService,MyinvestService,notify, $http, $timeout, $location, $cookies, $interval, $rootScope) {

    var MyinvestType = WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_Type');
    var MyinvestBorrowId = WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_borrowId');
    var MyinvestTenderId = WebApp.tmpValue.setOrGetStoreVal('My_Invest_Detail_tenderId');
    var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷','isnew':'新手标','islimit':'限量标','newpro':'新项目'};
    //当前标的type 用于引入那个模板
    $scope.MyinvestsType = MyinvestType;


    var UserInfo = WebApp.ClientStorage.getCurrentUser();
    if(!UserInfo)
    {
        AccountService.myAccountINfo(function (data) {
            UserInfo = data;
        }, function (data) {
            notify.closeAll();
            $cookies.put('login_url', WebApp.Router.MY_INVEST);
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return ;
        });
    }


    MyinvestService.getInvestInfo({type:MyinvestType,borrowId:MyinvestBorrowId,tenderId:MyinvestTenderId},function(data){
        data.typeNidZi = biao_typenid[data.type_nid];
        //默认新项目
        if(data.typeNidZi == 'undefined' || typeof(data.typeNidZi) == 'undefined') {
            data.typeNidZi = biao_typenid['newpro'];
        }
        //新手标
        if( parseInt(data.is_new) == 1)
        {
            data.typeNidZi = biao_typenid['isnew'];
        }
        //限量标
        if( parseInt(data.is_limit) == 1)
        {
            data.typeNidZi = biao_typenid['islimit'];
        }
        $scope.investData = data;
    },function(data){

    });


    //标的详情页 （继续投资）
    $scope.Detail_invest = function(borrowId)
    {
        WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
        $timeout(function () {
            $location.path(WebApp.Router.INVEST_DETAIL);
        }, 0);
    }



});


WebApp.Instance.controller('MyinvesToolsController',function($scope,$modal,md5,$log,notify, $http, $timeout, $location, $cookies, $interval, $rootScope) {

    $scope.isDownShow = 1;

    var isDownshowDate = $cookies.get("isDownshowDate");
    //如过有cookie 就隐藏
    var getday = (new Date()).getDate();
    if(isDownshowDate && getday == isDownshowDate)
    {
        $scope.isDownShow = 0;
    }

    $scope.close_down = function()
    {
        $scope.isDownShow = 0;
        $cookies.put("isDownshowDate",(new Date()).getDate());
    }



    //跳转到我的投资页
    $scope.goMyinvest = function()
    {
        $timeout(function () {
            $location.path(WebApp.Router.MY_INVEST);
        }, 0);
    }

    //跳转到我的优惠券页
    $scope.goMycoupon = function(){
        $timeout(function () {
            $location.path(WebApp.Router.MY_COUPON);
        }, 0);
    }

});