//
// For this trivial demo we have just a unique service 
// for everything
//

WebApp.Instance.factory('AccountService', function ($http, $location, $log, $timeout) {

    return {
//用户交易记录
        accountLogs: function (data, success, error) {
            $http.get('/users/account/logs', {
                params: {
                    type: data.type,
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex},
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //我的抱财
        myAccountINfo: function (success, error) {
            $http.get('/users', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //用户账户信息
        userAccountInfo: function (success, error) {
            $http.get('/users/v1/info', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取邀请码
        getAccountAsset: function (success, error) {
            $http.get('/users/account/asset', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取邀请码
        getInvitationCode: function (success, error) {
            $http.get('/users/code', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取用户总加息
        getIncreaseTotal: function (success, error) {
            $http.get('/users/increase', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取用户加息数据信息
        getIncreaseLog: function (success, error) {
            $http.get('/users/increase/log', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //账户页
        getAccount: function (success, error) {
            $http.get('/users/account', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //个人设置
        getUsersSettingInfo: function (success, error) {
            $http.get('/users/setting', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getMyAccountInfo: function (success, error) {
            $http.get('/users', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        getRepaymentInfo: function (data, success, error) {
            $http.post('/users/repayment/' + data.type, {
                type: data.type,
                fromDate: data.fromDate,
                endDate: data.endDate,
                repaymentType: data.repaymentType,
                receivableState: data.receivableState,
                order: data.order,
                plans: data.plans,
                pageSize: data.pageSize,
                pageIndex: data.pageIndex,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //被getNewBonus替代
        getBonus: function (success, error) {
            $http.get('/users/bonus', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {

                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取红包金额
        getBonusTotal: function (success, error) {
            $http.get('/users/bonus/total', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {

                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取红包列表（新）
        getNewBonus: function (data, success, error) {
            $http.get('/users/bonus/list', {
                params: {
                    pageSize: data.pageSize,
                    pageIndex: data.pageIndex
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
        getUnusedBonusTicketListTotal: function (success, error) {
            $http.get('/users/bonus/ticket/total', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {

                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //红包券规则
        getUnusedBonusTicketListRules: function (success, error) {
            $http.get('/bonusticket/rules', {
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {

                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //未使用红包券列表
        getUnusedBonusTicketList: function (data, success, error) {
            $http.get('/users/bonus/ticket', {
                params: {
                    pageIndex: data.pageIndex,
                    pageSize: data.pageSize
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
        //红包券兑换
        exchangeBonusTicket: function (data, success, error) {
            $http.post('/users/bonus/ticket/exchange', {
                exchangeCode: data.exchangeCode,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {

                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //红包券详情
        getBonusTicketDetail: function (data, success, error) {
            $http.get('/users/bonus/ticket/detail', {
                params: {
                    bonusTicketID: data.bonusTicketID
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
        //验证登陆密码
        checkLoginPwd: function (data, success, error) {
            $http.post('/validator/password/', {
                password: data.password,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //修改登陆密码
        modifyPassword: function (data, success, error) {
            $http.post('/users/password/modify', {
                password: data.password,
                newPwd: data.newPwd,
                repeatPwd: data.repeatPwd,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //修改交易密码
        modifyPaypassword: function (data, success, error) {
            $http.post('/users/paypassword/modify', {
                paypassword: data.paypassword,
                newPaypwd: data.newPaypwd,
                repeatPaypwd: data.repeatPaypwd,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //设置交易密码
        setPayPassword: function (data, success, error) {
            $http.post('/invests/paypassword', {
                password: data.password,
                payPassword: data.payPassword
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
        //检测用户身份证是否正确
        checkIDcard: function (data, success, error) {
            $http.post('/users/reset/card', {
                cardID: data.cardID,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //获取手机验证码
        getPhoneCode: function (data, success, error) {
            var type = null;
            if (data.type) {
                type = data.type;
            }
            $http.post('/users/reset/phone/code', {
                phone: data.phone,
                type: type,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //手机号修改密码验证
        phoneValidate: function (data, success, error) {
            $http.post('/users/reset/phone', {
                phone: data.phone,
                code: data.code,
                type: data.type,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //重新设置交易密码
        resetPaypwd: function (data, success, error) {
            $http.post('/users/reset/paypassword', {
                phone: data.phone,
                paypassword: data.paypassword,
                vcode: data.vcode,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        //验证交易密码
        checkPaypwd: function (data, success, error) {
            $http.post('/validator/paypassword/', {
                paypassword: data.paypassword,
                headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
            }).success(function (response, status, headers, config) {
                success(response);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        },
        checkPhone: function (data, success, error) {
            $http.post('/validator/phone/', {
                phone: data.phone
            }).success(function (response, status, headers, config) {
                success(response.data);
            }).error(function (response, status, headers, config) {
                error(response);
            });
        }

    };
});