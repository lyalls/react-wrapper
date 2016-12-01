// 邀请好友service

WebApp.Instance.factory('InviteService', function ($http, $log, $location, $timeout) {
        return {
        //用户邀请页面需求信息
        inviteInfo: function (success, error) {
            $http.get('activity/invite/info', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        // /users/invite/log
        inviteList:function(success, error){
            $http.get('/users/invite/log', {
                headers:{
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config){
                success(response.data);
            }).error(function (response, status, headers, config){
                error(response);
            });
        }
        
    };
    
});
