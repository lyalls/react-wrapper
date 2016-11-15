WebApp.Instance.factory('CaseDoughService', function ($http, $log, $location, $timeout) {

    return {
        //获取用户总私房钱
        getMoneyTotal: function (success, error) {
            $http.get('/experience/account/total', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取用户私房钱数据信息
        getMoneyLog: function (success, error) {
            $http.get('/experience/account/log', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getWaitAccountList: function (success, error) {
            $http.get('/experience/account/wait', {
                params: {
                    pageSize:"500",
                    pageIndex: "1",
                },
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getTenderPeopleNum: function (success, error) {
            $http.get('/experience/tender/people', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getExperienceBorrow: function (success, error) {
            $http.get('/experience/borrow', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getInvestRecord: function (data, success, error) {
            $log.log(data);
            $http.get('/experience/general/' + data.borrowId + '/records', {
                params: {
                    borrowId: data.borrowId,
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex,
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
        getTenderInfo: function (data, success, error) {
            $http.get('/experience/general/' + data.borrowId + '/tender', {
                borrowId: data.borrowId,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getTenderMoneyList: function (success, error) {
            $http.get('/experience/general/account/list', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        doTender: function (data, success, error) {
            $http.post('/experience/general/' + data.borrowId + '/tender', {
                borrowId: data.borrowId,
                accountId: data.accountId,
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

