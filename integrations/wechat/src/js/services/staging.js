//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('StagingService', function ($http, $location, $timeout) {

    return {
        //首页分期计划数据
        getFinaningData: function (success, error) {
            $http.get('/invests/plans').success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);
                // error(response);
            });
        },
        //获取自动投标状态
        getAutoTenderStatus: function (success, error) {
            $http.get('/users/auto/status', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },
        //自动投标设置
        setAutoTender: function (data, success, error) {
            $http.post('/users/auto', {
                status: data.status,
                paypassword: data.paypassword,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },

        getBannerData: function (success, error) {
            $http.get('/top/wechat/banners')
            .success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getNologinBannerData: function (success, error) {
            //未登陆获取的 banner
            $http.get('/top/wechat/nologin/banners')
                .success(function (response, status, config) {
                    success(response.data);
                }).error(function (response, status, headers, config) {
                error(response);
            });
        }

    };

});

