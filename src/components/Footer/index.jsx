import React , {Component, PropTypes} from 'react';

class Footer extends Component {
	constructor(props) {
		super(props);
		
	}
	render(){
		return (
			<footer className="wx-index-bottom">
			    <ul>
					<li>
						<a onClick={this.props.gotoPage.bind(this,'aboutus')}>了解抱财</a> 
						<a onClick={this.props.gotoPage.bind(this,'Customer Service')}>在线客服</a> 
						<a onClick={this.props.gotoPage.bind(this,'Switch to PC')}>切换电脑版</a>
						<a onClick={this.props.gotoPage.bind(this,'Download App')} id="downapp">下载APP</a></li>
					<li>&copy; 2016抱财网Baocai.com 投资有风险 选择需谨慎</li>
					<li>客服电话：400-616-7070</li>
				</ul>			
    	</footer>
		);
	}
}

Footer.PropTypes = {
	gotoPage: PropTypes.func.isRequired
}

export default Footer;