import actionTypes from '../actions/actionTypes';

// Start: timestamp in milliseconds
// Limit: time interval in milliseconds
function formatTime(start, limit) {

    var time =  Math.floor((limit - ((new Date()).getTime() - start)) / 1000);

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

function investItem(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateInvestItem:
        var biao_tag = {'xins':'yellow-tag','xianl':'orange-tag','bld':'purple-tag','gou':'blue-tag','rongsan':'orange-l-tag','fangchan':'yellow-l-tag','newb':'red-dark-tag'};
        var biao_typenid ={'rongsan':'融三板','bld':'保理贷','fangchan':'房抵贷','gou':'担保贷'};
        //根据不同的标的类型显示不同的底色图标
        var biao_typenid_bgcss ={'rongsan':'bg-06','bld':'bg-03','fangchan':'bg-05','gou':'bg-04'};
        var biao_type_zi = '';
        var biao_type_zi_bgcss = '';
        var biao_type_zi_type = '';

        action.data.annualRate = toReverse(action.data.annualRate,2);

        biao_type_zi = biao_typenid[action.data.typeNid];
        biao_type_zi_bgcss = biao_typenid_bgcss[action.data.typeNid];
        biao_type_zi_type = action.data.typeNid;
        if(biao_type_zi == 'undefined' || typeof(biao_type_zi) == 'undefined') {
            biao_type_zi = '新项目';
            biao_type_zi_bgcss = 'bg-07';
            biao_type_zi_type ='newb';
        }

        if(action.data.tenderSchedule !=100 && action.data.isNew ==1)
        {
            biao_type_zi = '新手标';
            biao_type_zi_bgcss = 'bg-01';
            biao_type_zi_type = 'xins';
        }
        if(action.data.isLimit == 1)
        {
            biao_type_zi = '限量标';
            biao_type_zi_bgcss = 'bg-02';
            biao_type_zi_type = 'xianl';
        }
        action.data.isLimit = 1;
        action.data.limitTime = Math.round(Math.random() * 10);
        if (action.data.isLimit == 1 && action.data.limitTime > 0) {

            // action.data.timer = formatTime(action.data);
            // (function(i) {
            //     action.data.TimerId = setInterval(function() {
            //         action.data.limitTime = (+action.data.limitTime) -1;
            //         action.data.timer = formatTime(action.data);
            //     }, 1000);
            // })(action.index);
            action.data.timer = {
                start: (new Date()).getTime(),
                limit: action.data.limitTime * 1000,
                formater: formatTime
            }
        }

        action.data.biao_type_zi = biao_type_zi;
        action.data.biao_type_zi_bgcss = biao_type_zi_bgcss;
        action.data.biaotag = biao_tag[biao_type_zi_type];

        return Object.assign({}, state, action.data);
        break;
    default:
        return state;
        break;
    }
}

export default function investList(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateInvestList:
        if(!action.data) return state;

        let newState = {};

        if(action.data.lastTenderInfo != 'undefined' && typeof(action.data.lastTenderInfo) != 'undefined')
            newState.lastTenderInfo = action.data.lastTenderInfo;
        else
            newState.lastTenderInfo =false;

        newState.items = action.data.tenderList.map( (item, i) => {
                                return investItem({}, {
                                    type: actionTypes.GNR_HOME_UpdateInvestItem,
                                    data: item,
                                    index: i
                                })
                            });

        newState.investsLen = action.data.tenderList.length;
        return Object.assign({}, state, newState);
    default:
        return state;
    }
}