//
// For this trivial demo we have just a unique Controller 
// for everything
//
WebApp.Instance.controller('AboutusController', function ($rootScope, $scope, $location, md5, $log, AboutusService, InvestsService, notify, $interval, $timeout) {
    $scope.aboutData=[];

    $scope.getAboutData = function () {
        AboutusService.getData(function (data) {
            $scope.aboutData=data;
        }, function (data) {
        });
    };
    
});
