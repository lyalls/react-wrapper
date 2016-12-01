/**
 * Created by lipeng on 16-11-9.
 */
WebApp.Instance.factory('MyinvestService', function ($http, $log, $location, $timeout) {
    return {

        //获取可投资的项目
        getInvestsList: function (data,success, error) {
            $http.get('/users/my/invest', {
                params: {
                    type:data.type,
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

        //获取可投资的项目
        getInvestInfo: function (data,success, error) {
            $http.get('/users/my/invest/info', {
                params: {
                    type:data.type,
                    borrowId:data.borrowId,
                    tenderId:data.tenderId
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