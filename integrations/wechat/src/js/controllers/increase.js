"use strict";
WebApp.Instance.controller('IncreaseController', function ($scope, md5, $log, $route, IncreaseService, $http, $timeout, $location, notify) {
	var pageNum = 1;
	$scope.isMore = true;
	$scope.list = [];
	
	renderData(pageNum);
	function renderData(page) {
		IncreaseService.getIncreaseList(page, function(data) {
    	if (data.list.length === 0) {
    		$scope.isMore = false; return;
    	}
    	for (var i = 0; i < data.list.length; i++) $scope.list.push(data.list[i]);
    	pageNum += 1;
    }, function(data) {
    	notify.closeAll();
    });
	}
	
	$scope.getData = function() {
		if (!$scope.isMore) return;
		renderData(pageNum);
	}
});