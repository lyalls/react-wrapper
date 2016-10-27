import React , {Component} from 'react';
import AppBar from 'material-ui/AppBar';

class Navigator extends Component {
    constructor(props) {
        super(props);
        
    }
    render() {
        return (
            <AppBar
                title = 'This is a navigator'
                iconClassNameRight = 'keyboard arrow left'
            />
        );
    }
}

export default Navigator;

