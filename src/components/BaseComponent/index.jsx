import React, {Component, PropTypes} from 'react';

class BaseComponent extends Component {
    constructor(props) {
        super(props);
        this.setStyle(props);
    }
    componentWillReceiveProps(nextProps) {
        this.setState(nextProps);
    }
    setStyle(props){
        let style = {};

        // Default values
        style.left = 0;
        style.top = 0;

        if(!props) return {
            position: 'absolute',
            left: 0,
            top: 0
        };

        // Coordinates
        style.left = props.x || props.left || style.left;
        style.top = props.y || props.top || style.right;

        if(props.right !== undefined){
            style.right = props.right;
        }
        if(props.bottom !== undefined){
            style.bottom = props.bottom;
        }

        // Size
        if(props.width !== undefined){
            style.width = props.width;
        }
        if(props.height !== undefined){
            style.height = props.height;
        }

        // Full size
        if(props.fullWidth !== undefined && props.fullWidth){
            style.width = window.innerWidth;
        }
        if(props.fullHeight !== undefined && props.fullHeight){
            style.height = window.innerHeight;
        }

        // Center
        if((props.centerX !== undefined && style.width !== undefined) 
            || (props.centerY !== undefined && style.height !== undefined)){
        
            let translate = {x: 0, y:0};

            if(props.centerX !== undefined && style.width !== undefined && typeof style.width === 'number'){
                delete style.right;
                style.left = "50%" 
                translate.x = Math.round(props.centerX / style.width * 2 * 100 - 50);
            }
            if(props.centerY !== undefined && style.height !== undefined && typeof style.height === 'number'){
                delete style.bottom;
                style.top = "50%" 
                translate.y = Math.round(props.centerY / style.height * 2 * 100 - 50);
            }
            style.transform = `translate(${translate.x}%, ${translate.y}%)`;
        }
        
        // Merge props style
        if(props.style){
            style = Object.assign({}, props.style, style);
        }

        if(style.position == undefined){
            if((this.props.relative !== undefined && !this.props.relative)
                ||(this.props.absolute !== undefined && this.props.absolute)
                ){
                style.position = "absolute";
            }else{
                style.position = "relative";
            }
        }

        this.state = style;
    }
    onWindowResize(event){
        if(this.props.fullWidth){
            this.setState({width : window.innerWidth});
        }
        if(this.props.fullHeight){
            this.setState({height: window.innerHeight});
        }
    }
    componentDidMount() {
        // queue for window resize event
        if(this.props.fullWidth || this.props.fullHeight){
            if(window.onresize === undefined || window.onresize === null){
                function Resizer(){
                    this.listeners = [];
                }
                Resizer.prototype.addListener = function(listener){
                    this.listeners.push(listener);
                }
                Resizer.prototype.removeListener = function(listener){
                    const idx = this.listeners.indexOf(listener);
                    if(idx >= 0){
                        this.listeners.splice(idx,1);
                    }
                }
                Resizer.prototype.respondOrAddListener = function(eventOrListener){
                    if(typeof eventOrListener === 'function'){
                        this.addListener(eventOrListener);
                    }else{
                        this.listeners.forEach( func => {
                            if(typeof func !== 'function') return;
                            func(eventOrListener);
                        });
                    }
                }

                let resizer = new Resizer();
                window.onresize = resizer.respondOrAddListener.bind(resizer);;
            }
            window.onresize(this.onWindowResize.bind(this));
        }
    }
    render(){
        return (
            <div style={this.state} className = {this.props.className} >
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
    fullHeight: PropTypes.bool,
    top: PropTypes.number,
    bottom: PropTypes.number,
    left: PropTypes.number,
    right: PropTypes.number,
    className: PropTypes.string,
    style: PropTypes.object,
    centerX: PropTypes.number,
    centerY: PropTypes.number,
    relative: PropTypes.bool,
}

export default BaseComponent;