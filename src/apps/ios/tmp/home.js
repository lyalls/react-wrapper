'use strict';

import React  from 'react';
import ReactDOM from 'react-dom';
import injectTapEventPlugin from 'react-tap-event-plugin';

// Needed for onTouchTap
// http://stackoverflow.com/a/34015469/988941
injectTapEventPlugin();

// Env Settings
const envSettings = {
    baseUrl: "/",
    server:{
        host: "localhost",
        port: 2999,
        protocal: "http"
    },
    platform: {
        isWechat: false,
        isIOS: true,
        isAndroid: false,
        isMobile: false
    }
};

// Components
import HomeGenerator, {getStore as homeStore} from '../../../pages/home';
import { Provider } from 'react-redux'

const Home = HomeGenerator(envSettings);

ReactDOM.render(
    <Provider store={homeStore()} >
        <div>
            <Home env={envSettings}/>
        </div>
    </Provider>
    ,
    document.getElementById('app-body')
);
