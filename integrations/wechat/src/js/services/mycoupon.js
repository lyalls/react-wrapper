/**
 * Created by lipeng on 16-11-16.
 */
/**
 * Created by lipeng on 16-11-9.
 */
WebApp.Instance.factory('MycouponService', function ($http, $log, $location, $timeout) {
    return {

        //获取用户可用红包券
        getBonusList: function (data,success, error) {
            $http.get('/users/my/bonus', {
                params: {
                    pageIndex:data.pageIndex,
                    pageSize:data.pageSize
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

        //获取可用加息券
        getIncreaseList: function (data,success, error) {
            $http.get('/users/my/increase', {
                params: {
                    pageIndex:data.pageIndex,
                    pageSize:data.pageSize
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