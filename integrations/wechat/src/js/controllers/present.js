/* 
 *取现控制器
 *2015-06-29
 *ranhai
 */

WebApp.Instance.controller('PresentController', function ($rootScope, $scope, $window, $modal, $location, md5, PresentService, InvestsService, notify, $log, $timeout) {
    $scope.countdown = "";
    $scope.errorCode = "";
    $scope.getPresentInfo = function () {
        PresentService.checkBankCard(function (data) {
            //实名认证
            if (data.realName == 'noSet') {
                $scope.presentPopUp('approveName', 20, 'present');
                return false;
            }
            if (data.realName == 'verify') {
                $scope.presentPopUp('approveNameVerify', 20, 'present');
                return false;
            }
            //交易密码
            if (data.payPassword != 'set') {
                $scope.presentPopUp('payPassword', 20, 'present');
                return false;
            }

            /*
             * 充值信息接口
             * wirteBankCard: 需要填写银行卡所有信息
             * wirteBankInfo:需要填写银行卡开户行信息
             * wirteCashMoney:可以直接提现
             *  */
            PresentService.getPresentInfo(function (data) {
                var url = {
                    wirteBankCard: WebApp.Router.USER_CARD,
                    wirteBankInfo: WebApp.Router.USER_BANK,
                    wirteCashMoney: WebApp.Router.USER_PRESENT
                };
                $timeout(function () {
                    $location.path(url[data.bankCardInfo]);
                }, 0);
            });
        });
    };

    //银行信息
    $scope.getBankInfo = function () {
        PresentService.getBankInfo(function (data) {
            $scope.info = data;
            $scope.phone = data.phone;
            $scope.availableBalance = data.availableBalance;
            
            if (data.phone) {
                $scope.info.phoneShow = data.phone.substring(0,3)+"****"+data.phone.substring(7,11);
            }
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };

    //取现短信
    $scope.presentPhoneCode = function () {
        var phone = $scope.phone ? $scope.phone : $scope.addPhone;
        if (!phone || $scope.phoneErrorCode || !$scope.cashMoney || $scope.cashMoney < 50) {
        	notify.closeAll();
            notify({message: '提现金额需大于等于50元', duration: WebApp.duration});
            return false;
        }
        if (Number($scope.cashMoney) > Number($scope.availableBalance)) {
        	notify.closeAll();
            notify({message: '可提现金额不足！', duration: WebApp.duration});
            return false;
        }
        if ($scope.addPhone) {
            var mobile = /^1[3|4|5|7|8][0-9]{9}$/;
            if (!mobile.test(phone)) {
                notify.closeAll();
                notify({message: '请正确填写手机号', duration: WebApp.duration});
                return false;
            }
            PresentService.checkPhone({phone: $scope.addPhone}, function (data) {
                if (!data.success) {
                    notify.closeAll();
                    notify({message: data.message, duration: WebApp.duration});
                    return false;
                }
                $scope.code(phone);
            });
        } else {
            $scope.code(phone);
        }


    };
    $scope.code = function (phone) {
        PresentService.presentPhoneCode(phone, function (data) {
            if (angular.isString(data)) {
                notify.closeAll();
                notify({message: data, duration: WebApp.duration});
            } else {
                $scope.phoneCodeTimeOut(60);
                WebApp.ClientStorage.store('phoneCode', data.code);
            }

        });
    }

    //倒计时
    $scope.phoneCodeTimeOut = function (timer) {
        $scope.countdown = timer;
        var myTime = setInterval(function () {
            if ($scope.countdown > 0) {
                $scope.countdown--;
            }
            $scope.$digest(); // 通知视图模型的变化
        }, 1000);
        // 倒计时10-0秒，但算上0的话就是11s
        setTimeout(function () {
            clearInterval(myTime);
            //$scope.countdown.$destroy();
        }, 61000);
    };

    //取现数据提交
    $scope.doPresent = function () {
        if (WebApp.statusPresent != 0) {
            notify.closeAll();
            notify({message: "您点击太频繁啦", duration: WebApp.duration});
            $timeout(function () {
                WebApp.statusPresent = 0;
            }, 5000);
            return;
        }
        WebApp.statusPresent = 1;
        var cashMoney = $scope.cashMoney;
        var cashCode = $scope.cashCode;
        if (!$scope.checkCashMoney()) {
            return false;
        }
//        if (!$scope.checkCashCode()) {
//            return false;
//        }
//        
        var code = $scope.cashCode;
        PresentService.checkCodeOfPhone({phone: $scope.phone, code: code}, function (data) {
            //清空验证码
            WebApp.ClientStorage.remove('phoneCode');
            WebApp.tmpValue.setOrGetStoreVal('Detail_cashMoney', cashMoney);
            WebApp.tmpValue.setOrGetStoreVal('Detail_cashCode', cashCode);
            InvestsService.preCheck(function (data) {
                var cashMoney = WebApp.tmpValue.setOrGetStoreVal('Detail_cashMoney', '');
                var cashCode = WebApp.tmpValue.setOrGetStoreVal('Detail_cashCode', '');
                if (!data.needSetPassword) {
                    $scope.presentPopUp('presentPopUp', 20, 'present', {cashMoney: cashMoney, cashCode: cashCode});
                    //noValidateIDCardWarn("", "noSetPayPassword");
                    return;
                } else {
                    $scope.presentPopUp('payPassword', 20, 'present');
                    //noValidateIDCardWarn("", "noSetPayPassword");
                    return;
                }
            }, function (response, status, headers, config) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        }, function (data) {
            notify.closeAll();
            notify({message: "验证码不正确", duration: WebApp.duration});
            WebApp.statusPresent = 0;

        });

        //打开窗口
        //$scope.presentPopUp('presentPopUp', 20, 'present', {cashMoney: cashMoney, cashCode: cashCode});
    };

    //取现金额验证
    $scope.checkCashMoney = function () {
        var cashMoney = $scope.cashMoney;
        var cashCode = $scope.cashCode;
        if (!cashMoney) {
            notify.closeAll();
            notify({message: '提现金额不能为空', duration: WebApp.duration});
            return false;
        }
        if (cashMoney && !cashCode){
        	notify.closeAll();
            notify({message: '短信验证码不能为空', duration: WebApp.duration});
            return false;
        }
        var reg = /^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;
        if (!reg.test(cashMoney)) {
            notify.closeAll();
            notify({message: '请正确填写取现金额', duration: WebApp.duration});
            return false;
        }
        cashMoney = parseFloat(cashMoney);
        if (cashMoney < 50) {
            notify.closeAll();
            notify({message: '提现金额不少于50元', duration: WebApp.duration});
            return false;
        }
        if (cashMoney > $scope.availableBalance) {
            notify.closeAll();
            notify({message: '可提现金额不足', duration: WebApp.duration});
            return false;
        }
        $scope.cashMoneyError = false;
        return true;
    };

    //取现验证码验证
//    $scope.status = true;
//    $scope.checkCashCode = function () {
//        var code = $scope.cashCode;
//        PresentService.checkCodeOfPhone({phone: $scope.phone, code: code}, function (data) {
//            WebApp.tmpValue.setOrGetStoreVal('Detail_status', "true");
//        }, function (data) {
//            notify.closeAll();
//            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
//            WebApp.tmpValue.setOrGetStoreVal('Detail_status', "false");
//        });
//        $scope.status = WebApp.tmpValue.setOrGetStoreVal('Detail_status', "");
//        return $scope.status;
////        var storeCode = WebApp.ClientStorage.retrieve('phoneCode');
////        if (!code) {
////            notify.closeAll();
////            notify({message: '验证码不能为空', duration: WebApp.duration});
////            return false;
////        }
////        if (!storeCode) {
////            notify.closeAll();
////            notify({message: '验证码不存在', duration: WebApp.duration});
////            return false;
////        }
////
////        if (md5.createHash(code || '') != storeCode) {
////            notify.closeAll();
////            notify({message: '验证码错误', duration: WebApp.duration});
////            return false;
////        }
////        $scope.cashCodeError = false;
////        return true;
//    };

    //取现结果页面
    $scope.cashResult = function () {
        var date = $location.search().t;
        if (date) {
            $scope.cashDate = decodeURIComponent(date);
        }
    };

    //skipUsers
    $scope.skipUsers = function () {
        $timeout(function () {
            $location.url(WebApp.Router.USERS_ACCOUNT);
        }, 0);
    };

    //银行卡信息填写
    $scope.getBankBasicInfo = function () {
        PresentService.getBankBasicInfo(function (data) {
            $scope.bascInfo = data;
            //取不到索引 $index
            $scope.key = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20];
            if (data.type) {
                $timeout(function () {
                    $location.url(WebApp.Router.USER_PRESENT);
                }, 0);
            }
        })
    };

    //获取联动值
    $scope.getAreaSubject = function () {
        var pid = $scope.areas.area.id;
        if (!pid) {
            $scope.areaSubject = false;
            return false;
        }
        PresentService.getAreaSubject(pid, function (data) {
            $scope.areaSubject = data;
        })

    };

    //银行卡添加
    $scope.addUserBank = function () {
        if (!$scope.checkBankBackInfo()) {
            return false;
        }
        var data = {
            account: $scope.bankCardOne,
            bank: $scope.bankCode.bankCode,
            branch: $scope.branch,
            province: $scope.areas.area.id,
            city: $scope.areaSubject.city.id,
        };
        PresentService.addUserBank(data, function (data) {
            if (!data.type) {
                $scope.errorMessage = data.message;
                return false;
            }
            $timeout(function () {
                $location.url(WebApp.Router.USER_PRESENT);
            }, 0);
        });

    };

    //验证信息是否填完整
    $scope.checkBankBackInfo = function () {
        $scope.errorMessage = null;
        if (!$scope.bankCode || !$scope.bankCode.bankCode) {
            $scope.errorMessage = '请选择银行';
            return false;
        }
        if (!$scope.areas || !$scope.areas.area.id || !$scope.areaSubject || !$scope.areaSubject.city) {
            $scope.errorMessage = '请选择开户行所在地';
            return false;
        }
        if (!$scope.branch) {
            $scope.errorMessage = '请填写开户支行名称';
            return false;
        }
        var one = $scope.bankCardOne;
        var two = $scope.bankCardTwo;
        if (!one || !two) {
            $scope.errorMessage = '请填写卡号';
            return false;
        }
        if (one != two) {
            $scope.errorMessage = '两次填写的卡号不一样';
            return false;
        }
        $scope.errorMessage = null;
        return true;
    };

    //银行卡补全信息获取
    $scope.getAccountBankInfo = function () {
        PresentService.getAccountBankInfo(function (data) {
            $scope.bascInfo = data;
            //$scope.areaSubject = data.subjectAreasList;
            if (data.type) {
                $timeout(function () {
                    $location.url(WebApp.Router.USER_PRESENT);
                }, 0);
            }
        });
    };

    //更新银行卡
    $scope.updateAccountBankInfo = function () {
        if (!$scope.checkAccountBankInfo()) {
            return false;
        }
        var data = {
            branch: $scope.branch,
            province: $scope.areas.area.id,
            city: $scope.areaSubject.city.id,
        };
        PresentService.updateAccountBankInfo(data, function (data) {
            if (!data.type) {
                $scope.errorMessage = data.message;
                return false;
            }
            $timeout(function () {
                $location.url(WebApp.Router.USER_PRESENT);
            }, 0);
        });
    };

    //检查信息
    $scope.checkAccountBankInfo = function () {
        $scope.errorMessage = null;
        if (!$scope.areas || !$scope.areas.area.id || !$scope.areaSubject || !$scope.areaSubject.city) {
            $scope.errorMessage = '请选择开户行所在地';
            return false;
        }
        if (!$scope.branch) {
            $scope.errorMessage = '请填写开户支行名称';
            return false;
        }
        $scope.errorMessage = false;
        return true;
    };

    //弹框
    $scope.presentPopUp = function (templateUrls, size, controller, prams) {
        $scope.items = prams;
        $scope.animationsEnabled = true;
        var modalInstance = $modal.open({
            animation: $scope.animationsEnabled,
            templateUrl: templateUrls,
            controller: controller,
            size: size,
            //windowClass:'k_cancel',
            resolve: {
                items: function () {
                    return $scope.items;
                }
            }

        });
        WebApp.mInstance = modalInstance;
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at:' + new Date());
        });
    };
});


