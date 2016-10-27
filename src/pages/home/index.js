import Home from "./views/index.jsx";
import {connect} from 'react-redux';

import homepage, {actions as homeActions} from './models';


// Generate the App Tag according to env settings
export default function(env){
    function mapStateToProps(state){
        return {
            homepage: state.homepage || {}
        }
    }

    function mapDispatchToProps(dispatch){
        return {
            onLoading: function(){
                dispatch(homeActions.GNR_HOME_getBannerData(env));
            }
        }
    }

    return connect(mapStateToProps, mapDispatchToProps)(Home);
}
export const actions = actions;
export const reducer = homepage;

// For single page usage
import thunkMiddleware from 'redux-thunk'
import createLogger from 'redux-logger'
import { createStore as createReduxStore, applyMiddleware } from 'redux'
const loggerMiddleware = createLogger();
export function createStore(){
    return createReduxStore(
        homepage,
        applyMiddleware(
            thunkMiddleware, // lets us dispatch() functions
            loggerMiddleware // neat middleware that logs actions
        )
    );
}