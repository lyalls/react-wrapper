 App.instance.controller('MainController', function($scope) {
    $scope.firstName = "yachan";
});
  App.instance.controller('InvestingController', function($scope) {
    $scope.test = "1000.00";
});

//选择优惠券
 App.instance.controller('couponsController', function($scope) {

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

    $scope.showtag = 0;//0:加息券，1:红包券
    $scope.jianum = 0;
    $scope.hbnum = 0;
    var gpos = 0;
    $scope.jiaxileft = "0%"; 
    $scope.hbaoleft = "100%";
    var pos={};
    var m_stats=0;

    $scope.touchStart=function(e)
    {
        pos.y = e.originalEvent.touches[0].pageY;
        pos.x =  e.originalEvent.touches[0].pageX;
        if(pos.x<20)
        {
          m_stats = 2;
          return;
        }
        
        if($scope.data && $scope.data.both)
        {
            m_stats = 0;
            $scope.isTrans = false;
        }
        else
        {
            m_stats = 2;
        }
    }
    $scope.touchMove=function(e)
    {
        if(m_stats == 2)
            return;
        if(m_stats == 1)
        {
           var x = e.originalEvent.touches[0].pageX;
           var diff = (pos.x - x)/window.innerWidth;
           diff *=100;
           var newpos = gpos-diff;
           $scope.jiaxileft = newpos + "%"; 
            $scope.hbaoleft = (100+newpos) + "%";

        }
        else if(Math.abs(e.originalEvent.touches[0].pageX - pos.x) > Math.abs(e.originalEvent.touches[0].pageY - pos.y))
        {
            e.preventDefault();
            m_stats = 1;
        }
        else
        {
            m_stats = 2
        }
    }
    $scope.touchEnd=function(e)
    {
        if(m_stats == 1)
        {

           var x = e.originalEvent.changedTouches[0].pageX;
           var diff = (pos.x - x)/window.innerWidth;
           diff *=100;
           var newpos = gpos-diff;
           if(gpos == 0 && newpos <-40)
           {
              gpos = -100;
              $scope.showtag = 1;
           }
           else if(gpos == 0)
           {
           }
           else if(newpos >-60)
           {
             gpos = 0;
             $scope.showtag = 0;
           }
           else
           {
           }
                         
           if($scope.showtag == 0 && $scope.data.increaseList && $scope.data.increaseList.length >0)
           {
             $scope.data.showDone = true;
           }
           else if($scope.showtag == 1 && $scope.data.bounsList && $scope.data.bounsList.length >0)
           {
              $scope.data.showDone = true;
           }
           else
            {
                $scope.data.showDone = false;
            }
           $scope.isTrans = true;
           $scope.jiaxileft = gpos + "%"; 
           $scope.hbaoleft = (100+gpos) + "%";
        }
    }
    $scope.IncreaseClick = function()
    {
        if($scope.showtag != 0)
        {
            $scope.isTrans = true;
            $scope.showtag = 0;
            $scope.jiaxileft = "0%";
            $scope.hbaoleft = "100%";
            gpos = 0;
             if($scope.data.increaseList && $scope.data.increaseList.length >0)
             {
                $scope.data.showDone = true;
             }
             else
             {
                 $scope.data.showDone = false;
             }
        }
    };
     $scope.bounsClick= function()
    {
        if($scope.showtag != 1)
        {
            $scope.isTrans = true;
            $scope.showtag = 1;
            gpos = -100;
            $scope.jiaxileft = "-100%";
            $scope.hbaoleft = "0%";
             if($scope.data.bounsList && $scope.data.bounsList.length >0)
             {
                $scope.data.showDone = true;
             }
            else
             {
                $scope.data.showDone = false;
             }
        }
    };
    App.platform.pageLoad(function(data)
    {
        function transInvestmentHorizon(num)
       {
            if(typeof(num) === "string")
            {
                if(/(\d+)/.test(num)){
                 return RegExp.$1
              }
              else
              {
                return 0;
              }

            }
            else
            {
                return num
            }
        }
        data.investmentHorizon = transInvestmentHorizon(data.investmentHorizon);
        if(data.increaseList == null)
        {
            data.increaseList = [];
        }
        if(data.bounsList == null)
        {
            data.bounsList = [];
        }

        try
        {
        //$('#test').text(JSON.stringify(data));
    	if(data.isBonusticket && data.isAllowIncrease)
    	{
    		data.both = true;
                          
    	}
    	else if(data.isAllowIncrease)
    	{
            gpos = 0;
            $scope.jiaxileft = "0%";
            $scope.hbaoleft = "100%";
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
            gpos = 100;
            $scope.jiaxileft = "100%";
            $scope.hbaoleft = "0%";
            if(data.bounsList && data.bounsList.length >0)
            {
			 $scope.info = "本项目限使用“红包券”,红包券最多可使用1张"
            }
            else
            {
                $scope.info = '本项目限使用“红包券”'
            }
    	}
        var list=[];
    	if(data.isAllowIncrease)
    	{
    		$scope.showtag = 0;
            list = data.increaseList;
    	}
    	else
    	{
    		$scope.showtag = 1;
            list = data.bounsList;
    	}
        if(list && list.length >0)
       {
           data.showDone = true;
       }
        else
        {
          data.showDone = false;
          }
        var used = false;
        //红包卷
        if(data.isBonusticket)
        {
        	for(var i=0;i<data.bounsList.length;i++)
        	{
        		var item = data.bounsList[i];
        		data.bounsList[i].used = 0;
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
					info[1] = "投资3个月及以上项目可用";
        		}
        		else if(item.borrowPeriod == 4)
        		{
					info[1] = "投资6个月及以上项目可用";
        		}
        		item.info = info;
                data.bounsList[i].pre = "¥ ";
        		data.bounsList[i].title = data.bounsList[i].money;
               //检查是否首投
    			if(data.bounsList[i].catName == "E" || data.bounsList[i].catName == "F")
    			{
    				if(!data.isFirstTender)
    				{
    					continue;
    				}
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
    			if(data.bonusId == data.bounsList[i].id)
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
                if(data.bonusId == 0)
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
		if(data.isAllowIncrease)
        {
        	for(var i = 0;i<data.increaseList.length;i++)
            {
            	var item = data.increaseList[i];
        		item.date = new Date(item.endtime*1000).pattern("yyyy年MM月dd日HH:mm过期");
        		item.info = [];
        		item.info[0] = "单笔满"+data.increaseList[i].useMoney+"元可用";
            	data.increaseList[i].used = 0;
                data.increaseList[i].pre = "+";
            	data.increaseList[i].title = data.increaseList[i].apr+"%";
            	//判断时间是否可用
            	var curdate = new Date();
            	var startdate = new Date(data.increaseList[i].starttime*1000);
            	var enddate = new Date(data.increaseList[i].endtime*1000);
            	if(curdate <startdate || curdate > enddate)
            	{
                    item.date = startdate.pattern("yyyy年MM月dd日HH:mm至") + enddate.pattern("yyyy年MM月dd日HH:mm")+"间可用";
            		//不可用
            		continue;
            	}
            	//判断金额
            	if(!data.investCount || data.investCount < data.increaseList[i].useMoney)
            	{
            		continue;
            	}
                used = 1;
            	data.increaseList[i].used = 1;
            	if(data.increaseId == data.increaseList[i].id)
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
                if(data.increaseId == 0)
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
            alert(e);
        }
        $scope.data = data;
        $scope.$apply();

    });
    $scope.btnDone = function()
    {
    	var param = {};
    	param.increase = $scope.increase;
    	param.bouns = $scope.bouns;
    	App.platform.exec("coupons_Done",param);
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
 				$scope.bouns.used = 1;
 				$scope.bouns = item;
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

  
