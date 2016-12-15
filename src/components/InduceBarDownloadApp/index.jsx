import React , {Component, PropTypes} from 'react';
import Cookie from 'react-cookie';

export function shouldShowDownloadAppBar(){
	let result = true;
	try{
		let showTime = Cookie.load('isDownshowDate');
		if(showTime){
			result = false;
		}
	}catch(e){
		console.log('ERROR when processing shouldShow state in [InduceBarDownloadApp]:',e);
	}
	return result;
}

class InduceBarDownloadApp extends Component {
	constructor(props) {
		super(props);
		this.state = {shouldShow: shouldShowDownloadAppBar()};
	}
	componentDidMount() {
		if(this.props.setHidden){
			this.props.setHidden(!shouldShowDownloadAppBar());
		}
	}
	
	close(e){
		e.preventDefault();
		this.setState({shouldShow: false});
		try{
			Cookie.save('isDownshowDate', (new Date()).getTime(), {expires: new Date( (new Date()).getTime() + 86400000 ) });
			if(this.props.setHidden){
				this.props.setHidden(true);
			}
		}catch(e){
			console.log('ERROR when closing [InduceBarDownloadApp]:',e);
		}
	}
	download(e){
		if(e.target.tagName !== e.currentTarget.tagName) {
			e.preventDefault();
		}else{
			this.props.gotoPage('Download App');
		}
	}
	render(){
		return (
			<div id="downloadBar" className="download-bar" onClick={this.download.bind(this)}>
            	<i></i>下载APP，轻松理财 <span className="download-closed" onClick={this.close.bind(this)}></span>
    		</div>
		);
	}
}

InduceBarDownloadApp.PropTypes = {
	gotoPage: PropTypes.func.isRequired,
	setHidden: PropTypes.func.isRequired,
}

export default InduceBarDownloadApp;