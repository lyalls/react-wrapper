//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('LoginService', function ($http, $location, $timeout) {

    return {
        doLogin: function (data, success, error) {
            $http.post('/auth/login', {
                password: data.password,
                keywords: data.keywords
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        doLogout: function (data, success, error) {
            $http.post('/auth/logout', {
                token: WebApp.ClientStorage.getCurrentToken()
            }, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getPhonecode: function(data, success, error){
             $http.post('/auth/approve/phone/code', {
                phone: data.phone
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        phoneApprove: function(data, success, error){
            $http.post('/auth/approve/phone', {
                phone: data.phone,
                code:data.code
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        }
    };

});

