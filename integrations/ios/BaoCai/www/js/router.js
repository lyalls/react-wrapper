App.instance.config(['$routeProvider', function($routeProvider){
    $routeProvider
    .when('/',{templateUrl:'template/coupons.html'})
    .when('/investing',{templateUrl:'template/investing.html'})
    .when('/coupons',{templateUrl:'template/coupons.html'})
    .otherwise({redirectTo:'/coupons'});
}]);