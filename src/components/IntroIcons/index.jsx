import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class IntroIcons extends Component {
    constructor(props) {
        super(props);
    }
    gotoIntroPage(){
        console.log('using local intro page function')
        this.props.gotoPage.call(this, 'aboutus', {url: this.props.introPageUrl})
    }
    render(){
    	return(
            <BaseComponent className={"index-enter-area"} >
            {
                this.props.isLogin && !this.env.platform.canInvokeNativeMethod()
                ?<ul className="index-enter-item" >
                    <li onClick={this.props.gotoPage.bind(this, 'My Assets')}>
                        <i className="index-enter-icon-1"></i>
                        <h3 id="home-my-property" onClick={_hmt.push.bind(_hmt, ['_trackEvent', '我的资产', 'click'])}>我的资产</h3>
                    </li>
                    <li onClick={this.props.gotoPage.bind(this, 'My Coupon')}>
                        <i className="index-enter-icon-2"></i>
                        <h3 id="home-my-coupon" onClick={_hmt.push.bind(_hmt, ['_trackEvent', '我的优惠券', 'click'])}>我的优惠券</h3>
                    </li>
                    <li onClick={this.props.gotoPage.bind(this, 'Discovery')}>
                        <i className="index-enter-icon-3"></i>
                        <h3 id="home-find" onClick={_hmt.push.bind(_hmt, ['_trackEvent', '发现', 'click'])}>发现</h3>
                    </li>
                </ul>
                :<ul className="index-enter-item un-login" onClick={this.gotoIntroPage.bind(this)}>
                    <li >
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
            }
            </BaseComponent>
    	)
    }
}

IntroIcons.PropTypes = {
    isLogin: PropTypes.bool,
    gotoPage: PropTypes.func,
    env: PropTypes.object,
    introPageUrl: PropTypes.string,
}

export default IntroIcons;