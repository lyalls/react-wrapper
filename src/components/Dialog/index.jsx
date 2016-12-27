import React, {Component, PropTypes} from 'react';
import { Modal,ModalManager,Effect} from 'react-dynamic-modal';

class Dialog extends Component {
	constructor(props) {
		super(props);
		
	}
	dismiss(){
		if(this.props.dismiss) this.props.dismiss();
		ModalManager.close();
	}

	// Dialog
    afterOpenModal() {
    	console.log('Dialog modal is open');
    }



	render(){
		return(
			<Modal 
                effect={Effect.SuperScaled}
                onRequestClose={this.dismiss.bind(this)}
                onAfterOpen={this.afterOpenModal}
                contentLabel="Dialog Modal"
                style={{content : {
                    
                }}}
            >
                <div className="k_layer">
                    <div className="k_layer_txt"><p>{this.props.content}</p></div>
                    <div className="common_popup_bottom_btns">
                        <button onClick={this.dismiss.bind(this)} className="single_btn">
                        {  
                        	this.props.dismissTitle || '确定'
                        }
                        </button>
                    </div>
                </div>
            </Modal>
		)
	}
}

Dialog.propTypes = {
	content: PropTypes.string,
	dismiss: PropTypes.func,
	dismissTitle: PropTypes.string,
}

export default Dialog;
export function OpenDialog({content, dismiss, dismissTitle}){

	let dialog = <Dialog 
        content = {content || ""}
        dismiss = {dismiss}
        dismissTitle = {dismissTitle}
    /> ;
	ModalManager.open(dialog);
}