//项目详情控制器
WebApp.Instance.controller('ProjectsController', function ($rootScope, $scope, $location,AccountService, ProjectService, md5, $log, notify, $interval, $modal,InvestsService, $window, $timeout,$cookies) {
	notify.closeAll();
	$scope.borrowId = WebApp.tmpValue.setOrGetStoreVal('borrowId', $location.search().borrowId);
	//获取投资记录
    $scope.projectRecordsList = [];
    $scope.size = 20;
    $scope.index = 2;
    $scope.isFullReward = '';
    $scope.objttype = WebApp.tmpValue.setOrGetStoreVal('objttype');
    $scope.typeNid = WebApp.tmpValue.setOrGetStoreVal('objtypeNid');
    
    $scope.userbind = 0;
    $scope.userhave = 1;
    //获取用户信息
    $scope.getUserInfo = function(){
    	
    	var UserInfo = WebApp.ClientStorage.getCurrentUser();
    	if(!UserInfo){
    		AccountService.myAccountINfo(function (data) {
                UserInfo = data;
                $scope.nowUser = UserInfo;
                if(data.phone){
                	$scope.userbind = 1
                	$scope.userhave = 0;
                }
             }, function (data) {
            	 $scope.userhave = 0;
                 notify.closeAll();
                 $cookies.put('login_url', WebApp.Router.PROJECT_INTRO);
                 return ;
             });
    	}else{
    		$scope.nowUser = UserInfo;
    		if(UserInfo.phone){
            	$scope.userbind = 1
            	$scope.userhave = 0;
            }
    		
    	}
    }
    
	$scope.getProjectsRecords = function(){
		$scope.size = 20;
        $scope.index = 1;
		ProjectService.getProjectsRecords({
			borrowId: $scope.borrowId,
			pageSize: $scope.size,
			pageIndex: $scope.index
		},function(data){
			$scope.projectRecordsList = [];
            for (var i = 0; i < data.list.length; i++) {
                $scope.projectRecordsList.push(data.list[i]);
            }
            $scope.isFullReward = data.isFullReward;
            $scope.userProjectRecordsList = $scope.projectRecordsList;
            $scope.userProjextRecordsCount = $scope.projectRecordsList.length;
            $scope.index++;
		},function(data){
			notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
		});
	};
	//下拉加载
	$scope.getProjectsRecordsRefresh = function(){
		
		ProjectService.getProjectsRecords({borrowId: $scope.borrowId, pageIndex: $scope.index, pageSize: $scope.size}, function (data) {
            if (data.list.length == 0) {
                notify.closeAll();
                notify({message: "没有更多数据!", duration: WebApp.duration});
                return;
            }
            for (var i = 0; i < data.list.length; i++) {
                $scope.projectRecordsList.push(data.list[i]);
            }
            $scope.userProjectRecordsList = $scope.projectRecordsList;
            $scope.index++;
        }, function (data) {
            notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        });
	}
    //图片跳转
    $scope.gotoImageView = function(event)
    {
        var url = event.target.src;
        if(url)
        {
           WebApp.tmpValue.setOrGetStoreVal('ImageView_imageUrl', url);
           $timeout(function () {
                $location.path(WebApp.Router.PICTURE_VIEW);
            }, 0);

        }
    }
	//借款人信息/用户详情
	$scope.getProjectsBorrower = function(){
		ProjectService.getProjectsBorrower({
			borrowId: $scope.borrowId,
		},function(data){
			if(data.borrowerInfo.userName){
				var str = data.borrowerInfo.userName;
				data.borrowerInfo.userName = str.replace(str.substring(1), function(){
					return new Array( str.length).join("*"); 
				});
			}
            $scope.projectBorrower = data;
		},function(data){
			notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
		});
	}
	//项目介绍/风控信息
	$scope.getProjectsIntro = function(){
		ProjectService.getProjectsIntro({
			borrowId: $scope.borrowId,
		},function(data){
            $scope.projectsIntro = data;
		},function(data){
			notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
		});
	}
	//选项卡
	$scope.jump_project = function (objttype){
		if(objttype =='borrower'){
			$scope.objttype = 'borrower';
		}else if(objttype =='intro'){
			$scope.objttype = 'intro';
		}else if(objttype =='records'){
			$scope.objttype ='records';
		}
	}
        
    $scope.projectintrologin = function(){
        $cookies.put('login_url', WebApp.Router.PROJECT_INTRO);
        $location.path(WebApp.Router.LOGIN);
    };
});

