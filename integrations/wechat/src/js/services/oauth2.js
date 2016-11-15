//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('Oauth2Service', function ($http, $location, $timeout) {

    return {
        doAuth: function (success, error) {
            $http.get('/oauth2/auth', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        }
    };

});

