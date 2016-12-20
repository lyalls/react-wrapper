import CouponsPage from "./views/index.jsx";
import {connect} from 'react-redux';

import coupons, {actions as homeActions} from './models';

export const actions = homeActions;
export const reducer = coupons;

// For single page usage
import thunkMiddleware from 'redux-thunk'
import createLogger from 'redux-logger'
import { createStore, applyMiddleware , compose} from 'redux'
const loggerMiddleware = createLogger();
export function getStore(...otherStores){
    return createStore(
        coupons,
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
            },

            // 跳转页面
            gotoPage: function(...argments){
                env.gotoPage(...argments);
            },
        }
    }

    return connect(mapStateToProps, mapDispatchToProps)(CouponsPage);
}