WebApp.Instance.directive('couponslist',function()
{
  	return {
  		restrict: 'A',
        templateUrl: 'couponslist.html',
        scope: {
            coupname: '@myName',
            title: '@myTitle',	
            list:'=list',
            itemClick : '&itemClick'
        },
        replace: false
       };

});