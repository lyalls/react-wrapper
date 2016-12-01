WebApp.Instance.factory('DiscoverService', function ($http, $location, $log, $timeout) {

    return {
        //发现页
        getList: function (data, success, error) {
            $http.get('activity/discover/index', {
                params: {
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex
                },
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
    };
});


