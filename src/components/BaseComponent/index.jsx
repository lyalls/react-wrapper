import React, {Component, PropTypes} from 'react';

class BaseComponent extends Component {
    constructor(props) {
        super(props);
        
    }
    render(){
        let style = {};
        if(this.props.x !== undefined && this.props.y !== undefined){
            style = {
                position: "absolute", 
                left: (this.props.x || 0) + "px", 
                top: (this.props.y || 0)+ "px"
            }
        }
        if(this.props.width !== undefined){
            style.width = this.width + "px";
        }
        if(this.props.height !== undefined){
            style.height = this.height + "px";
        }
        return (
            <div style={style}>
                {this.props.children}
            </div>
        )
    }
}

BaseComponent.propTypes = {
    x: PropTypes.number,
    y: PropTypes.number,
    width: PropTypes.number,
    height: PropTypes.number,
    fullWidth: PropTypes.bool,
    insetTop: PropTypes.number,
    insetBottom: PropTypes.number,
    insetLeft: PropTypes.number,
    insetRight: PropTypes.number
}

export default BaseComponent;