WebApp.Instance.controller('present', function ($scope, $modalInstance, $log, $modal, $timeout, PresentService, notify, $location, md5, items) {
    $scope.items = items;
    $scope.paypassword = null;
    $scope.selected = {
        item: $scope.items
    };
    $scope.ok = function () {
        WebApp.statusPresent=0;
        $modalInstance.close($scope.selected.item);
    };
    $scope.cancel = function () {
        WebApp.statusPresent=0;
        $modalInstance.dismiss('cancel');
    };
    $scope.doPresentCreate = function () {
        var items = $scope.items;
        items['paypassword'] = md5.createHash($scope.paypassword || '');
        PresentService.checkPayPassword(items.paypassword, function (data) {
            if (!data.paypassword) {
                notify.closeAll();
                notify({message: "交易密码错误", duration: WebApp.duration});
                return false;
            }
            notify.closeAll();
            PresentService.doPresentCreate(items, function (data) {
                if (!data.presentType) {
                    $scope.errorPopuMessage = data.message;
                } else {
                    var timer = new Date();
                    var m = $scope.t(timer.getMonth() + 1);
                    var d = $scope.t(timer.getDate());
                    var h = $scope.t(timer.getHours());
                    var mt = $scope.t(timer.getMinutes());
                    t = m + '-' + d + ' ' + h + ':' + mt;
                    $scope.toSomePlace(WebApp.Router.RESULT + '?t=' + t);
                }
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });

    };
    $scope.t = function (t) {
        t < 10 ? t = '0' + t : t = t;
        return t;
    };
    //present/pay'
    $scope.checkPayPassword = function () {
        var pay = md5.createHash($scope.paypassword || '');
        PresentService.checkPayPassword(pay, function (data) {
            if (!data.paypassword) {
                notify.closeAll();
                notify({message: "交易密码错误", duration: WebApp.duration});
                return false;
            }
            notify.closeAll();
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
    };
    $scope.pathAll = {userAsset: WebApp.Router.USER_ASSET, userCenter: WebApp.Router.USER_ASSET, validateIDCard: WebApp.Router.POPUP_ID_CARD, setPayPassword: WebApp.Router.SET_PAY_PASSWORD, enoughMoney: WebApp.Router.HOME, investHistory: WebApp.Router.INVEST_PERSON_LIST};
    $scope.toSomePlace = function (path) {
        $timeout(function () {
            $location.url(path);
        }, 0);
        $modalInstance.close($scope.selected.item);
    };


});