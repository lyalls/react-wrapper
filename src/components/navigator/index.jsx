import React , {Component, PropTypes} from 'react';
import AppBar from 'material-ui/AppBar';

class Navigator extends Component {
    constructor(props) {
        super(props);
        console.log('Navigator props:', this.props);      
    }
    render() {
        return (
            <AppBar
                title = {this.props.title}
                iconClassNameRight = 'keyboard arrow left'
            />
        );
    }
}

Navigator.propTypes = {
   title: PropTypes.string
}

export default Navigator;

