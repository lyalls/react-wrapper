var app = WebApp.Instance;

app.controller('PopupController', function ($rootScope, $scope, $window, $modal, ngDialog, $interval, $location, md5, InvestsService, $timeout) {

    //最下面导航    
    $scope.clickToOpen = function () {
        if (WebApp.ClientStorage.getCurrentToken() === null) {
            if (($location.path() != WebApp.Router.HOME) &&
                    ($location.path() != WebApp.Router.INVEST_DETAIL) &&
                    ($location.path() != WebApp.Router.INVEST_PERSON_LIST)) {

                ngDialog.open({
                    template: 'popup_empty_nav.html'
                });
            } else {
                if ($location.path() == WebApp.Router.HOME) {
                    ngDialog.open({
                        template: 'popup.html'
                    });
                } else {
                    if (WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                            WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') != "100.00%") {
                        ngDialog.open({
                            template: 'popup_invest.html'
                        });
                    } else if (WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                            WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') == "100.00%") {
                        ngDialog.open({
                            template: 'popup_invest_full.html'
                        });
                    }
                }
            }
        } else {
            if ($location.path() == WebApp.Router.HOME ||
                    $location.path() == WebApp.Router.USER) {

                ngDialog.open({
                    template: 'popup_my_baocai.html'
                });
            } else if ($location.path() == WebApp.Router.INVEST_DETAIL ||
                    $location.path() == WebApp.Router.INVEST_PERSON_LIST) {
                if (WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                        WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') != "100.00%") {
                    ngDialog.open({
                        template: 'popup_invest.html'
                    });
                } else if (WebApp.tmpValue.setOrGetStoreVal('Detail_id', '') &&
                        WebApp.tmpValue.setOrGetStoreVal('Detail_tenderSchedule', '') == "100.00%") {
                    ngDialog.open({
                        template: 'popup_invest_full.html'
                    });
                }


            } else {
                ngDialog.open({
                    template: 'popup_empty_nav.html'
                });
            }
        }
    };
});
