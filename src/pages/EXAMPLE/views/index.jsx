import React , {Component, PropTypes} from 'react';
import $ from 'jquery';
import BaseComponent from '../../../components/BaseComponent/index.jsx';
import {OpenDialog} from '../../../components/Dialog/index.jsx';


class CouponsPage extends Component {
    constructor(props) {
        super(props);
        // Init state
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentWillReceiveProps(nextProps) {
    }
    componentDidMount() {
        
    }
    componentWillUnmount() {
        
    }

    render(){
        return (
            <div>
            </div>
        );
    }
}

Home.propTypes = {
    env: PropTypes.object.isRequired,
    onLoading: PropTypes.func.isRequired,
    gotoPage: PropTypes.func,
}

export default CouponsPage;