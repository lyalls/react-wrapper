
"use strict";
var App = {};

angular.module("ngTouch", [])
.directive("ngTouchstart", function () {
  return {
    controller: function ($scope, $element, $attrs) {
      $element.bind('touchstart', onTouchStart);
      
      function onTouchStart(event) {
        var method = $element.attr('ng-touchstart');
        $scope.$event = event;
        $scope.$apply(method);
      };
    }
  };
}).directive("ngTouchmove", function () {
  return {
    controller: function ($scope, $element, $attrs) {
      $element.bind('touchstart', onTouchStart);
      
      function onTouchStart(event) {
        //event.preventDefault();
        $element.bind('touchmove', onTouchMove);
        $element.bind('touchend', onTouchEnd);
      };
      
      function onTouchMove(event) {
          var method = $element.attr('ng-touchmove');
          $scope.$event = event;
          $scope.$apply(method);
      };
      
      function onTouchEnd(event) {
       // event.preventDefault();
        $element.unbind('touchmove', onTouchMove);
        $element.unbind('touchend', onTouchEnd);
      };
    }
  };
}).directive("ngTouchend", function () {
  return {
    controller: function ($scope, $element, $attrs) {
      $element.bind('touchend', onTouchEnd);
      
      function onTouchEnd(event) {
        var method = $element.attr('ng-touchend');
        $scope.$event = event;
        $scope.$apply(method);
      };
    }
  };
});
App.instance = angular.module('baocaiApp', ['ngRoute','mobile-angular-ui','ngTouch']);
Date.prototype.pattern=function(fmt) {
     var o = {
     "M+" : this.getMonth()+1, //月份
     "d+" : this.getDate(), //日
     "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时
     "H+" : this.getHours(), //小时
     "m+" : this.getMinutes(), //分
     "s+" : this.getSeconds(), //秒
     "q+" : Math.floor((this.getMonth()+3)/3), //季度
     "S" : this.getMilliseconds() //毫秒
     };
     var week = {
     "0" : "/u65e5",
     "1" : "/u4e00",
     "2" : "/u4e8c",
     "3" : "/u4e09",
     "4" : "/u56db",
     "5" : "/u4e94",
     "6" : "/u516d"
     };
     if(/(y+)/.test(fmt)){
     fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
     }
     if(/(E+)/.test(fmt)){
     fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);
     }
     for(var k in o){
     if(new RegExp("("+ k +")").test(fmt)){
     fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
     }
     }
     return fmt;
     };
