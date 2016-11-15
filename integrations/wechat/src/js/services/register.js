//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('RegisterService', function ($http, $location, $timeout, $log) {


    return {
        checkInvitationCOde: function (data, success, error) {
            //$log.log(data);
            $http.post('/validator/invitationcode', {
                invitationCode: data.invitationCode
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },
        //
        checkPhone: function (data, success, error) {
            $http.post('/validator/phone/', {
                phone: data.phone
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },
        checkUsername: function (data, success, error) {
            $http.post('/validator/username/', {
                userName: data.userName
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },
        doRegisterPhoneCode: function (data, success, error) {

            $http.post('/auth/register/phone/code', {
                phone: data.phone
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                error(response);
            });

        },
        doCheckValidCode:function(data,success,error)
        {
            $http.post('/validator/captcha/check',data).success(function(response)
            {
                success(response);

            }).error(function(response, status, config)
            {
                WebApp.UI.alert(response, $location, $timeout);;
            });
        },
        doRegisterProtocol: function (success, error) {
            $http.get('/auth/register/protocol').success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);
            });
        },
        doRegisterPhone: function (data, success, error) {
            $http.post('/auth/register/phone', {
                phone: data.phone,
                code: data.code
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                //WebApp.UI.alert(response,$location, $timeout);
                error(response);
            });
        },
        doRegister: function (data, success, error) {
            $http.post('/auth/register/user', {
                userName: data.userName,
                password: data.password,
                invitationCode: data.invitationCode,
                vcode: data.vcode
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                //WebApp.UI.alert(response,$location, $timeout);
                error(response);
            });
        },
        registerRealname: function (data, success, error) {
            ;
            $http.post('/auth/register/id', {
                realName: data.realName,
                IDCard: data.IDCard
            }, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }
            ).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, config) {
                //WebApp.UI.alert(response,$location, $timeout);
                error(response);
            });
        },
        registerSuccessMoney: function(success, error) {
        	
        }
    };

});

