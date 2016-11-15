//项目详情service
WebApp.Instance.factory('ProjectService', function ($http, $location, $log, $timeout) {
	
	return {
		//用户投资记录
		getProjectsRecords:function(data, success, error){
			$http.get('/wechat/project/records', {
				params:{
					borrowId: data.borrowId,
					pageSize: data.pageSize,
                    pageIndex: data.pageIndex,
                    from:4
				},headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
			}).success(function (response, status, headers, config) {
                success(response.data);
			}).error(function (response, status, headers, config) {
                error(response);
            });
		},
		//可投资余额
		getAvailableAmount:function(data, success, error){
			$http.get('/wechat/project/availableamout', {
				params:{
					borrowId: data.borrowId,
                    from:4
				},headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
			}).success(function (response, status, headers, config) {
                success(response.data);
			}).error(function (response, status, headers, config) {
                error(response);
            });
		},
		//借款人信息
		getProjectsBorrower:function(data, success, error){
			$http.get('/wechat/project/borrower', {
				params:{
					borrowId: data.borrowId,
                    from:4
				},headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
			}).success(function (response, status, headers, config) {
                success(response.data);
			}).error(function (response, status, headers, config) {
                error(response);
            });
		},
		//项目介绍/风控信息
		getProjectsIntro:function(data, success, error){
			
			$http.get('/wechat/project/intro', {
				params:{
					borrowId: data.borrowId,
                    from:4
				},headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
			}).success(function (response, status, headers, config) {
                success(response.data);
			}).error(function (response, status, headers, config) {
                error(response);
            });
		},
		//风控模型(雷达图)
		getRiskIntro:function(data, success, error){
			$http.get('/wechat/project/risk', {
				params:{
					borrowId: data.borrowId,
                    from:4
				},headers: {
                    'X-Authorization': WebApp.ClientStorage.getCurrentToken()
                }
			}).success(function (response, status, headers, config) {
                success(response.data);
			}).error(function (response, status, headers, config) {
                error(response);
            });
		}
	}
});