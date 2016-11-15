//选择优惠券
 WebApp.Instance.controller('InvestsCouponsController', function($scope,$timeout,$location) {

    //红包规则
    $scope.toConpusRule = function()
    {
       var pageinfo = {};
       pageinfo.showtag = $scope.showtag;
       pageinfo.top = $('#couponsId').scrollTop();
       pageinfo.oldtop = $scope.top;
       WebApp.pageinfo = pageinfo;
        $timeout(function () {
                $location.path(WebApp.Router.CONPUS_RULE);
            }, 0);
    }
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


    //测试
    /*window.baocaijs = {};
    window.baocaijs.call = function(msg)
    {
        var item = JSON.parse(msg)[0];
        App.platform.callback(item[2],{"investmentHorizon" : 6,
  "investCount" : 10000,
  "isAllowIncrease" : true,
  "bonusId" : 39123,
  "isFirstTender" : true,
  "increaseId" : 1561,
"bounsList" : [
    {
      "useMoney" : "10000",
      "id" : 39123,
      "catName" : "C",
      "expiredTime" : 1475377020,
      "money" : "100",
      "borrowPeriod" : 0
    },
    {
      "useMoney" : "10000",
      "id" : 39122,
      "catName" : "C",
      "expiredTime" : 1475377020,
      "money" : "100",
      "borrowPeriod" : 0
    }],
    "isBonusticket" : true,
    "increaseList" : [
    {
      "useMoney" : "0",
      "id" : 1857,
      "endtime" : 1473926979,
      "apr" : "",
      "starttime" : 1473667779
    },
    {
      "useMoney" : "0",
      "id" : 1856,
      "endtime" : 1473926928,
      "apr" : "",
      "starttime" : 1473667728
    }]
    });
    }*/
    var tmpdata = WebApp.tmpValue.setOrGetStoreVal('Bonus_Info', '');
    WebApp.proj = tmpdata;
    $scope.jianum = 0;
    $scope.hbnum = 0;
    if(WebApp.pageinfo)
    {
      $scope.showtag = WebApp.pageinfo.showtag;
      $scope.top = WebApp.pageinfo.oldtop;
      var top = WebApp.pageinfo.top;
      $timeout(function() { $('#couponsId').scrollTop(top);}, 0);
      WebApp.pageinfo = null;
    }
    else
    {
      
      $scope.showtag =0;
      $scope.top = 0;
    }
    $scope.IncreaseClick= function()
    {
        if($scope.showtag != 0)
        {
            var newtop = $('#couponsId').scrollTop();
            $scope.showtag = 0;
            $('#couponsId').scrollTop($scope.top);
            $scope.top = newtop;
        }
    };
     $scope.bounsClick= function()
    {
        if($scope.showtag != 1)
        {
            var newtop = $('#couponsId').scrollTop();
            $scope.showtag = 1;
            $('#couponsId').scrollTop($scope.top);
            $scope.top = newtop;
        }
    };
    //初始化数据
    {
        if(tmpdata.bouns == null)
        {
          tmpdata.bouns  = {};
        }
        var data = $.extend(true,{},tmpdata);
        try
        {
        //$('#test').text(JSON.stringify(data));
    	if(data.isBonusticket && data.isAllowIncrease)
    	{
    		data.both = true;
        $scope.showtag =1;
    	}
    	else if(data.isAllowIncrease)
    	{
        $scope.showtag =0;
            if(data.increaseList && data.increaseList.length >0)
            {
    		  $scope.info = '本项目限使用“加息券”,加息券最多可使用1张';
            }
            else
            {
                $scope.info = '本项目限使用“加息券"';
            }
    	}
    	else
    	{
          $scope.showtag =1;
            if(data.bounsList && data.bounsList.length >0)
            {
			 $scope.info = "本项目限使用“红包券”,红包券最多可使用1张"
            }
            else
            {
                $scope.info = '本项目限使用“红包券”'
            }
    	}
        var used = false;
        //红包卷
        //if(data.isBonusticket != 0)
        {
        	for(var i=0;i<data.bounsList.length;i++)
        	{
                var item = data.bounsList[i];
        		data.bounsList[i].used = 0;
                item.type = 4;
        		data.bounsList[i].date = new Date(data.bounsList[i].expiredTime*1000).pattern("yyyy年MM月dd日HH:mm过期");
        		var info = [];
        		info[0] = "";
        		if(item.catName == 'E' || item.catName == "F")
        		{
        			info[0] = "仅限首投，";
        		}
        		info[0] = info[0] + "单笔满"+data.bounsList[i].useMoney+"元可用";
        		if(item.borrowPeriod == 1)
        		{
        			info[1] = "投资1个月项目可用";
        		}
        		else if(item.borrowPeriod == 2)
        		{
					info[1] = "投资1-3个月项目可用";
        		}
        		else if(item.borrowPeriod == 3)
        		{
					info[1] = "投资3个月以上项目可用";
        		}
        		else if(item.borrowPeriod == 4)
        		{
					info[1] = "投资6个月以上项目可用";
        		}
        		item.info = info;
                data.bounsList[i].unit = "元";
        		data.bounsList[i].title = data.bounsList[i].money;
               //检查是否首投
    			if(data.bounsList[i].catName == "E" || data.bounsList[i].catName == "F")
    			{
    				if(!data.isFirstTender)
    				{
    					continue;
    				}
    			}
          if(data.isBonusticket == 0)
          {
            continue;
          }
    			 //检查期数
                if(data.bounsList[i].borrowPeriod == 1 && data.investmentHorizon != 1)
                {
                    continue;
                }
                else if(data.bounsList[i].borrowPeriod == 2 && data.investmentHorizon >3)
                {
                    continue;
                }
                else if(data.bounsList[i].borrowPeriod == 3 && data.investmentHorizon <3)
                {
                    continue;
                }
                else if(data.bounsList[i].borrowPeriod == 4 && data.investmentHorizon <6)
                {
                    continue;
                }
    			//金额检查
    			if(!data.investCount || data.investCount < data.bounsList[i].useMoney)
    			{
    				continue;
    			}
    			//检查结束时间
    			if(new Date(data.bounsList[i].expiredTime*1000) <  new Date())
    			{
    				continue;
    			}
                used = true;
    			data.bounsList[i].used = 1;
                item.type = 3;
    			if(data.bouns.bonus && data.bouns.bonus.id == data.bounsList[i].id)
    			{
    				data.bounsList[i].used = 2;
    				 $scope.hbnum = 1;
    				 $scope.bouns = data.bounsList[i];
    			}
        	}
        	data.bounsList.sort(function(a,b)
        	{
        		return b.used - a.used;
        	});

            if(used)
            {
                if(data.bouns.bonus && data.bouns.bonus.id == 0)
                {
                    var it = {used:2,id:0,title:"红包券",date:"不使用"};
                    data.bounsList.push(it);
                    $scope.bouns = it;
                }
                else
                {
                    data.bounsList.push({used:1,id:0,title:"红包券",date:"不使用"});
                }
            }

        }
        used = false;
        //加息卷
		   //if(data.isAllowIncrease != 0)
        {
        	for(var i = 0;i<data.increaseList.length;i++)
            {
            	var item = data.increaseList[i];
                data.increaseList[i].unit = "%";
                item.date = new Date(item.endtime*1000).pattern("yyyy年MM月dd日HH:mm过期");
        		item.info = [];
                item.type = 2;
        		item.info[0] = "单笔满"+data.increaseList[i].useMoney+"元可用";
            	data.increaseList[i].used = 0;
                data.increaseList[i].pre = "+";
            	data.increaseList[i].title = data.increaseList[i].apr;
            	//判断时间是否可用
            	var curdate = new Date();
            	var startdate = new Date(data.increaseList[i].starttime*1000);
            	var enddate = new Date(data.increaseList[i].endtime*1000);
            	if(curdate <startdate || curdate > enddate)
            	{
            		//不可用
            		continue;
            	}
            	//判断金额
            	if(!data.investCount || data.investCount < data.increaseList[i].useMoney)
            	{
            		continue;
            	}
              if(data.isAllowIncrease == 0)
              {
                continue;
              }
                used = 1;
                item.type = 1;
            	data.increaseList[i].used = 1;
            	if(data.bouns.increase &&  data.bouns.increase.id == data.increaseList[i].id)
    			{
    				$scope.jianum = 1;
    				data.increaseList[i].used = 2;
    				$scope.increase = data.increaseList[i];
    			}
            }

            data.increaseList.sort(function(a,b)
        	{
        		return b.used - a.used;
        	});
            if(used)
            {
                if(data.bouns.increase &&  data.bouns.increase.id == 0)
                {
                    var it = {used:2,id:0,title:"加息券",date:"不使用"};
                    data.increaseList.push(it);
                    $scope.increase = it;
                }
                else
                {
                    data.increaseList.push({used:1,id:0,title:"加息券",date:"不使用"});
                }
                
            }
        }
        }
        catch(e)
        {
        }
        $scope.data = data;
    }
    $scope.btnDone = function()
    {
    	 var param = {};
    	 param.increase = $scope.increase;
    	 param.bonus = $scope.bouns;
       WebApp.proj.bouns = param;
        history.back();
        $scope.apply();
    }
    $scope.itemClick = function(item)
    {
    	if(item.used == 1)
    	{
    		if($scope.showtag == 0)
    		{
 				//加息券
                if($scope.increase)
                {
 				    $scope.increase.used = 1;
                }
 				$scope.increase = item;
        WebApp.proj.bouns.increase = item;
 				$scope.increase.used = 2;
                if(item.id == 0)
                {
                    $scope.jianum = 0;
                }
                else
                {
                   $scope.jianum = 1;
                }
    		}
    		else
    		{
				       //红包券
               if($scope.bouns)
               {
                  $scope.bouns.used = 1;
                }
 				       $scope.bouns = item;
               WebApp.proj.bouns.bonus = item;
 				        $scope.bouns.used = 2;
                 if(item.id == 0)
                 {
                   $scope.hbnum = 0;
                 }
                 else
                 {
                    $scope.hbnum = 1;
                 }
    		}
    	}
    }
});

  
