App.instance.directive('couponslist',function()
{
  	return {
  		restrict: 'A',
        templateUrl: 'template/clist.html',
        scope: {
            name: '@myName',
            title: '@myTitle',	
            list:'=list',
            itemClick : '&itemClick'
        },
        replace: false
       };

});