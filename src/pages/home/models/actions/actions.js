import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch';
import path from 'path';

//*************************************************************************
// Check login status
function receivedAccountInfo(data){
    return {
        type: actionTypes.GNR_HOME_UpdateUserInfo,
        userInfo: data,
        receivedAt: new Date()
    }
}

export function GNR_HOME_getAccountInfo(env){
    if(env.platform.isWechat){
        return function(dispatch){
            const token = env.retrieveKey(env.keys.TOKEN);
            let baseUrl = env ? env.settings('baseUrl') : "";
            return fetch(`${baseUrl}/users`, 
                            {
                                mode: 'no-cors', 
                                method: 'get', 
                                headers: {'X-Authorization': token}
                            }
                        )
                    .then(response => {
                        return response.data;
                    })
                    .then(data =>{
                        dispatch(receivedAccountInfo(data));
                        return dispatch(GNR_HOME_getBannerData(env, true));
                    })
                    .catch( error =>{
                        return dispatch(GNR_HOME_getBannerData(env));
                        console.log("ERROR: ", error);
                    });

        }
    }
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
// Received Introduction infomation in Homepage
function receivedIntroInfo(data){
    return {
        type: actionTypes.GNR_HOME_UpdateIntroInfo,
        data: data,
        receivedAt: new Date()
    }   
}
// Get Homepage Banner Data
export function GNR_HOME_getBannerData(env, isLogin){
    if(env.platform.canInvokeNativeMethod()){
        return function(dispatch){
            let localBannerVersion = null;
            return env.platform.exec('getLocalData', 'banner')
                        .then(localBannerInfo =>{
                            console.log('Local banner info:', localBannerInfo);        
                            dispatch(receivedBannerData(localBannerInfo.homeBannerList));
                            dispatch(receivedIntroInfo(localBannerInfo.introduceUrl));
                            return env.platform.exec('getLocalDataVersion', 'banner'); 
                        })
                        .then(version =>{
                            console.log('Local banner version:', version);
                            let params = {bannerVersion: ''+ version};
                            localBannerVersion = version;
                            return env.platform.requestAPI('/top/banners', params);
                        })
                        .then(remoteBannerInfo =>{
                            console.log('Got remote banner info:', remoteBannerInfo);
                            if(remoteBannerInfo.bannerVersion && remoteBannerInfo.bannerVersion != localBannerVersion){
                                console.log('Remote banner version:', remoteBannerInfo.bannerVersion, ', local banner version:', localBannerVersion);
                                dispatch(receivedBannerData(remoteBannerInfo.homeBannerList));
                                dispatch(receivedIntroInfo(remoteBannerInfo.introduceUrl));
                                return env.platform.exec('setLocalDataVersion', {name: 'banner', version: remoteBannerInfo.bannerVersion})
                                        .then(success => {
                                                if(Number(success)){
                                                    return exec.platform.exec('setLocalData', {
                                                        name: 'banner',
                                                        data: remoteBannerInfo
                                                    });
                                                }else{
                                                    throw new Error('ERROR: failed to set local data version for banner');
                                                }
                                        })
                            }
                        })
                        .catch(function(error){
                            console.log(error);
                        })
        }
    }else{
        let baseUrl = env ? env.settings('baseUrl') : "";
        let url = `${baseUrl}/top/wechat/nologin/banners`;
        if(isLogin) url = `${baseUrl}/top/wechat/banners`;
        return function(dispatch) {
            return fetch(url, {mode: 'no-cors'})
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
// Received Data of Novice item in Homepage
function receivedNoviceItem(data){
    return {
        type: actionTypes.GNR_HOME_UpdateNoviceItem,
        data: data,
        receivedAt: new Date()
    }
}
// Update invest item counting time
export function GNR_HOME_updateInvestItem(item, index){
    return {
        type: actionTypes.GNR_HOME_UpdateInvestItem,
        data: item,
        index: index
    }
}
// Get invest list
export function GNR_HOME_getInvestList(env){
    if(env.platform.canInvokeNativeMethod()){
        return function(dispatch){
            return env.platform.requestAPI('top/borrow/manage/list')
                                .then(function(data){
                                    if(data && data.tenderList && data.tenderList.length > 1){
                                        // dispatch(receivedNoviceItem(data.tenderList.slice(0,1)));
                                        // data.tenderList.splice(0,1);
                                        dispatch(receivedInvestList(data));
                                    }else{
                                        throw new Error('ERROR: tender list returned from native api is empty:', data);
                                    }
                                })
                                .catch(function(error){
                                    console.log(error);
                                });
        }
    }else{
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
}