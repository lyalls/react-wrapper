import Home from "./views/index.jsx";
import {connect} from 'react-redux';

import homepage, {actions as homeActions} from './models';

export const actions = homeActions;
export const reducer = homepage;

// For single page usage
import thunkMiddleware from 'redux-thunk'
import createLogger from 'redux-logger'
import { createStore, applyMiddleware , compose} from 'redux'
const loggerMiddleware = createLogger();
export function getStore(...otherStores){
    return createStore(
        homepage,
        compose(
            applyMiddleware(
                thunkMiddleware, // lets us dispatch() functions
                loggerMiddleware // neat middleware that logs actions
            ),
            ...otherStores
        )
    );
}

// Generate the App Tag according to env settings
export default function(env){
    function mapStateToProps(state){
        return state || {};
    }

    function mapDispatchToProps(dispatch){
        return {
            onLoading: function(){
                env.platform.canInvokeNativeMethod() 
                ? dispatch(homeActions.GNR_HOME_getBannerData(env))
                : dispatch(homeActions.GNR_HOME_getAccountInfo(env));

                dispatch(homeActions.GNR_HOME_getInvestList(env));

            },

            // 投资详情
            getInvestDetail: function(borrowId,pname,ifnew,limitTime, ...otherArgs) {
                if(env.platform.canInvokeNativeMethod()){
                    env.platform.exec('getInvestDetail', {borrowId, pname, ifnew, limitTime});
                }else{
                    let openDialog = otherArgs && otherArgs.length > 0 ? otherArgs[otherArgs.length - 1]:null;
                    // For debugging dialog use
                    //openDialog('即将发售，敬请期待！');
                    //return;
                    let setSessionStorage = env.setSessionStorage;
                    if (arguments.length >= 4 && arguments[3] > 0) {
                        if(typeof openDialog === 'function'){
                            openDialog('即将发售，敬请期待！');
                        }
                        return; //限量标不给跳转
                    }
                    if(pname){
                        setSessionStorage('Detail_tender_plan_name',pname)
                    }
                    if(ifnew==0 || ifnew==1){
                        setSessionStorage('Detail_tender_if_new',ifnew+'');
                    }
                    setSessionStorage('Detail_borrowId', borrowId);
                    window.location.href = "/#/invest/detail";
                }
            }.bind(this),

            // 立即投资
            getTenderInfoDetail: function(borrowId) {
                if(env.platform.canInvokeNativeMethod()){
                    env.platform.exec('getTenderInfoDetail', {borrowId});
                }else{
                    let setSessionStorage = env.setSessionStorage;
                    if (arguments.length >= 2 && arguments[1] > 0) return;
                    if (borrowId) {
                        setSessionStorage('Detail_borrowId', borrowId);
                    }
                    window.location.href = "/#/invest";
                }
            }.bind(this),

            // 跳转页面
            gotoPage: function(...argments){
                env.gotoPage(...argments);
            },
        }
    }

    return connect(mapStateToProps, mapDispatchToProps)(Home);
}