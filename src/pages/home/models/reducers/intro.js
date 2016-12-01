import actionTypes from '../actions/actionTypes';

export default function introInfo(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateIntroInfo:
        return Object.assign({}, state, {url: action.data, receivedAt: action.receivedAt});
    default:
        return state;
    }
}