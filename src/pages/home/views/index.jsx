import React , {Component, PropTypes} from 'react';

import Navigator from '../../../components/navigator/index.jsx';

class Home extends Component {
    constructor(props) {
        super(props);
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentWillUpdate(nextProps, nextState) { 
    }
    render(){
        return (
            <Navigator 
                title={ (this.props.banner.items ? this.props.banner.items.length : 0 ) + " Banners"}
            />
        );
    }
}

Home.propTypes = {
    onLoading: PropTypes.func.isRequired
}

export default Home;