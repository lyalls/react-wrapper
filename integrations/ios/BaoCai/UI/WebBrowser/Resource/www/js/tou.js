var App = {};
    function check(boolstr)
    {
        if(typeof(boolstr) === "string")
        {
            if(boolstr.toLowerCase() == "true")
            {
                return true;
            }
            else

            {
                return false;
            }

        }
        else
        {
            return boolstr;
        }

    }
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
App.investing =
{

    init:function(projectinfo,bonuslist,increaselist)
    {
        this.proj =  {};
        this.proj.isAllowIncrease = check(projectinfo.isAllowIncrease);
        this.proj.isBonusticket = check(projectinfo.isBonusticket);
        this.proj.isFirstTender = check(projectinfo.isFirstTender);
        this.proj.investmentHorizon = transInvestmentHorizon(projectinfo.investmentHorizon);
        if(bonuslist)
            this.bonuslist =  bonuslist;
        else
            this.bonuslist = [];
        if(increaselist)
            this.increaselist = increaselist;
        else
            this.increaselist = [];
    },
    test:function()
    {
        return JSON.stringify(this.proj);
    },
    showBonus:function(numCount)
    {
        numCount = numCount*1;
        var res = {};
        //允许使用加息券
        var incId = null;
        var curDD = 0;
        var endDD = '';
        try{
        if(this.proj.isAllowIncrease)
        {
            for(var i = 0;i<this.increaselist.length;i++)
            {
                //判断时间是否可用
                var curdate = new Date();
                var startdate = new Date(this.increaselist[i].starttime*1000);
                var enddate = new Date(this.increaselist[i].endtime*1000);
                if(curdate <startdate || curdate > enddate)
                {
                    //不可用   
                    continue;
                }
                //判断金额
                if(numCount < this.increaselist[i].useMoney*1)
                {
                    continue;
                }

                if(curDD < this.increaselist[i].apr*1)
                {
                    curDD = this.increaselist[i].apr;
                    incId = this.increaselist[i].id;
                    endDD = this.increaselist[i].endtime
                }
                else if(curDD == this.increaselist[i].apr*1)
                {
                    //相等选择有效期短的
                    if(endDD > this.increaselist[i].endtime)
                    {
                        curDD = this.increaselist[i].apr*1;
                        incId = this.increaselist[i].id;
                        endDD = this.increaselist[i].endtime
                    }
                }
            }
        }
        App.investing.increaseId = incId;
         res.increaseId = incId;
         incId = null;
         curDD = 0;
         endDD = '';
        //选择红包券
        if(this.proj.isBonusticket)
        {
            for(var i=0;i<this.bonuslist.length;i++)
            {
                //检查是否首投
                if(this.bonuslist[i].catName == "E" || this.bonuslist[i].catName == "F")
                {
                    if(!this.proj.isFirstTender)
                    {
                        continue;
                    }
                }
                //检查期数
                if(this.bonuslist[i].borrowPeriod == 1 && this.proj.investmentHorizon != 1)
                {
                    continue;
                }
                else if(this.bonuslist[i].borrowPeriod == 2 && this.proj.investmentHorizon >3)
                {
                    continue;
                }
                else if(this.bonuslist[i].borrowPeriod == 3 && this.proj.investmentHorizon <3)
                {
                    continue;
                }
                else if(this.bonuslist[i].borrowPeriod == 4 && this.proj.investmentHorizon <6)
                {
                    continue;
                }
                
                //金额检查
                if(numCount*1 < this.bonuslist[i].useMoney*1)
                {
                    continue;
                }
                //检查结束时间
                if(new Date(this.bonuslist[i].expiredTime*1000) <  new Date())
                {
                    continue;
                }

                if(curDD*1 < this.bonuslist[i].money*1)
                {
                    curDD = this.bonuslist[i].money*1;
                    incId = this.bonuslist[i].id;
                    endDD = this.bonuslist[i].expiredTime
                }
                else if(curDD*1 == this.bonuslist[i].money*1)
                {
                    //相等选择有效期短的
                    if(endDD > this.bonuslist[i].expiredTime)
                    {
                        curDD = this.bonuslist[i].money*1;
                        incId = this.bonuslist[i].id;
                        endDD = this.bonuslist[i].expiredTime
                    }
                }


            }

        }
            App.investing.bonusId = incId;
            res.bonusId = incId;
        }
        catch(e)
        {
            res={};
        }

        //调用安卓系统
        if(window.baocaijs && window.baocaijs.call)
        {
            var msg = {};
            msg.bonusId = incId?incId:"";
            msg.increaseId = App.investing.increaseId?App.investing.increaseId:"";
            setTimeout(function()
            {
               window.baocaijs.call(JSON.stringify(msg));
            },0);

        }
        else
        {
            return JSON.stringify(res);
        }
    }
}
