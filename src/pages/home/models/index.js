import { combineReducers } from 'redux';

import banner from './reducers/banner';
import investList from './reducers/investList';
import noviceItem from './reducers/noviceItem';
import intro from './reducers/intro';

export default combineReducers({
    banner,
    investList,
    noviceItem,
    intro,
});

import * as thisActions from './actions/actions.js'
export const actions = thisActions;