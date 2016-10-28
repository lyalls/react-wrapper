import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch'

let sessionStorage = window.sessionStorage || {},
    TOKEN_KEY = 'X-Authorization',
    USER_KEY = 'm.baoca.user',
    ACCOUNT_KEY = 'm.baocai.user.mybaocai',
    BORROW_ID = 'm.baocai.invest.id',
    NO_AGREE = 'm.baocai.payment.noAgree';

// (containsKey(TOKEN_KEY)) ? retrieve(TOKEN_KEY) : null;

function retrieve(key) {
    let value = null; 
    try {
        value = JSON.parse(sessionStorage[key]);
    } catch (e) {
        console.log(`ERROR when parsing session value for key[${key}]:`,e);
    }
    return value;
}

//*************************************************************************
// Received Data of Banner in Homepage
function receivedBannerData(data){
    return {
        type: actionTypes.GNR_HOME_UpdateBannerData,
        items: data,
        receivedAt: new Date()
    }
}
// Get Homepage Banner Data
export function GNR_HOME_getBannerData(env){
    const baseUrl = env ? env.parseValue(env.baseUrl) : "";
    return function(dispatch) {
        return fetch(`${baseUrl}/top/wechat/banners`, {mode: 'no-cors'})
            .then(response => response.json())
            .then(json=> {
                return dispatch(receivedBannerData(json.data))
            })
            .catch( e =>{
                console.log("ERROR when get banner data for Home page:", e);
            });
    }
}

//*************************************************************************
// Received Data of Banner in Homepage
function receivedInvestList(data){
    return {
        type: actionTypes.GNR_HOME_UpdateInvestList,
        data: data,
        receivedAt: new Date()
    }
}
// getTopInverstsList
export function GNR_HOME_getInvestList(env){
    const baseUrl = env ? env.parseValue(env.baseUrl) : "";
    return function(dispatch) {
        return fetch(`${baseUrl}/top/wechat/borrows`, {
                        mode: 'no-cors',
                        method: 'get',
                        params: {
                            from:4
                        },
                        headers: {
                            'X-Authorization': retrieve(TOKEN_KEY)
                        }
            })
            .then(response => response.json())
            .then(json=> {
                return dispatch(receivedInvestList(json.data))
            })
            .catch( e =>{
                console.log("ERROR when get invest list for Home page:", e);
            });
    }
}