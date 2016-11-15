//
// For this trivial demo we have just a unique Controller 
// for everything
//

WebApp.Instance.controller('BonusController', function ($scope, $location, md5, LoginService, $timeout) {
    $scope.alerts = [
        {type: 'danger', msg: '抱财网，红包提醒！！！'},
    ];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };
});
