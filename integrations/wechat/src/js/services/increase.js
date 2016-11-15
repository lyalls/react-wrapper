WebApp.Instance.factory('IncreaseService', function ($http, $log, $location, $timeout) {

    return {
        getIncreaseList: function (page, success, error) {
            $http.get('/users/increase/ticket', {
                headers: {
                  'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                },
                params: {
                	pageIndex: page
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        }
    };

});

