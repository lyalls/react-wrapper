import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class Footer extends Component {
	constructor(props) {
		super(props);
		
	}
	render(){
		return (
			<BaseComponent>
				<header className="wx-header wx-index-head">
				    <h1 className="logo"></h1>
				    <a href="/users/account" className="wx-index-top-my"></a>
				</header>
			</BaseComponent>
		);
	}
}

export default Footer;

