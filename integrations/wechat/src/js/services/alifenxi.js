//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('AlifenxiService', function ($http, $location, $log, $timeout) {

    return {
        getConfig: function (success, error) {
            $http.get('/ali/config', {
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });

        },
       
    };

});