import actionTypes from '../actions/actionTypes';

export default function noviceItem(state = {}, action){
    switch(action.type){
    case actionTypes.GNR_HOME_UpdateNoviceItem:
        return Object.assign({}, state, {item: action.data, receivedAt: action.receivedAt});
    default:
        return state;
    }
}