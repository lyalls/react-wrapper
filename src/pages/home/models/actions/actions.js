import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch';
import path from 'path';

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
    let baseUrl = env ? env.baseUrl : "";
    const token = retrieve(TOKEN_KEY);
    let headers = (token)?{ 'X-Authorization': token }:{};
    if(env.server && env.server.host && env.server.port){
        headers.host = env.server.host;
        headers.port = env.server.port;
        if(env.server.protocal){
            baseUrl = env.server.protocal + "://" + env.server.host 
                + ( (env.server.protocal.toLowerCase() === "http" && env.server.port === 80) || (env.server.protocal.toLowerCase() === "https" && env.server.port === 443) ? "" : ":" + env.server.port) 
                + baseUrl; 
        }
    }
    if(baseUrl.length > 2 && baseUrl.substr(baseUrl.length - 1) === "/"){
        baseUrl = baseUrl.substr(0, baseUrl.length -1);
    }
    console.log('BASEURL:', baseUrl, 'HEADERS:', headers);
    return function(dispatch) {
        return fetch(`${baseUrl}/top/wechat/banners`, {mode: 'no-cors', headers: headers, method: 'get'})
            .then(response => response.json)
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
    let baseUrl = env ? env.baseUrl : "";
    const token = retrieve(TOKEN_KEY);
    let headers = (token)?{ 'X-Authorization': token }:{};
    if(env.server && env.server.host && env.server.port){
        headers.host = env.server.host;
        headers.port = env.server.port;
        if(env.server.protocal){
            baseUrl = env.server.protocal + "://" + env.server.host 
                + ( (env.server.protocal.toLowerCase() === "http" && env.server.port === 80) || (env.server.protocal.toLowerCase() === "https" && env.server.port === 443) ? "" : ":" + env.server.port) 
                + baseUrl; 
        }
    }
    if(baseUrl.length > 2 && baseUrl.substr(baseUrl.length - 1) === "/"){
        baseUrl = baseUrl.substr(0, baseUrl.length -1);
    }
    console.log('BASEURL:', baseUrl, 'HEADERS:', headers);
    return function(dispatch) {
        return fetch(`${baseUrl}/top/wechat/borrows`, {
                        mode: 'no-cors',
                        method: 'get',
                        params: {
                            from:4
                        },
                        headers: headers
            })
            .then(response => {
                console.log(response.headers());
                return response.json()
            })
            .then(json=> {
                return dispatch(receivedInvestList(json.data))
            })
            .catch( e =>{
                console.log("ERROR when get invest list for Home page:", e);
            });
    }
}