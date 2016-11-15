
WebApp.Instance.controller('ImageViewController', function ($scope, $location, md5, LoginService, $timeout,$window) {
    $scope.$parent.myScrollOptions = {
        zoom: true,
		scrollX: true,
		scrollY: true,
		mouseWheel: true,
		wheelAction: 'zoom'
      };
      //设置高度宽度
      $('#imageview_image').height($window.document.body.clientHeight-44).width($window.document.body.clientWidth);
      //设置图片地址
      var url = WebApp.Value.getStoreVal('ImageView_imageUrl', '', $location, $timeout); 
      $scope.imgurl = url;
});
