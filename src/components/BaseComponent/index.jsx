import React, {Component, PropTypes} from 'react';

class BaseComponent extends Component {
    static lastComponentId = 0;
    static nextComponentId(){
        return "BaseComponent_" + (++BaseComponent.lastComponentId);
    }
    constructor(props) {
        super(props);
        this.componentId = BaseComponent.nextComponentId();
        this.setStyle(props);
        this.setEvents(props);
    }
    componentWillReceiveProps(nextProps) {
        this.setState(nextProps);
    }
    setEvents(props){
        let events = {};
        // Events
        for(let eventName of ['onClick']){
            if(props[eventName] !== undefined && props[eventName] !== null){
                events[eventName] = props[eventName];
            }
        } 
        if(this.state === undefined) this.state = {};
        this.state = Object.assign({}, this.state, {events: events});
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

        // Statics properties
        // Coordinates
        style.left = props.x || props.left || style.left;
        style.top = props.y || props.top || style.right;

        for(let propName of ['right', 'bottom', 'width', 'height', 'fontSize', 'color', 'textAlign', 'backgroundColor']){
            if(props[propName] !== undefined){
                style[propName] = props[propName];
            }
        }       

        // Dynamic properties
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
                translate.x = style.width === 0 ? 0 : Math.round(props.centerX / style.width * 2 * 100 - 50);
            }
            if(props.centerY !== undefined && style.height !== undefined && typeof style.height === 'number'){
                delete style.bottom;
                style.top = "50%" 
                translate.y = style.height === 0 ? 0 : Math.round(props.centerY / style.height * 2 * 100 - 50);
            }
            style.transform = `translate(${translate.x}%, ${translate.y}%)`;
        }
        
        // Others
        // Set background image size to the element size
        if(props.bgImgFitSize && style.width !== undefined && style.height !== undefined){
            style.backgroundSize = style.width+"px "+ style.height+"px";
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
        if(!this.state) this.state = {}
        this.state = Object.assign({}, this.state, {style: style});
    }
    onWindowResize(event){
        let newProp = Object.assign({}, this.props);
        if(this.props.fullWidth){
            newProp = Object.assign(newProp, {width : window.innerWidth})
        }
        if(this.props.fullHeight){
            newProp = Object.assign(newProp, {width : window.innerHeight})
        }
        this.setStyle(newProp);
        this.forceUpdate();
    }
    componentDidMount() {
        // For dynamic properties
        if((this.state.style.width === undefined && this.props.centerX !== undefined)
         || (this.state.style.height === undefined && this.props.centerY !== undefined)){
            let newProps = Object.assign({}, this.state.style);
            let sizeAdj = this.props.sizeAdjustment;
            if(this.state.style.width === undefined){
                newProps.width = document.getElementsByClassName(this.componentId)[0].clientWidth;
                if(sizeAdj && sizeAdj.width) newProps.width += sizeAdj.width;
                newProps.centerX = this.props.centerX;
            }
            if(this.state.style.height === undefined){
                newProps.height = document.getElementsByClassName(this.componentId)[0].clientHeight;
                if(sizeAdj && sizeAdj.height) newProps.height += sizeAdj.height;
                newProps.centerY = this.props.centerY;
            }
            let props = Object.assign({}, newProps);
            this.setStyle(props);
            this.forceUpdate();
        }
        // queue for window resize event
        if(this.props.fullWidth || this.props.fullHeight){
            if(window.onresize === undefined || window.onresize === null){
                function Resizer(){
                    this.listeners = [];
                }
                Resizer.prototype.addListener = function(listener){
                    if(!listener || typeof listener !== 'function') return -1;
                    let idx = this.listeners.indexOf(listener);
                    if( idx >= 0) return idx;
                    this.listeners.push(listener);
                    return this.listeners.length - 1;
                }
                Resizer.prototype.removeListener = function(listener){
                    const idx = this.listeners.indexOf(listener);
                    if(idx >= 0){
                        this.listeners.splice(idx,1);
                    }
                    return idx;
                }
                Resizer.prototype.respondOrAddListener = function(eventOrListener){
                    if(typeof eventOrListener === 'string' && eventOrListener === 'Are you OK?'){
                        return this;
                    }else if(typeof eventOrListener === 'function'){
                        return this.addListener(eventOrListener);
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
            try{
                this.windowResizeListener = this.onWindowResize.bind(this);
                window.onresize(this.windowResizeListener);
            }catch(e){
                console.log('WARNING: window.onresize was used outside of BaseComponent, error:',e);
            }
        }
    }
    componentWillUnmount() {
        // Remove listener from onresizer
        if(this.windowResizeListener && typeof window.onresize === 'function'){
            try{
                let resizer = window.onresize('Are you OK?');
                resizer.removeListener(this.windowResizeListener);
            }catch(e){
                console.log('ERROR: when dealloc listener from window.onresize, which was used outside of BaseComponent, error:', e);
            }
        }
    }
    render(){
        return (
            <div className = {((this.props.className)?this.props.className + " ":"")+this.componentId } 
                 style={this.state.style} {...this.state.events}
            >
                {this.props.children}
            </div>
        )
    }
}

BaseComponent.propTypes = {
    x: PropTypes.number,
    y: PropTypes.number,
    width: PropTypes.number,        // if not provided, it's going to autosize mode
    height: PropTypes.number,       // if not provided, it's going to autosize mode
    fullWidth: PropTypes.bool,
    fullHeight: PropTypes.bool,
    top: PropTypes.number,
    bottom: PropTypes.number,
    left: PropTypes.number,
    right: PropTypes.number,
    className: PropTypes.string,
    style: PropTypes.object,
    backgroundColor: PropTypes.string,
    centerX: PropTypes.number,
    centerY: PropTypes.number,
    relative: PropTypes.bool,
    bgImgFitSize: PropTypes.bool,
    fontSize: PropTypes.number,
    textAlign: PropTypes.string,
    color: PropTypes.string,
    sizeAdjustment: PropTypes.object,   // Only useful for autosize mode
    onClick: PropTypes.func,
}

export default BaseComponent;