WebApp.Instance.controller('ProjectsAmountController', function ($rootScope, $scope, $location,InvestsService,AccountService,ProjectService, md5, $log, notify, $interval, $timeout,$modal,$cookies) {
	notify.closeAll();
	$scope.borrowId = WebApp.tmpValue.setOrGetStoreVal('borrowId', $location.search().borrowId);
	//可投剩余金额
	$scope.getAvailableAmount = function (){
		
		ProjectService.getAvailableAmount({
			borrowId: $scope.borrowId,
		},function(data){
            $scope.AvailableAmount = data;
            
            WebApp.tmpValue.setOrGetStoreVal('objtypeNid', data.typeNid);
		},function(data){
			notify.closeAll();
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
		});
	};

    $scope.getTenderInfoDetail = function (borrowId) {
        var UserInfo = WebApp.ClientStorage.getCurrentToken();
        if(!UserInfo)
        {
            AccountService.myAccountINfo(function (data) {
                UserInfo = data;
            }, function (data) {
                notify.closeAll();
                $cookies.put('login_url', WebApp.Router.PROJECT_INTRO);
                notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
                return ;
            });
        }
        if (borrowId>0) {

            //判断是新手标，专享码标
            var projectData =  WebApp.tmpValue.setOrGetStoreVal('Project_Data', '');
            var borrowType = projectData.borrowType;

            WebApp.Value.getStoreVal('Detail_borrowId', borrowId, $location, $timeout);
            //专享码
            if(borrowType == 1) {
                //是新手标，判断用户是否有新手资格
                InvestsService.getTenderInfo(borrowId, function (data) {
                    //新手码 (如果不是新手　弹框)
                    if (!data.isFirstTender ) {
                        dialog();
                    }
                    else
                    {
                        //跳转到投资页
                        $timeout(function () {
                            $location.path(WebApp.Router.INVEST);
                        }, 0);
                    }
                });
            }
            else{
                //跳转到投资页
                $timeout(function () {
                    $location.path(WebApp.Router.INVEST);
                }, 0);
            }

        }

    };


    function dialog()
    {
        var modalInstance = $modal.open({
            animation: true,
            templateUrl: 'xszxDialog',
            controller:'homePop',
            size: 20,
            resolve: {
                items: function () {
                    return $scope.items;
                }
            }
        });
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $log.info('Modal dismissed at:' + new Date());
        });
    };

});
//融三板雷达图
WebApp.Instance.controller('BigChart', function($rootScope, $scope, $location,ProjectService, md5, $log, notify, $interval, $timeout) {
    var vm = this;
    $scope.borrowId = WebApp.tmpValue.setOrGetStoreVal('borrowId', $location.search().borrowId);
    ProjectService.getRiskIntro({
		borrowId: $scope.borrowId,
	},function(data){
        risk = data.borrow_details;
	vm.charts = {
        options: {
            chart: {
                polar: true,
                type: 'line'
            },
            tooltip: {
                style: {
                    padding: 10,
                    fontWeight: 'bold'
                }
            },
            credits: {
                enabled: false
            },
            title: {
                text: ''
            },
            pane: {
                size: '75%'
            },
            xAxis: {
                categories: ['财务状况', '市场表现', '企业概况', '实地尽调'],
                tickmarkPlacement: 'on',
                lineWidth: 0
            },
            yAxis: {
                gridLineInterpolation: 'polygon',
                lineWidth: 0,
                min: 0,
                max: 10,
                labels: {
                    enabled: false
                }
            },
            plotOptions: {
                area: {
                    fillColor: 'rgba(253,204,186,0.5)',
                    color: '#f98b65'
                }
            },
            tooltip: {
                shared: true,
                pointFormate: '<span>{series.name}: <b>{point.y:,.of}</b></span><br />',
                enabled: false
            },
            legend: {
                align: 'right',
                verticalAlign: 'top',
                y: 70,
                layout: 'vertical',
                enabled: false
            },
        },

        series: [{
            name: '',
            type: 'area',
            data: [
		   risk ? risk.project_risk_finance : 5,
                   risk ? risk.project_risk_market : 6,
                   risk ? risk.project_risk_enterprise : 7,
                   risk ? risk.project_risk_research: 6,
                   ],
            pointPlacement: 'on'
        }]
    }

	},function(data){
	});
    
})
