import React , {Component, PropTypes} from 'react';

class Footer extends Component {
	constructor(props) {
		super(props);
		
	}
	render(){
		return (
			<header className="wx-header wx-index-head">
			    <h1 className="logo"></h1>
			    <a href="/#/users/account" className="wx-index-top-my"></a>
			</header>
		);
	}
}

export default Footer;

