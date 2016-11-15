/**
 * Created by lipeng on 16-9-23.
 */
WebApp.Instance.factory('NowhomeService', function ($http, $log, $location, $timeout) {

    return {
        //获取可投资的项目
        getInvestsList: function (success, error) {
            $http.get('/invests/canborrowlist', {
                params: {
                    from:4
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
        //获取可投资的项目
        getTopInverstsList: function (success, error) {
            $http.get('/top/wechat/borrows', {
                params: {
                    from:4
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