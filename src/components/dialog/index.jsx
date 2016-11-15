import React, {Component, PropTypes} from 'react';

class Dialog extends Component {
	constructor(props) {
		super(props);
		
	}
	dismiss(){

		if(this.props.dismissed) this.props.dismissed();
	}
	render(){
		return(
			<div className="k_layer">
		        <div className="k_layer_txt"><p>{this.props.content}</p></div>
		        <div className="common_popup_bottom_btns">
		            <button onClick={this.dismiss} className="single_btn">
		            	{(this.props.dismissTitle === undefined)?"确定":this.props.dismissTitle}
		            </button>
		        </div>
		    </div>
		)
	}
}

Dialog.propTypes = {
	content: PropTypes.string.isRequired,
	dismissed: PropTypes.func,
	dismissTitle: PropTypes.string,
}

export default Dialog;