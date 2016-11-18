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
        this.proj.investmentHorizon = transInvestmentHorizon(projectinfo.investmentHorizon);
        this.proj.annualRate = projectinfo.annualRate;
        this.proj.increaseApr = projectinfo.increaseApr;
        this.proj.typeNid = projectinfo.typeNid;
        this.proj.isBonusticket = check(projectinfo.isBonusticket);
        this.proj.isAllowIncrease = check(projectinfo.isAllowIncrease);
        this.proj.isReward = check(projectinfo.isReward);
        this.proj.rewardRatio = projectinfo.rewardRatio;
        this.proj.isFeedback = check(projectinfo.isFeedback);
        this.proj.userFeedBack = projectinfo.userFeedBack;
        this.proj.isFirstTender = check(projectinfo.isFirstTender);
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
    },
    showIncome:function(numCount,bonusId,increaseId)
    {
        numCount = numCount * 1;
        var res = {};
        var income = Number(0);
        var gainCalcDesc = ["投资本金：" + numCount.toFixed(2) + "元"];
        try {
            //利息
            if (Number(this.proj.annualRate)) {
                var interest = 0;
                interest = numCount * (this.proj.annualRate / 100) * (this.proj.investmentHorizon / 12);
                interest = interest.toFixed(2);
                income += Number(interest);
                gainCalcDesc = gainCalcDesc.concat("可得利息：" + interest + "元");
            }
            //标的贴息
            if (Number(this.proj.increaseApr)) {
                var discount = 0;
                discount = numCount * (this.proj.increaseApr / 100) * (this.proj.investmentHorizon / 12);
                discount = discount.toFixed(2);
                income += Number(discount);
                gainCalcDesc = gainCalcDesc.concat("可得标的贴息：" + discount + "元");
            }
            //老用户回馈
            if (this.proj.isFeedback && !this.proj.isFirstTender) {
                for (var i = 0; i < this.proj.userFeedBack.length; i++) {
                    if (this.proj.userFeedBack[i].minAmount <= numCount && this.proj.userFeedBack[i].maxAmount >= numCount) {
                        var feedbackIncome = 0;
                        feedbackIncome = numCount * (this.proj.userFeedBack[i].ratio / 100);
                        feedbackIncome = feedbackIncome.toFixed(2);
                        income += Number(feedbackIncome);
                        gainCalcDesc = gainCalcDesc.concat("老用户回馈奖励：" + feedbackIncome + "元");
                        break;
                    }
                }
            }
            //投资额奖励
            if (this.proj.isReward) {
                var rewardIncome = 0;
                rewardIncome = numCount * (this.proj.rewardRatio / 100);
                rewardIncome = rewardIncome.toFixed(2);
                income += Number(rewardIncome);
                gainCalcDesc = gainCalcDesc.concat("投资额奖励(抢)：" + rewardIncome + "元");
            }
            //红包券
            if (bonusId) {
                for (var i = 0; i < this.bonuslist.length; i++) {
                    if (this.bonuslist[i].id == bonusId) {
                        var bonusIncome = 0;
                        bonusIncome = this.bonuslist[i].money * 1;
                        bonusIncome = bonusIncome.toFixed(2);
                        income += Number(bonusIncome);
                        gainCalcDesc = gainCalcDesc.concat("红包券奖励：" + bonusIncome + "元");
                        break;
                    }
                }
            }
            //加息券
            if (increaseId) {
                for (var i = 0; i < this.increaselist.length; i++) {
                    if (this.increaselist[i].id == increaseId) {
                        var increaseIncome = 0;
                        increaseIncome = numCount * (this.increaselist[i].apr / 100) * (this.proj.investmentHorizon / 12);
                        increaseIncome = increaseIncome.toFixed(2);
                        income += Number(increaseIncome);
                        gainCalcDesc = gainCalcDesc.concat("加息券奖励：" + increaseIncome + "元");
                        break;
                    }
                }
            }
        } catch(e) {
            
        }
        res.income = income.toFixed(2);
        res.gainCalcDesc = gainCalcDesc;
        //安卓系统
        if (window.baocaijs && window.baocaijs.callIncome) {
            setTimeout(function() {
                       window.baocaijs.callIncome(JSON.stringify(res));
                       }, 0);
        } else {
            return JSON.stringify(res);
        }
    }
}
