//
// zhaoqiying
// for everything
//
WebApp.Instance.controller('Oauth2Controller', function ($scope, $location, md5, notify, $timeout, $routeParams, $interval, $cookies, Oauth2Service) {
    $scope.login = function () {
        Oauth2Service.doAuth(function (data) {
            notify.closeAll();
            //保存登录用户信息
            WebApp.ClientStorage.setCurrentToken(data.token);
            WebApp.ClientStorage.setCurrentUser(data);
            WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', data);
            $timeout(function () {
                if ($location.search().redirect_uri)
                {
                    location.href = ($location.search().redirect_uri);
                } else
                {
                    $location.path(WebApp.Router.HOME);
                }
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

});


