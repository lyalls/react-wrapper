WebApp.Instance.controller('TradeRecordController', function ($rootScope, $scope, $location, md5, $log, AccountService, RegisterService, InvestsService, notify, $interval, $timeout){
    notify.closeAll();
    $scope.bcUser = "";
    $scope.nowUser = WebApp.ClientStorage.getCurrentUser();
    $scope.recordMenu = 0; 
    
    //accountLogs
    $scope.accountLogs = function () {
        $scope.recordMore = 1; 
        $scope.investsRecordList = [];
        $scope.recordMenuType = '';
        
        $scope.change = function () {
            $scope.investsRecordList = [];
            AccountService.accountLogsH5({
                type: $scope.recordMenuType,
                pageSize: "20",
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
                    $scope.recordMore = 0;
                }
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        };
        
        $scope.sizeBottom = 20;
        $scope.indexBottom = 2;
        
        $scope.bottom = function () {
            AccountService.accountLogsH5({
                type: $scope.recordMenuType,
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
        
        $scope.tradeRecordFilterShow = function(){
            $scope.recordMenu = 1; 
        }
        
        $scope.tradeRecordFilterHide = function () {
            $scope.recordMenu = 0;
        }
        
        $scope.changeType = function (menuType) {
            $scope.recordMenuType = menuType;
            $scope.indexBottom = 1;
            $scope.investsRecordList = [];
            AccountService.accountLogsH5({
                type: $scope.recordMenuType,
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
                $scope.recordMenu = 0;
                $scope.indexBottom++;
            });
        };
    };
    //change
});
