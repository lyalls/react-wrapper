import actionTypes from './actionTypes';
import fetch from 'isomorphic-fetch'

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
                console.log("ERROR:", e);
            });
    }
}