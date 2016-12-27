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
				? 	<div className="scrollable" id="content">
				        <div className="scrollable-content" id="mContent">	
					        <PullToRefresh onRefresh={this.onRefresh.bind(this)} className="react-pull-to-refresh" style={{textAlign: 'center'}}>
								<div id="ptr">
									<span class="genericon genericon-next"></span>
									<div class="loading">
									    <span id="l1">ABCDEFG</span>
									    <span id="l2">HIGJLMK</span>
									    <span id="l3">OPQ RST</span>
								  	</div>
								</div>
								
								{this.props.children}

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