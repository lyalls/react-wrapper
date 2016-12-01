WebApp.Instance.controller('DiscoverController', function ($rootScope, $scope, $location, md5, $log, DiscoverService, notify, $interval, $timeout){
    notify.closeAll();
    
    $scope.timeStamp = function (second_time) {
        var time = parseInt(second_time) + "秒";
        if (parseInt(second_time) > 60) {

            var second = parseInt(second_time) % 60;
            var min = parseInt(second_time / 60);
            time = min + "分" + second + "秒";

            if (min > 60) {
                min = parseInt(second_time / 60) % 60;
                var hour = parseInt(parseInt(second_time / 60) / 60);
                time = hour + "小时" + min + "分" + second + "秒";

                if (hour > 24) {
                    hour = parseInt(parseInt(second_time / 60) / 60) % 24;
                    var day = parseInt(parseInt(parseInt(second_time / 60) / 60) / 24);
                    time = day + "天"; //time = day + "天" + hour + "小时" + min + "分" + second + "秒";
                }
            }
        }
        return time;
    }
    
    $scope.activeList = function(){
        $scope.activeMore = 1; 
        $scope.activeLists = [];
        
        $scope.change = function () {
            $scope.activeLists = [];
            DiscoverService.getList({
                pageSize: "3",
                pageIndex: "1"
            }, function (data) {
                for (var i = 0; i < data.list.length; i++) {
                     if(data.list[i].status == 1)
                    {
                        data.list[i].restTime = $scope.timeStamp(data.list[i].lefttime); 
                    }
                    $scope.activeLists.push(data.list[i]);
                }
                $scope.indexBottom = 2;
                notify.closeAll();
                if (data.list.length == 0) {
                    $scope.activeMore = 0;
                }
            }, function (data) {
                notify.closeAll();
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            });
        };
        
        $scope.sizeBottom = 3;
        $scope.indexBottom = 3;
        
        $scope.bottom = function () {
            DiscoverService.getList({
                pageSize: $scope.sizeBottom,
                pageIndex: $scope.indexBottom
            }, function (data) {
                if (data.list.length == 0) {
                    notify.closeAll();
                    notify({message: "没有更多数据！", duration: WebApp.duration});
                    return;
                }
                for (var i = 0; i < data.list.length; i++) {
                    if(data.list[i].status == 1)
                    {
                        data.list[i].restTime = $scope.timeStamp(data.list[i].lefttime); 
                    }
                    $scope.activeLists.push(data.list[i]);
                }
                $scope.indexBottom++;
            });
        };
    };
});
