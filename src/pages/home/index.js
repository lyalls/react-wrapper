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
                return dispatch(homeActions.GNR_HOME_getBannerData(env));
            }
        }
    }

    return connect(mapStateToProps, mapDispatchToProps)(Home);
}