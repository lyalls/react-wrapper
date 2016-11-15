//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('PaymentService', function ($http, $location, $timeout) {

    return {
        getRechargeInfo: function (success, error) {
            $http.get(' /payment/lianlianpay/page', {
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
        createOrder: function (data, success, error) {
            $http.post('/payment/lianlianpay/order', {
                accountNumber: data.accountNumber,
                noAgree: data.noAgree,
                rechargeMoney: data.rechargeMoney
            }, {
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
        ckeckAccountNumber: function (data, success, error) {
            var url = '/payment/lianlianpay/cardbin';
            var data = {
                accountNumber: data.accountNumber,
            };
            var options = {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            };
            $http.post(url, data, options).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        }
    };

});