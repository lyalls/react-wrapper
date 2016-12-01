//
// For this trivial demo we have just a unique Controller 
// for everything
//
WebApp.Instance.controller('AccountController', function ($rootScope, $scope, $location, md5, $log, AccountService, RegisterService, InvestsService, notify, $interval, $timeout) {
    notify.closeAll();
    $scope.bcUser = "";
    $scope.nowUser = WebApp.ClientStorage.getCurrentUser();
    $scope.getAccount = function () {
        AccountService.getAccount(function (data) {
            $scope.account = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.myAccountINfo = function () {
        AccountService.myAccountINfo(function (data) {
            $scope.myAccountINfo = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.userAccountInfo = function () {
        AccountService.userAccountInfo(function (data) {
            $scope.userAccountInfo = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //交易记录
    $scope.values = [
        {"name": "我的交易记录", "type": ""},
        {"name": "充值", "type": "recharge"},
        {"name": "投资", "type": "tender"},
        {"name": "转让", "type": "borrow_change_sell"},
        {"name": "取现", "type": "cash_success"},
        {"name": "回款", "type": "tender_recover_yes"},
        {"name": "额外收益", "type": "other"}];
    $scope.currentValue = "我的交易记录";
    $scope.accountLogs = function () {
        $scope.investsRecordList = [];
        $scope.change = function () {
            $scope.investsRecordList = [];
            var type = $scope.currentValue.type;
            AccountService.accountLogs({
                type: type,
                pageSize: "10",
                pageIndex: "1"
            }, function (data) {
                for (var i = 0; i < data.list.length; i++) {
                    $scope.investsRecordList.push(data.list[i]);
                }
                $scope.accountLogs = $scope.investsRecordList;
                $scope.indexBottom = 2;
                notify.closeAll();
                if (data.list.length == 0) {
                    //notify({message: "没有更多数据！", duration: WebApp.duration});
                    $scope.notifyMessage = "获取更多数据";
                }
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        };
        $scope.sizeBottom = 10;
        $scope.indexBottom = 2;

        $scope.bottom = function () {
            var type = $scope.currentValue.type;
            AccountService.accountLogs({
                type: type,
                pageSize: $scope.sizeBottom,
                pageIndex: $scope.indexBottom
            }, function (data) {
                if (data.list.length == 0) {
                    notify.closeAll();
                    notify({message: "没有更多数据！", duration: WebApp.duration});
                    return;
                }
                for (var i = 0; i < data.list.length; i++) {
                    $scope.investsRecordList.push(data.list[i]);
                }
                $scope.accountLogs = $scope.investsRecordList;
                $scope.indexBottom++;
            });

        };
    };
    //首页特权加息
    $scope.tIsShow = false;
    $scope.getTAccount = function () {
        //if (WebApp.ClientStorage.getCurrentUser()) {


        //if (WebApp.tmpValue.setOrGetStoreVal('Detail_currentUser', '')) {
        AccountService.getAccount(function (data) {
            $scope.tValue = WebApp.Utils.toReverse(data.totalIncrease, 1);
            $scope.tIsShow = true;
        }, function (data) {
            if (data.code == 401) {
                $scope.tIsShow = false;
            }
        });
        //} else {
        //   $scope.tIsShow = false;
        // }
    };
    //获取个人资产
    $scope.getAccountAsset = function () {
        AccountService.getAccountAsset(function (data) {
            $scope.asset = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getUsersSettingInfo = function () {
        AccountService.getUsersSettingInfo(function (data) {
            var re = /^\d{3}(\d{4})/;
            $scope.accountInfo = data;
            $scope.userName = data.userName;
            $scope.userPhone = data.phone;
            if (data.phone) {
                var found = data.phone.match(re);
                $scope.phoneShow = data.phone.replace(found[1], "****");
            }
            WebApp.tmpValue.setOrGetStoreVal("value_phone", data.phone);
            $scope.idCard = data.cardStatus;
            $scope.paypwdStatus = data.paypwdStatus;
            $scope.realNameStatus = data.realNameStatus;
            $scope.realName = data.realName;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getMyAccount = function () {
        AccountService.getMyAccountInfo(function (data) {
            if (data.phone) {
                data.phone = data.phone.replace("****", "***");
                $scope.bcUser = data.phone;
            }
            if (!data.phone) {
                $scope.bcUser = data.userName;
            }
            $rootScope.usersMsg = data;
            WebApp.ClientStorage.setCurrentAccount(data.availableBalance);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
        AccountService.getBonus(function (data) {
            $rootScope.bonus = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getRepayment = function (plans) {
        AccountService.getRepaymentInfo({
            type: "time",
            fromDate: "",
            endDate: "",
            repaymentType: "",
            receivableState: "0",
            order: "recoverTime",
            plans: plans,
            pageSize: "500",
            pageIndex: "1"
        }, function (data) {
            $scope.investsPayment = data.list;
            notify.closeAll();
            if (data.list.length == 0) {
                //notify({message: "没有更多数据！", duration: WebApp.duration});
                $scope.notifyMessage = "没有更多数据！";
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.privilege = function () {

        $timeout(function () {
            $location.path(WebApp.Router.SPECIAL_RIGHTS);
        }, 0);
    };
    $scope.getMoreBonus = function () {

        $timeout(function () {
            $location.path(WebApp.Router.MORE_BONUSE);
        }, 0);
    };
    $scope.toHome = function () {

        $timeout(function () {
            $location.path(WebApp.Router.HOME);
        }, 0);
    };
    //被getNewBonus替代
    $scope.getBonus = function () {
        AccountService.getBonus(function (data) {
            $scope.bonus = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //获取红包金额
    $scope.getBonusTotal = function () {
        AccountService.getBonusTotal(function (data) {
            $scope.bonusTotal = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.bonusList = [];
    $scope.pageSize = 10;
    $scope.pageIndex = 2;
    //获取红包列表（新）
    $scope.getNewBonus = function () {
        $scope.pageSize = 10;
        $scope.pageIndex = 1;
        AccountService.getNewBonus({
            pageSize: $scope.pageSize,
            pageIndex: $scope.pageIndex
        }, function (data) {
            $scope.bonusList = [];
            for (var i = 0; i < data.list.length; i++) {
                $scope.bonusList.push(data.list[i]);
            }
            $scope.bonus = $scope.bonusList;
            $scope.pageIndex++;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getNewBonusBttom = function () {
        AccountService.getNewBonus({
            pageSize: $scope.pageSize,
            pageIndex: $scope.pageIndex
        }, function (data) {
            if (data.list.length == 0) {
                notify.closeAll();
                notify({message: "没有更多数据", duration: WebApp.duration});
                return;
            }
            for (var i = 0; i < data.list.length; i++) {
                $scope.bonusList.push(data.list[i]);
            }
            $scope.bonus = $scope.bonusList;
            $scope.pageIndex++;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getUnusedBonusTicketListTotal = function () {
        AccountService.getUnusedBonusTicketListTotal(function (data) {

            $scope.unusedBonusTicketListTotal = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getUnusedBonusTicketListRules = function () {
        AccountService.getUnusedBonusTicketListRules(function (data) {
            $scope.unusedBonusTicketListRules = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //未使用红包券列表
    $scope.bonusTicketList = [];
    $scope.size = 10;
    $scope.index = 2;
    $scope.getUnusedBonusTicketList = function () {
        $scope.size = 10;
        $scope.index = 1;
        AccountService.getUnusedBonusTicketList({pageIndex: $scope.index, pageSize: $scope.size}, function (data) {
            $scope.bonusTicketList = [];
            for (var i = 0; i < data.list.length; i++) {
                $scope.bonusTicketList.push(data.list[i]);
            }
            $scope.unusedBonusTicketList = $scope.bonusTicketList;
            $scope.index++;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.getUnusedBonusTicketListRefresh = function () {
        AccountService.getUnusedBonusTicketList({pageIndex: $scope.index, pageSize: $scope.size}, function (data) {
            if (data.list.length == 0) {
                notify.closeAll();
                notify({message: "没有更多数据!", duration: WebApp.duration});
                return;
            }
            for (var i = 0; i < data.list.length; i++) {
                $scope.bonusTicketList.push(data.list[i]);
            }
            $scope.unusedBonusTicketList = $scope.bonusTicketList;
            $scope.index++;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };


    //红包券兑换
    $scope.exchangeBonusTicket = function () {
        var exchangeCode = $scope.exchangeCode;
        AccountService.exchangeBonusTicket({exchangeCode: exchangeCode}, function (data) {
            $scope.unusedBonusTicketList = data;
            if (data.success) {
                notify.closeAll();
                notify({message: "恭喜您兑换成功!", duration: WebApp.duration});
                $scope.getUnusedBonusTicketList();
                $scope.exchangeCode = "";
            }

        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //红包券详情跳转
    $scope.goDetail = function (id) {
        WebApp.tmpValue.setOrGetStoreVal('Detail_bonusTicketId', id);
        $timeout(function () {
            $location.path(WebApp.Router.USER_RED_PACKETS_DETAILS);
        }, 0);

    };
    //红包券详情
    $scope.getBonusTicketDetail = function () {
        var id = WebApp.tmpValue.setOrGetStoreVal('Detail_bonusTicketId', '');
        AccountService.getBonusTicketDetail({bonusTicketID: id}, function (data) {
            $scope.bonusTicketDetail = data;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //获取验证码
    $scope.getInvitationCode = function () {
        AccountService.getInvitationCode(function (data) {
            if (data.invitationCode) {
                $scope.invitationCode = data.invitationCode;
            } else {
                $scope.invitationCode = "无";
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //获取用户总加息WebApp.tmpValue.setOrGetStoreVal('value_phone', data.phone);
    $scope.getIncreaseTotal = function () {
        AccountService.getIncreaseTotal(function (data) {
            data.increase = WebApp.Utils.toReverse(data.increase, 1);
            $scope.increase = data.increase;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //获取用户加息数据信息
    $scope.getIncreaseLog = function () {
        $scope.isMore = false;
        AccountService.getIncreaseLog(function (data) {
            if (data.list.length > 3) {
                $scope.isMore = true;
            }
            if (data.list.length) {
                var time = data.list[0].expiredTime;
                for (var i = 0; i < data.list.length; i++) {
                    data.list[i].apr = WebApp.Utils.toReverse(data.list[i].apr, 1);
                    if (data.list[i].status == 1) {
                        var time = data.list[i].expiredTime;
                    } else if (data.list[i].status == 2) {
                        var time = data.list[i].addTime;
                    }
                    var dateYear = new Date(parseInt(time) * 1000).getFullYear();
                    var dateMonth = new Date(parseInt(time) * 1000).getMonth() + 1;
                    var dateDate = new Date(parseInt(time) * 1000).getDate();
                    data.list[i].expiredTime = dateYear + "年" + dateMonth + "月" + dateDate + "日";
                    if (data.list[i].status == 1 || data.list[i].status == 3 || data.list[i].status == 0) {
                        if (data.list[i].status == 3) {
                            data.list[i].expiredTime = "已过期";
                        } else if (data.list[i].status == 1) {
                            data.list[i].expiredTime = "有效期至" + data.list[i].expiredTime;
                        } else if (data.list[i].status == 0) {
                            data.list[i].expiredTime = "取现清零";
                        }
                        data.list[i].apr = "+" + data.list[i].apr + "%";
                        var type = data.list[i].type;
                        if (type == 0) {
                            data.list[i].type = "被抱财金融管家";
                        } else if (type == 1) {
                            data.list[i].type = "邀请";
                        } else if (type == 2) {
                            data.list[i].type = "被";
                        } else {
                            data.list[i].type = "早期验证码";
                        }
                        if (!data.list[i].phone) {
                            if (type == 1) {
                                data.list[i].phone = data.list[i].userName + "注册";
                            } else if (type == 2) {
                                data.list[i].phone = data.list[i].userName + "邀请注册";
                            } else {
                                data.list[i].phone = "邀请注册";
                            }

                        } else {
                            if (type == 1) {
                                data.list[i].phone = data.list[i].phone + "注册";
                            } else {
                                data.list[i].phone = data.list[i].phone + "邀请注册";
                            }
                        }

                    } else if (data.list[i].status == 2) {
                        data.list[i].apr = "清零";
                        data.list[i].type = "取现";
                        data.list[i].phone = "";
                    }
                }
                $scope.increaseLogList = data.list;
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //验证手机号
    $scope.validatePhone = function (phone) {
        var mobilePhoneExp = /^(13|14|15|17|18)\d{9}$/;
        var validity = mobilePhoneExp.test(phone);
        if (!validity) {
            notify.closeAll();
            notify({message: "手机号码格式不正确", duration: WebApp.duration});
            return;
        }
        AccountService.checkPhone({phone: phone}, function (data) {
            notify.closeAll();
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //验证交易密码
    $scope.checkPaypwd = function () {
        var password = md5.createHash($scope.paypasswordBc || "");
        AccountService.checkPaypwd({paypassword: password}, function (data) {
            //notify.closeAll();
            return true;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return true;
        });
        return true;
    };
    //验证登陆密码
    $scope.checkLoginPwd = function () {
        var password = md5.createHash($scope.passwordBc || "");
        AccountService.checkLoginPwd({password: password}, function (data) {
            //notify.closeAll();
            return true;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return false;
        });
        return true;
    };
    //验证密码
    $scope.validatePassWord = function () {
        if (!$scope.newPwdBc) {
            notify.closeAll();
            notify({message: "密码不能为空", duration: WebApp.duration});
            return false;
        }
        var passwordDigitExp = /^.{6,16}$/;
        var passwordNumberExp = /^\d+$/;
        var passwordElementExp = /^[a-zA-Z]+$/;
        var digit_validity = passwordDigitExp.test($scope.newPwdBc.replace(/\s+/g, ""));
        var number_validity = passwordNumberExp.test($scope.newPwdBc.replace(/\s+/g, ""));
        var content_validity = passwordElementExp.test($scope.newPwdBc.replace(/\s+/g, ""));
        if (!digit_validity) {
            notify.closeAll();
            notify({message: "密码请输入6-16位英文数字组合", duration: WebApp.duration});
            return false;
        }
        if (number_validity) {
            notify.closeAll();
            notify({message: "密码请输入6-16位英文数字组合", duration: WebApp.duration});
            //$scope.validateResultPass = '密码请输入6-16位英文数字组合';
            return false;
        }
        if (content_validity) {
            notify.closeAll();
            notify({message: "密码请输入6-16位英文数字组合", duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //验证重复密码
    $scope.passwordConfirm = function () {
        if (!$scope.repeatPwdBc) {
            notify.closeAll();
            notify({message: "确认密码不能为空", duration: WebApp.duration});
            return false;
        }
        if ($scope.repeatPwdBc !== $scope.newPwdBc) {
            notify.closeAll();
            notify({message: "两次密码输入不一致", duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //验证交易密码
    $scope.validatePayPassWord = function (payPassword) {
        if (!payPassword) {
            notify.closeAll();
            notify({message: "密码不能为空", duration: WebApp.duration});
            return false;
        }
        if ($scope.passwordBc && $scope.passwordBc == payPassword) {
            notify.closeAll();
            notify({message: "交易密码和登陆密码不能相同", duration: WebApp.duration});
            return false;
        }
        var passwordDigitExp = /^.{6,15}$/;
        var passwordNumberExp = /^\d+$/;
        var passwordElementExp = /^[a-zA-Z]+$/;
        var passwordDigitExp3 = /^[0-9a-zA-Z_]{1,}$/;
        var digit_validity = passwordDigitExp.test(payPassword.replace(/\s+/g, ""));
        var number_validity = passwordNumberExp.test(payPassword.replace(/\s+/g, ""));
        var content_validity = passwordElementExp.test(payPassword.replace(/\s+/g, ""));
        var digit_validity1 = passwordDigitExp3.test(payPassword.replace(/\s+/g, ""));
        if (!digit_validity) {
            notify.closeAll();
            notify({message: "密码长度为6-15位", duration: WebApp.duration});
            return false;
        }
        if (number_validity) {
            notify.closeAll();
            notify({message: "密码必须由英文、数字或下划线组成", duration: WebApp.duration});
            return false;
        }
        if (content_validity) {
            notify.closeAll();
            notify({message: "密码必须由英文、数字或下划线组成", duration: WebApp.duration});
            return false;
        }
        if (!digit_validity1) {
            notify.closeAll();
            notify({message: "密码必须由英文、数字或下划线组成", duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //验证重复交易密码
    $scope.payPasswordConfirm = function (payPassword, passwordConfirms) {
        if (!passwordConfirms) {
            notify.closeAll();
            notify({message: "确认密码不能为空", duration: WebApp.duration});
            return false;
        }
        if (passwordConfirms !== payPassword) {
            notify.closeAll();
            notify({message: "两次密码输入不一致", duration: WebApp.duration});
            return false;
        }
        notify.closeAll();
        return true;
    };
    //修改登陆密码
    $scope.modifyPasswordStatus = 0;
    $scope.modifyPassword = function () {
        if ($scope.newPwdBc !== $scope.repeatPwdBc) {
            notify.closeAll();
            notify({message: "两次密码输入不一致", duration: WebApp.duration});
            $scope.modifyPasswordStatus = 0;
            return;
        }
        if ($scope.modifyPasswordStatus !== 0) {
            $timeout(function () {
                $scope.modifyPasswordStatus = 0;
            }, 2000);
            return;
        }
        $scope.modifyPasswordStatus = 1;
//        $log.log($scope.checkLoginPwd());
//        if (!$scope.checkLoginPwd()) {
//            $scope.modifyPasswordStatus = 0;
//            return;
//        }
        if (!$scope.validatePassWord()) {
            $scope.modifyPasswordStatus = 0;
            return;
        }
        if (!$scope.passwordConfirm()) {
            $scope.modifyPasswordStatus = 0;
            return;
        }

        var password = md5.createHash($scope.passwordBc || "");
        var newPwd = md5.createHash($scope.newPwdBc || "");
        var repeatPwd = md5.createHash($scope.repeatPwdBc || "");
        AccountService.modifyPassword({password: password, newPwd: newPwd, repeatPwd: repeatPwd}, function (data) {
            notify.closeAll();
            //notify({message: "修改登陆密码成功！", duration: WebApp.duration});
            $scope.modifyPasswordSuccess = true;
            $timeout(function () {
                $location.path(WebApp.Router.USER_SET);
            }, 360);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //修改交易密码
    $scope.modifyPaypasswordStatus = 0;
    $scope.modifyPaypassword = function () {
        if ($scope.newPaypwdBc !== $scope.repeatPaypwdBc) {
            notify.closeAll();
            notify({message: '两次密码输入不一致', duration: WebApp.duration});
            $scope.modifyPaypasswordStatus = 0;
            return;
        }
        if ($scope.modifyPaypasswordStatus !== 0) {
            $timeout(function () {
                $scope.modifyPaypasswordStatus = 0;
            }, 2000);
            return;
        }
        $scope.modifyPaypasswordStatus = 1;
//        if (!$scope.checkPaypwd()) {
//            $scope.modifyPaypasswordStatus = 0;
//            return;
//        }
        if (!$scope.validatePayPassWord($scope.newPaypwdBc)) {
            $scope.modifyPaypasswordStatus = 0;
            return;
        }
        if (!$scope.payPasswordConfirm($scope.newPaypwdBc, $scope.repeatPaypwdBc)) {
            $scope.modifyPaypasswordStatus = 0;
            return;
        }

        var paypassword = md5.createHash($scope.paypasswordBc || "");
        var newPaypwd = md5.createHash($scope.newPaypwdBc || "");
        var repeatPaypwd = md5.createHash($scope.repeatPaypwdBc || "");
        AccountService.modifyPaypassword({paypassword: paypassword, newPaypwd: newPaypwd, repeatPaypwd: repeatPaypwd}, function (data) {
            notify.closeAll();
            //notify({message: "修改交易密码成功！", duration: WebApp.duration});
            $scope.payPasswordError = true;
            $timeout(function () {
                $location.path(WebApp.Router.USER_SET);
            }, 360);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //设置交易密码
    $scope.setPayPassword = function () {
        if (!$scope.validatePayPassWord($scope.payPassword)) {
            return false;
        }
        if ($scope.payPassword !== $scope.passwordConfirms) {
            notify.closeAll();
            notify({message: '两次密码输入不一致', duration: WebApp.duration});
            return;
        }
        var password = md5.createHash($scope.passwordBc || "");
        var payPassword = md5.createHash($scope.payPassword || "");
        var passwordConfirms = md5.createHash($scope.passwordConfirms || "");
        AccountService.setPayPassword({password: password, payPassword: payPassword}, function (data) {
            notify.closeAll();
            $timeout(function () {
                $location.path(history.go(-1));
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //检测用户身份证是否正确
    $scope.checkIDcard = function () {
        var cardID = $scope.checkIDcardValue;
        AccountService.checkIDcard({cardID: cardID}, function (data) {
            $timeout(function () {
                $location.path(WebApp.Router.FIND_DEAL_PASSWORD);
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //获取手机验证码
    $scope.statusClock = true;
    $scope.phoneValidateCode = function () {
        $scope.userPhone = WebApp.tmpValue.setOrGetStoreVal("value_phone", "");
        var phone = $scope.userPhone;
        if (!$scope.userPhone) {
            phone = $scope.newPhone;
            RegisterService.checkPhone({phone: phone}, function (data) {
                notify.closeAll();
                AccountService.getPhoneCode({phone: phone, type: 'resetPayPwd'}, function (data) {
                    $scope.countdown = 60;
                    $interval.cancel($scope.counter);
                    $scope.counter = $interval(function () {
                        if ($scope.countdown > 0) {
                            $scope.statusClock = false;
                            $scope.countdown--;
                        } else {
                            $scope.statusClock = true;
                            $interval.cancel($scope.counter);
                        }
                    }, 1000);
                }, function (data) {
                    notify.closeAll();
                    notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
                });
                return true;
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
                return false;
            });
        } else {
            AccountService.getPhoneCode({phone: phone, type: 'resetPayPwd'}, function (data) {
                $scope.countdown = 60;
                $interval.cancel($scope.counter);
                $scope.counter = $interval(function () {
                    if ($scope.countdown > 0) {
                        $scope.statusClock = false;
                        $scope.countdown--;
                    } else {
                        $scope.statusClock = true;
                        $interval.cancel($scope.counter);
                    }
                }, 1000);
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        }


    };
    //手机号修改密码验证
    $scope.phoneValidate = function (ValidateType) {
        var type = null;
        if (ValidateType) {
            type = ValidateType;
        }
        $scope.userPhone = WebApp.tmpValue.setOrGetStoreVal("value_phone", "");
        var phone = $scope.userPhone;
        if (!$scope.userPhone) {
            phone = $scope.newPhone;
        }
        if (!$scope.userCode) {
            notify({message: "验证码不能为空", duration: WebApp.duration});
            return;
        }
        AccountService.phoneValidate({phone: phone, code: $scope.userCode, type: type}, function (data) {
            WebApp.tmpValue.setOrGetStoreVal("k_vcode", data.vcode);
            $timeout(function () {
                $location.path(WebApp.Router.SET_DEAL_PASSWORD);
            }, 0);
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    //重设交易密码
    $scope.resetPayPassStatus = 0;
    $scope.resetPayPass = function () {
        $scope.userPhone = WebApp.tmpValue.setOrGetStoreVal("value_phone", "");
        var phone = $scope.userPhone;
        if (!$scope.userPhone) {
            phone = $scope.newPhone;
        }
        var vcode = WebApp.tmpValue.setOrGetStoreVal("k_vcode", "");
        var paypassword = md5.createHash($scope.newPayPassWord || "");
        if ($scope.newPayPassWord !== $scope.newPayPassWordC) {
            notify.closeAll();
            notify({message: '两次密码输入不一致', duration: WebApp.duration});
            $scope.resetPayPassStatus = 0;
            return;
        }
        if ($scope.resetPayPassStatus !== 0) {
            $timeout(function () {
                $scope.resetPayPassStatus = 0;
            }, 2000);
            return;
        }
        $scope.resetPayPassStatus = 1;
        if (!$scope.validatePayPassWord($scope.newPayPassWord)) {
            $scope.resetPayPassStatus = 0;
            return;
        }
        if (!$scope.payPasswordConfirm($scope.newPayPassWord, $scope.newPayPassWordC)) {
            $scope.resetPayPassStatus = 0;
            return;
        }

        AccountService.resetPaypwd({phone: phone, paypassword: paypassword, vcode: vcode}, function (data) {
            $scope.resetPayPassStatus = 0;
            notify.closeAll();
            $timeout(function () {
                $location.path(WebApp.Router.USER_SET);
            }, 0);
        }, function (data) {
            $scope.resetPayPassStatus = 0;
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //realinfo
    $scope.realinfo = function () {
        InvestsService.getLoginINfo(function (data) {
            $scope.realNameStatus = data.realNameStatus;
            $log.log(data);
            if (data.realNameStatus == 1) {
                $timeout(function () {
                    $location.path(WebApp.Router.FIND_DEAL_PASSWORD2);
                }, 0);
            } else if (data.realNameStatus == 0) {
                notify.closeAll();
                notify({message: "您的实名认证信息正在审核中，暂时不支持找回交易密码", duration: WebApp.duration});
            } else if (data.realNameStatus == 2) {
                notify.closeAll();
                notify({message: "您的实名认证信息未审核通过，暂时不支持找回交易密码", duration: WebApp.duration});
            } else if (data.realNameStatus == 3) {
                notify.closeAll();
                notify({message: "您还没有实名认证，暂时不支持找回交易密码", duration: WebApp.duration});
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    
});
