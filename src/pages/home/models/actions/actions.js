import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch';
import path from 'path';


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
    if(App && App.platform && typeof App.platform.exec === 'function' && env && env.platform && (env.platform.isIOS || env.platform.isAndroid)){
        return function(dispatch){
            return new Promise(function(resolve, reject){
                App.platform.exec('getLocalDataVersion', 'banner', function(res){
                    if(res){
                        console.log('Local banner version:', res);
                        let params = {bannerVersion: ''+ res};
                        let api = "https://mapi.baocai.com/v2/top/banners";
                        params['_api_'] = api;
                        App.platform.exec('requestAPI', params, function(res){
                            if(typeof res === 'object'){
                                if(res.error){
                                    let err = `api[${api}] respond error: ${res.error}`;
                                    console.log('ERROR:', err);
                                    reject(err);
                                }else{
                                    
                                    console.log(`api[${api}] response:`, res.data)
                                    dispatch(receivedBannerData(res.data));
                                    resolve(res.data);
                                }
                            }else{
                                let err = `Response of api[${api}] is illegal: ${res}`;
                                console.log('ERROR:', err);
                                reject(err)
                            }
                        });
                    }else{
                        let err = "Can't get local banner version";
                        console.log('ERROR:', err);
                        reject(err);
                    }
                });
            });
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