import React , {Component, PropTypes} from 'react';

class Footer extends Component {
	constructor(props) {
		super(props);
		
	}
	render(){
		return (
			<footer className="wx-index-bottom">
			    <ul>
			        <li><a href="http://a.app.qq.com/o/simple.jsp?pkgname=com.baocai.p2p">APP下载</a> <a href="tel:4006167070">客服电话</a></li>
			        <li>&copy; 2016抱财网Baocai.com 投资有风险 选择需谨慎</li>
			    </ul>
			</footer>
		);
	}
}

export default Footer;