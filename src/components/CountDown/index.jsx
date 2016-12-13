import React, {Component, PropTypes} from 'react';

class CountDown extends Component {
    constructor(props) {
        super(props);
    }
    componentWillMount() {
        
    }
    componentDidMount() {
        let that = this;
        this.interval = setInterval(function(){
            const secondsLeft = Math.ceil((that.props.limit - ((new Date()).getTime() - that.props.start))/1000);
            if( secondsLeft > 0){
                that.forceUpdate();
            }else{
                clearInterval(that.interval);
                that.interval = null;
            }
        }, this.props.frequency || 100);
    }
    componentWillUnmount() {
        if(this.interval){
            clearInterval(this.interval);
        }
    }
    
    render(){
        return <time>{this.props.formater(this.props.start, this.props.limit)}</time>
    }
}

CountDown.propTypes = {
    start: PropTypes.number.isRequired,
    limit: PropTypes.number.isRequired,
    formater: PropTypes.func.isRequired,
    frequency: PropTypes.number,
}

export default CountDown;