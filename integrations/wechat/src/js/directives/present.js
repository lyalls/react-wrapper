/*
 * 取现
 */
/*
 * restrict:指定指令名字是一个标识符，可以作为元素名（E），元素属性（A）,注释（M），类名（C）
 * scope:该作用域下面的全局变量， 默认情况下跟父级ｓｃｏｐｅ时相互通信的
 * transclude：为true不会替换原来的内容，但是会增加template标签里面的内容
 * replace:为true时，会替换原来的内容
 * $watch ngModel模型监控
 * 
 */
WebApp.Instance.directive('presentDirective', function ($log, notify, PresentService) {
    return {
        restrict: 'E',
        template: '<div class="k_input k_reg_yzm k_pr" style="padding-top:0px;"><input type= "text"   ng-show = "!(info.phone)" ng-model ="addPhone"  placeholder="请填写电话号码">' +
                '<div class="k_error_msg" ng-show="phoneErrorCode" ng-model="phoneErrorCode">{{phoneErrorCode}}</div></div>',
        link: function (scope, element, attrs) {
            scope.$watch('addPhone', function (newValue, oldValue) {
                if (angular.isUndefined(newValue) || newValue == null) {
                    return false;
                }
                //scope.phoneErrorCode = false;
                var mobile = /^1[3|4|5|7|8][0-9]{9}$/;
                if (mobile.test(newValue)) {
                    PresentService.checkPhone({phone: newValue}, function (data) {
                        if (!data.success) {
                            //scope.phoneErrorCode = data.message;
                            notify.closeAll();
                            notify({message: data.message, duration: WebApp.duration});
                        }
                    }, function (data) {
                        notify.closeAll();
                        notify({message: WebApp.dealHttp(data), duration: WebApp.duration});
                    });
                    return true;
                }
                //scope.phoneErrorCode = '请正确填写手机号';
                notify.closeAll();
                notify({message: "请正确填写手机号", duration: WebApp.duration});
            });
        }
    };
});
