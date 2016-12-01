WebApp.Instance.directive('myFocus', function () {
    return{
        restrict: 'A',
        link: function (scope, element, attr) {
            scope.$watch(attr.myFocus, function (n, o) {
                if (n !== o && n) {
                    element[0].focus();
                }
            });
        }
    };
});

WebApp.Instance.directive('myBlur', function () {
    return{
        restrict: 'A',
        link: function (scope, element, attr) {
            element.bind('blur', function () {
                scope.$apply(attr.myBlur);
            });
        }
    };
});


WebApp.Instance.directive('bcFocus', function () {
    return{
        restrict: 'A',
        link: function (scope, element, attr) {
            if(WebApp.Terminal.platform.android && WebApp.Terminal.platform.weChat ){
                angular.element(element).on('touchstart',function(){
                    angular.element(this).find(attr.bcFocus)[0].focus();
                });
                angular.element(element).on('click',function(){
                    angular.element(this).find(attr.bcFocus)[0].focus();
                });
            }
        }
    };
});


WebApp.Instance.directive('toBottom', function () {
    return{
        restrict: 'A',
        link: function(scope, element, attr){          
            
           document.addEventListener('touchmove', function(ev){
             element[0].style.bottom = 0+'px';
           })

        }
    };
});