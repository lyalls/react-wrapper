import React, {Component, PropTypes} from 'react';
import PullToRefresh from 'react-pull-to-refresh';
import BaseComponent from '../BaseComponent/index.jsx';
import InduceBarDownloadApp, {shouldShowDownloadAppBar} from '../InduceBarDownloadApp/index.jsx';

class ScrollablePageWrapper extends Component {
	constructor(props) {
		super(props);
		this.state = {isDownloadAppBarHidden: !shouldShowDownloadAppBar()}
	}

	onRefresh(resolve, reject){
		console.log('Going to refresh')
		setTimeout(function(){
			console.log('Refreshed');
			resolve();
		}, 1000)
	}
	// Download App Bar
    setDownloadAppBarHidden(shouldHide){
        this.setState({isDownloadAppBarHidden: shouldHide});
    }
	render(){
		let page = (this.props.env && this.props.env.platform && this.props.env.platform.canInvokeNativeMethod()) 
				? 	<div className="scrollable">
				        <div className="scrollable-content" id="mContent">	
					        <PullToRefresh onRefresh={this.onRefresh.bind(this)} className="react-pull-to-refresh scrollable" style={{textAlign: 'center'}}>
					        	<div className="scrollable-content">
									<div id="refresh-ptr">
										<span class="genericon genericon-next"></span>
										<div class="refresh-loading">
										    <span id="refresh-l1">ABCDEFG</span>
										    <span id="refresh-l2">HIGJLMK</span>
										    <span id="refresh-l3">OPQ RST</span>
									  	</div>
									</div>
									<div id="refresh-content">
									{this.props.children}
									</div>
								</div>
				  			</PullToRefresh>
					  	</div>
					</div>
				: <div className="scrollable">
			        <div className={ (this.state.isDownloadAppBarHidden ? "" : 'index-btm-padding ') + "scrollable-content"} id="mContent">
			        	{this.props.children}
			         </div>
			            {
			                this.props.env.platform.canInvokeNativeMethod() 
			                ? null 
			                : this.state.isDownloadAppBarHidden 
			                    ? null
			                    : <InduceBarDownloadApp gotoPage={this.props.gotoPage} setHidden={this.setDownloadAppBarHidden.bind(this)}/> 
			            }
		          </div>
	
		return page ;
	}
}

ScrollablePageWrapper.PropTypes = {
	env: PropTypes.object,
	gotoPage: PropTypes.func,
}

export default ScrollablePageWrapper;