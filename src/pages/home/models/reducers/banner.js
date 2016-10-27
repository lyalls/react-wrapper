import actionTypes from '../actions/actionTypes';

export default function banner(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateBannerData:
        return Object.assign({}, state, {items: action.items, receivedAt: action.receivedAt});
    default:
        return state;
    }
}