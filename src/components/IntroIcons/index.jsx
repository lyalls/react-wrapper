import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class IntroIcons extends Component {
    constructor(props) {
        super(props);
    }
    render(){
    	return(
            <BaseComponent className={"index-enter-area"} onClick={this.props.onClick}>
            <ul className="index-enter-item un-login">
                <li>
                    <i className="index-enter-icon-1"></i>
                    <h3>上市系</h3>
                    <p>A股上市公司战略投资</p>
                </li>
                <li>
                    <i className="index-enter-icon-2"></i>
                    <h3>首批会员</h3>
                    <p>中国互联网金融协会</p>
                </li>
                <li>
                    <i className="index-enter-icon-3"></i>
                    <h3>风险准备金</h3>
                    <p>浦发银行托管</p>
                </li>
            </ul>
            </BaseComponent>
    	)
    }
}

IntroIcons.PropTypes = {
    onClick: PropTypes.func
}

export default IntroIcons;