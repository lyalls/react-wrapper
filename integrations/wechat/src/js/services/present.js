/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

WebApp.Instance.factory('PresentService', function ($http, $location, $timeout, $log) {
    return {
        checkBankCard: function (success, error) {
            $http.get('/users/precheck', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        getPresentInfo: function (success, error) {
            $http.get('/users/present', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        getBankInfo: function (success, error) {
            $http.get('/users/present/bank', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        presentPhoneCode: function (phone, success, error) {
            $http.get('/users/present/code', {
                params: {
                    phone: phone
                },
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                success(response.data);
            });
        },
        checkPayPassword: function (password, success, error) {
            $http.post('/users/present/pay', {
                paypassword: password,
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
        doPresentCreate: function (items, success, error) {
            $http.post('/users/present/order', {
                paypassword: items.paypassword,
                cashMoney: items.cashMoney,
                cashCode: items.cashCode,
            }, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });

        },
        getBankBasicInfo: function (success, error) {
            $http.get('/users/present/info', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        getAreaSubject: function (pid, success, error) {
            $http.get('/users/present/area', {
                params: {
                    pid: pid
                },
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        addUserBank: function (params, success, error) {
            $http.post('/users/present/add', params, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response.data);
            });
        },
        getAccountBankInfo: function (success, error) {
            $http.get('/users/present/account', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response.data);
            });
        },
        updateAccountBankInfo: function (params, success, error) {
            $http.post('/users/present/update', params, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                success(response.data);
            });
        },
        checkPhone: function (params, success, error) {
            $http.post('/validator/phone', params, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success({success: response.data.success, message: '手机号正确'});
            }).error(function (response, status, headers, config) {
                success({success: false, message: response.message});
            });
        },
        checkCodeOfPhone: function (data, success, error) {
            $http.get('/users/present/code/check', {
                params: {
                    phone: data.phone,
                    code: data.code
                },
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response.data);
            });
        },
    };





});
