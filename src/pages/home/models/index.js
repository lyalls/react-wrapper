import { combineReducers } from 'redux';

import banner from './reducers/banner';
import investList from './reducers/investList';

export default combineReducers({
    banner,
    investList
});

import * as thisActions from './actions/actions.js'
export const actions = thisActions;