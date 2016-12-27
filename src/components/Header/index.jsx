import React , {Component, PropTypes} from 'react';
import $ from 'jquery';

class Header extends Component {
	constructor(props) {
		super(props);
		
	}
	componentDidMount() {
		$('#content-for-m-header').attr('ui-content-for', 'm-header');
		$('#registerButtonInHeader').attr('onclick', "_hmt.push(['_trackEvent', '注册', 'click'])");
		$('#loginButtonInHeader').attr('onclick', "_hmt.push(['_trackEvent', '登录', 'click'])");
		$('#home-users_accout').attr('onclick', "_hmt.push(['_trackEvent', '我的账户', 'click']");
	}
	gotoPage(name, params){
		console.log('Goto page:', name);
		this.gotoPage(name);
	}
	render(){
		return (
			<div id="content-for-m-header">
			<header className="wx-header wx-index-head">
			    <h1 className="logo"></h1>
			    {
			    	this.props.isLogin
			    	?	<a href='/#/users/account' className="wx-index-top-acc my-account-button-in-header" id="home-users_accout"><i></i>我的</a>
			    	: 	<div className="un-login-area">
			    			<a id="registerButtonInHeader" href="#/reg">注册</a>
			    			<a id="loginButtonInHeader" href="#/login">登录</a> 
			    		</div>
			    }
			</header>
			</div>
		);
	}
}

Header.PropTypes = {
	isLogin : PropTypes.bool.isRequired,
	gotoPage: PropTypes.func.isRequired,
	env: PropTypes.object.isRequired,
}

export default Header;

