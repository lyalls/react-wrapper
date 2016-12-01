WebApp.Instance.factory('AboutusService', function ($http, $location, $log, $timeout) {
    return {
         getData: function (success, error) {
            $http.get('/system/about/data', {
                params: {},
                headers: {}
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        }
    }

})
