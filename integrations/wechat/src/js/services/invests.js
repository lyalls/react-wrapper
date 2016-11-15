//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('InvestsService', function ($http, $log, $location, $timeout) {
		
    return {
        //获取月、季、年计划的总投资人数
        getTenderPeopleNum: function (data, success, error) {
            $http.post('/invests/plans/people', {
                plans: data.plans
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getInvestsList: function (data, success, error) {
            $http.get('/invests/general', {
                params: {
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex,
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
        getH5InvestsList: function (data, success, error) {
            $http.get('/invests/h5/general', {
                params: {
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex,
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
        //利息奖励计算
        getBounsInfo:function(data,success,error)
        {
            $http.post('/tools/interests/h5/' + data.borrowId, {
                borrowAmount: data.borrowAmount,
                bonusTicketId: data.bonusTicketId,
                increaseTicketId: data.increaseTicketId,
                tenderUseTicketStyle:data.tenderUseTicketStyle// auto  自动, hand shoudong 
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
        //获取用户优惠券信息
        getUserCoupons:function(success,error)
        {
            var data = {};
            var i =0;
            $http.get('/users/increase/ticket/list', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                data.increaseList = response.data.list;
                i++;
                if(i==2)
                {
                    success(data);
                }
            }).error(function (response, status, headers, config) {
                error(response);
            });
            $http.get('/users/bonus/ticket/list', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                data.bounsList = response.data.list;
                i++;
                if(i==2)
                {
                    success(data);
                }
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getInvestInfo: function (borrowId, success, error) {
            $http.get('/invests/general/' + borrowId).success(function (response, status, headers, config) {
                success(response.data);
                //$log.log(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getProductInfo: function (borrowId, success, error) {
            $http.get('/invests/borrowinfo/' + borrowId).success(function (response, status, headers, config) {
                success(response.data);
                //$log.log(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getBorrowerInfo: function (borrowId, success, error) {
            $http.get('/invests/general/' + borrowId + '/borrower', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getProductRisk: function (borrowId, success, error) {
            $http.get('/invests/general/' + borrowId + "/risks", {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getPaymentMethod: function (borrowId, success, error) {
            $http.get('/invests/general/' + borrowId + "/method", {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getInvestRecord: function (data, success, error) {
            $http.get('/invests/general/' + data.borrowId + "/records?pageSize=" + data.pageSize + "&pageIndex=" + data.pageIndex,
                    {
                        headers: {
                            'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                        }
                    }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);

                error(response, status, headers, config);
            });
        },
        getTenderInfo: function (borrowId, success, error) {
            $http.get('/invests/general/' + borrowId + "/tender", {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
                //$log.log(response);
            });
        },
        tender: function (data, success, error) {
            $http.post('/invests/general/' + data.borrowId + '/tender', {
                borrowId: data.borrowId,
                bidAmount: data.bidAmount,
                bonusTicketId:data.bonusTicketId,
                increaseTicketId:data.increaseTicketId,
                payPassword: data.payPassword,
                tenderStatus:0,
                activeZXCode:data.activeZXCode,
                tenderUseTicketStyle:"hand"
            }, {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response);
            }).error(function (response, status, headers, config) {
                //WebApp.UI.alert(response, $location, $timeout);
                error(response);
            });
        },
        tender_enough: function (data, success, error) {
            $log.log(data);
            $http.post('/invests/general/' + data.borrowId + '/tender', {
                borrowId: data.borrowId,
                bidAmount: data.bidAmount,
                payPassword: data.payPassword,
                activeCode: data.activeCode,
                tenderStatus:1
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
        getProtocol: function (success, error) {
            $http.get('/invests/protocol', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);
                error(response, status, headers, config);
            });
        },
        preCheck: function (success, error) {
            // Check Token in controller
            $http.get('/invests/precheck', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);
                //error(response, status, headers, config);
            });
        },
        getLoginINfo: function (success, error) {
            // Check Token in controller
            $http.get('/users/realinfo', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);
                //error(response, status, headers, config);
            });
        },        
        getIfHasTender: function (success, error) {      
            $http.get('/invests/borrow/notice')
            .success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                WebApp.UI.alert(response, $location, $timeout);                
            });
        },
        checkActiveCode:function (data, success, error) {
            $http.post('/invests/general/tender/activity/'+ data.borrowNid+'/code', {
                activezxcode: data.activezxcode                
            }).success(function (response, status, headers, config) {
                success(response);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },

    };
});

