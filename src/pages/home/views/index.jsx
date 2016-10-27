import React , {Component, PropTypes} from 'react';

import Navigator from '../../../components/navigator/index.jsx';

class Home extends Component {
    constructor(props) {
        super(props);
        
    }
    componentWillMount() {
        this.props.onLoading();
    }
    render(){
        return (
            <Navigator />
        );
    }
}

Home.propTypes = {
    onLoading: PropTypes.func.isRequired
}

export default Home;