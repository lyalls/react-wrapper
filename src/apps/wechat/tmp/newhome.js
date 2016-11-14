'use strict';

import React  from 'react';
import ReactDOM from 'react-dom';
import injectTapEventPlugin from 'react-tap-event-plugin';

// Needed for onTouchTap
// http://stackoverflow.com/a/34015469/988941
injectTapEventPlugin();

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import * as mui from 'material-ui';

// Setup material-ui styles
import {deepOrange300, deepOrange500, grey100, 
    grey300, grey400, grey500, white, darkBlack, 
    fullBlack, lightBlue200, pinkA200} from 'material-ui/styles/colors';
import {fade} from 'material-ui/utils/colorManipulator';
import spacing from 'material-ui/styles/spacing';
const AppStyles = getMuiTheme({
    spacing: spacing,
    fontFamily: 'Roboto, sans-serif',
    palette: {
        primary1Color: deepOrange300,
        primary2Color: deepOrange500,
        primary3Color: grey400,
        accent1Color: pinkA200,
        accent2Color: grey100,
        accent3Color: grey500,
        textColor: darkBlack,
        alternateTextColor: white,
        canvasColor: white,
        borderColor: grey300,
        disabledColor: fade(darkBlack, 0.3),
        pickerHeaderColor: lightBlue200,
        clockCircleColor: fade(darkBlack, 0.07),
        shadowColor: fullBlack,
    },
    appBar: {
        height: 30,
        marginTop: 10
    },
});


// Env Settings
const envSettings = {
    // baseUrl: "http://m224.baocai.com"
    parseValue: function(val){
        if(!val || val.length == 0) return "";
    }
};

// Components
import HomeGenerator, {getStore as homeStore} from '../../../pages/home';
import { Provider } from 'react-redux'

const Home = HomeGenerator(envSettings);

ReactDOM.render(
    <Provider store={homeStore()} >
        <div>
            <MuiThemeProvider muiTheme={AppStyles}>
                <Home />
            </MuiThemeProvider>
        </div>
    </Provider>
    ,
    document.getElementById('app-body')
);
