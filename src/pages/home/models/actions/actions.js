import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch';
import path from 'path';

// Promise of App.platform.exec

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
    let baseUrl = env ? env.settings('baseUrl') : "";
    if(env.platform.canInvokeNativeMethod){
        return function(dispatch){
            return env.platform.exec('getLocalData', 'banner')
                        .then(localBannerInfo =>{
                            console.log('Local banner info:', localBannerInfo);
                            return env.platform.exec('getLocalDataVersion', 'banner');         
                        })
                        .then(version =>{
                            console.log('Local banner version:', version);
                            let params = {bannerVersion: ''+ version};
                            return env.platform.requestAPI('/top/banners', params);
                        })
                        .then(remoteBannerInfo =>{
                            console.log('Got remote banner info:', remoteBannerInfo);
                        })
                        .catch(function(error){
                            console.log(error);
                        })
        }
    }else{
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
    let baseUrl = env ? env.settings('baseUrl') : "";
    let headers = env ? env.settings('headers') : {};
    return function(dispatch) {
        return fetch(`${baseUrl}/top/wechat/borrows`, {
                        mode: 'no-cors',
                        method: 'get',
                        params: {
                            from:4
                        },
                        headers: headers
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