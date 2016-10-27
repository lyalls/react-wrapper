import { combineReducers } from 'redux';

import banner from './reducers/banner';

export default combineReducers({
    banner
});

import * as thisActions from './actions/actions.js'
export const actions = thisActions;