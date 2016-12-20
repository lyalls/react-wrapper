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