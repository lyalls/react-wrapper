import actionTypes from '../actions/actionTypes';

export default function userInfo(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateUserInfo:
        return Object.assign({}, state, {user: action.userInfo, receivedAt: action.receivedAt});
    default:
        return state;
    }
}