import actionTypes from '../actions/actionTypes';

function returnTime(data) {
    var time = data.limitTime;
    if (time <= 0) $interval.cancel(data.TimerId);
    var h = Math.floor(time/3600);
    var m = Math.floor(time%3600/60);
    var s = Math.floor(time%3600%60);
    if(h<10)
        h='0'+h;
    if(m<10)
        m='0'+m;
    if(s<10)
        s='0'+s
    return h + ':' + m + ':' + s;
}

function toReverse(number,fix) {
    //var parsePercent = Math.round(parseFloat(number));
    var parsePercent = parseFloat(number).toFixed(fix);
    return (!parsePercent ? 0 : parsePercent);
}

export default function investList(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateInvestList:
        if(!action.data) return state;

        let newState = {};
        newState.investsList = [];
        var biao_tag = {'xins':'yellow-tag','xianl':'orange-tag','bld':'purple-tag','gou':'blue-tag','rongsan':'orange-l-tag','fangchan':'yellow-l-tag','newb':'red-dark-tag'};
        var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷'};
        //根据不同的标的类型显示不同的底色图标
        var biao_typenid_bgcss ={'rongsan':'bg-06','bld':'bg-03','fangchan':'bg-05','gou':'bg-04'};
        var biao_type_zi = '';
        var biao_type_zi_bgcss = '';
        var biao_type_zi_type = '';
        var is_zhiding = false;
        if(action.data.lastTenderInfo != 'undefined' && typeof(action.data.lastTenderInfo) != 'undefined')
            newState.lastTenderInfo = action.data.lastTenderInfo;
        else
            newState.lastTenderInfo =false;

        for (var i = 0; i < action.data.tenderList.length; i++) {

            action.data.tenderList[i].annualRate = toReverse(action.data.tenderList[i].annualRate,2);
            //是否有置顶标
            if(i == 0)
            {
                is_zhiding = action.data.is_zhiding;
            }
            else
            {
                is_zhiding = false;
            }

            biao_type_zi = biao_typenid[action.data.tenderList[i].typeNid];
            biao_type_zi_bgcss = biao_typenid_bgcss[action.data.tenderList[i].typeNid];
            biao_type_zi_type = action.data.tenderList[i].typeNid;
            if(biao_type_zi == 'undefined' || typeof(biao_type_zi) == 'undefined') {
                biao_type_zi = '新项目';
                biao_type_zi_bgcss = 'bg-07';
                biao_type_zi_type ='newb';
            }

            if(action.data.tenderList[i].tenderSchedule !=100 && action.data.tenderList[i].isNew ==1)
            {
                biao_type_zi = '新手标';
                biao_type_zi_bgcss = 'bg-01';
                biao_type_zi_type = 'xins';
            }
            if(action.data.tenderList[i].isLimit == 1)
            {
                biao_type_zi = '限量标';
                biao_type_zi_bgcss = 'bg-02';
                biao_type_zi_type = 'xianl';
            }
            if (action.data.tenderList[i].isLimit == 1 && action.data.tenderList[i].limitTime > 0) {

                action.data.tenderList[i].timer = returnTime(action.data.tenderList[i]);
                (function(i) {
                    action.data.tenderList[i].TimerId = setInterval(function() {
                        action.data.tenderList[i].limitTime = (+action.data.tenderList[i].limitTime) -1;
                        action.data.tenderList[i].timer = returnTime(action.data.tenderList[i]);
                    }, 1000);
                })(i);
            }

            action.data.tenderList[i].biao_type_zi = biao_type_zi;
            action.data.tenderList[i].biao_type_zi_bgcss = biao_type_zi_bgcss;
            action.data.tenderList[i].biaotag = biao_tag[biao_type_zi_type];
            action.data.tenderList[i].is_zhiding = is_zhiding;
            newState.investsList.push(action.data.tenderList[i]);
        }

        newState.investsLen = action.data.tenderList.length;
        return Object.assign({}, state, newState);
    default:
        return state;
    }
}