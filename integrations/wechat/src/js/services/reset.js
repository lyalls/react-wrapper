//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('ResetService', function ($http, $location, $timeout) {

    return {
        getResetPhoneCode: function (data, success, error) {
            $http.post('/auth/reset/phone/code', {
                phone: data.phone
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        validatePhoneCode: function (data, success, error) {
            $http.post('/auth/reset/phone', {
                phone: data.phone,
                code: data.code
            }
            ).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                error(response);
            });
        },
        resetPassword: function (data, success, error) {
            $http.post('/auth/reset/password', {
                phone: data.phone,
                password: data.password,
                vcode: data.vcode
            }
            ).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                error(response);
            });
        }
    };

});

