
//
// For this trivial demo we have just a unique MainController 
// for everything
//
WebApp.Instance.controller('MainController', function ($rootScope, $scope, $location, $timeout) {

    // User agent displayed in home page
    $scope.userAgent = navigator.userAgent;

    // Needed for the loading screen
    $rootScope.$on('$routeChangeStart', function () {
        $rootScope.loading = true;
    });

    $rootScope.$on('$routeChangeSuccess', function () {
        $rootScope.loading = false;
    });

    $scope.bottomReached = function () {
        console.log('Congrats you scrolled to the end of the list!');
    };

    // 
    // Right Sidebar
    // 
    $scope.chatUsers = [
        {name: 'Carlos  Flowers', online: true},
        {name: 'Byron Taylor', online: false}
    ];

    // 
    // 'Drag' screen
    // 
    $scope.notices = [];

    for (var j = 0; j < 10; j++) {
        $scope.notices.push({icon: 'envelope', message: 'Notice ' + (j + 1)});
    }

    $scope.deleteNotice = function (notice) {
        var index = $scope.notices.indexOf(notice);
        if (index > -1) {
            $scope.notices.splice(index, 1);
        }
    };

    //
    //
    //  Index Controller
    //
    //
    //跳转公共方法
    $scope.bcAllUrl = {
        userSet: WebApp.Router.USER_SET,
        userAsset: WebApp.Router.USER_ASSET,
        cMoney: WebApp.Router.COLLECTION_MONEY,
        smartBid: WebApp.Router.SMART_BID,
        idCard: WebApp.Router.POPUP_ID_CARD,
        changeLoginPas: WebApp.Router.CHANGE_LOGIN_PASSWORD,
        changeDealPas: WebApp.Router.CHANGE_DEAL_PASSWORD,
        setPas: WebApp.Router.SET_PAY_PASSWORD,
        findPayPas: WebApp.Router.FIND_DEAL_PASSWORD2,
        privilege: WebApp.Router.PRIVILEGE,
        experience: WebApp.Router.EXPERIENCE,
        specialRight: WebApp.Router.SPECIAL_RIGHTS,
        caseDough: WebApp.Router.CASE_DOUGH,
        caseDoughRules: WebApp.Router.CASE_DOUGH_RULES,
        listOfExperience: WebApp.Router.EXPERIENCE_LIST,
        caseDoughInvest: WebApp.Router.CASE_DOUGH_INVESTS,
        userRedPackets: WebApp.Router.USER_RED_PACKETS,
        userRedPacketsdetails: WebApp.Router.USER_RED_PACKETS_DETAILS,
        userPayments: WebApp.Router.USER_PAYMENT,
        moreBonuse: WebApp.Router.MORE_BONUSE,
        home:WebApp.Router.HOME,
        tradeRecord: WebApp.Router.TRADE_RECORD,
        TRAN_RECORD: WebApp.Router.TRANRECORD,
       	increaseList: WebApp.Router.INCREASE_LIST,
       	investList: WebApp.Router.INVEST_LIST,
       	increaseRules: WebApp.Router.INCREASE_RULES,
       	usersAccount: WebApp.Router.USERS_ACCOUNT,
       	projectIntro: WebApp.Router.PROJECT_INTRO,
       	projectBorrower: WebApp.Router.PROJECT_BORROWER,
       	projectRecords: WebApp.Router.PROJECT_RECORDS,
       	realNameAuth:WebApp.Router.VALIDATE_ID_CARD,
       	CONPUS_RULE:WebApp.Router.CONPUS_RULE,
       	INVITE:WebApp.Router.INVITE,
       	INVEST:WebApp.Router.INVEST,
       	INVEST_COUPONS:WebApp.Router.INVEST_COUPONS,
       	MY_COUPON:WebApp.Router.MY_COUPON,
        MY_INVEST:WebApp.Router.MY_INVEST,
    };

    $scope.bcChangeUrl = function (path) {
        $timeout(function () {
            $location.path(path);
        }, 0);
    };

    $scope.isHaveHistory = function () {
        return $location.path() === WebApp.Router.HOME;
    };

    $scope.isHaveCall = function () {
        if ($location.path() === WebApp.Router.HOME || $location.path() === WebApp.Router.MONTH_GET) {
            return true;
        }
    };
    $scope.goUsers = function () {
        $timeout(function () {
            $location.path(WebApp.Router.USERS_ACCOUNT);
        }, 0);
    };
    $scope.phone = function () {
        //window.location.href = 'tel:400-616-7070';
    }

    $scope.goHistory = function () {
    	
        if ($location.path() == WebApp.Router.LOGIN ||
                $location.path() == WebApp.Router.VALIDATE_ID_CARD ||
                $location.path() == WebApp.Router.REGISTER_SUCCESS ||
                $location.path() == WebApp.Router.USERS_ACCOUNT ||
                $location.path() == WebApp.Router.INVEST_PERSON_LIST ||
                $location.path() == WebApp.Router.EXPERIENCE ||                
                $location.path() == WebApp.Router.INVEST_SUCCESS ||
                $location.path() == WebApp.Router.INVEST_DETAIL
                ) {
            $timeout(function () {
                $location.path(WebApp.Router.HOME);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.CASE_DOUGH_INVESTS) {
            $timeout(function () {
                $location.path(WebApp.Router.EXPERIENCE);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.USER_RED_PACKETS ||
                $location.path() == WebApp.Router.CASE_DOUGH ||
                $location.path() == WebApp.Router.SPECIAL_RIGHTS) {
            $timeout(function () {
                $location.path(WebApp.Router.USERS_ACCOUNT);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.USER_RED_PACKETS_DETAILS ||
                $location.path() == WebApp.Router.USER_PAYMENT||
                $location.path() == WebApp.Router.MORE_BONUSE) {
            $timeout(function () {
                $location.path(WebApp.Router.USER_RED_PACKETS);
            }, 0);
            return;
        }

        if ($location.path() == WebApp.Router.USER_ASSET || $location.path() == WebApp.Router.USER_SET) {
            $timeout(function () {
                $location.path(WebApp.Router.USERS_ACCOUNT);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.USER_PRESENT) {
            $timeout(function () {
                $location.path(WebApp.Router.USERS_ACCOUNT);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.PROJECT_INTRO) {
        	$timeout(function () {
                $location.path(WebApp.Router.INVEST_DETAIL);
            }, 0);
            return;
        }
        if ($location.path() == WebApp.Router.INVEST) {
        	$timeout(function () {
                $location.path(WebApp.Router.INVEST_DETAIL);
            }, 0);
            return;
        }
        $timeout(function () {
            $location.path(history.go(-1));
        }, 0);

    };

    $scope.isWeChatiOS = function () {
        return WebApp.Terminal.platform.iPhone && WebApp.Terminal.platform.weChat;
    };

    //马上投资按钮
    $scope.bottomIsInvestViews = function () {
        return ($location.path() === WebApp.Router.INVEST_DETAIL || $location.path() === WebApp.Router.INVEST_PERSON_LIST) && WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') !== 100;
    };

    //还款中按钮
    $scope.bottomIsPayViews = function () {
        return ($location.path() === WebApp.Router.INVEST_DETAIL || $location.path() === WebApp.Router.INVEST_PERSON_LIST) && WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') === 100;
    };



    //如果是首页，隐藏老的头部
    $scope.newHomeHide = function ()
    {
        return $location.path()===WebApp.Router.HOME;
        /*if($location.path()===WebApp.Router.HOME)
        {
            $scope.homesty = {"padding-top":"0px"};
            $scope.homeover = {"overflow": "auto"};
            return true;
        }
        return false;*/

    };

});