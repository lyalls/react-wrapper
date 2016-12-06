import { combineReducers } from 'redux';

import banner from './reducers/banner';
import investList from './reducers/investList';
import intro from './reducers/intro';

export default combineReducers({
    banner,
    investList,
    intro,
});

import * as thisActions from './actions/actions.js'
export const actions = thisActions;