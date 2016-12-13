import React , {Component, PropTypes} from 'react';
import CountDown from '../CountDown/index.jsx'

class InvestItemTitle extends Component {
    constructor(props) {
        super(props);
    }
    componentDidMount() {
        
        if(this.props.item && this.props.item.timer){
            const timeLimit = (this.props.item.timer.limit - ((new Date()).getTime() - this.props.item.timer.start));
            const that = this;
            if(timeLimit > 0){
                this.timeout = setTimeout(function(){
                    that.forceUpdate();
                }, timeLimit)
            }
        }
    }

    itemTitle(item){
        if(!item) return null;
        let itemTitle;
        let fullThreshold = (item.isFullThreshold==1)?<span className="red-tag">满抢</span>:"";
        if(item.isLimit != 1 || item.limitTime<=0 || !item.timer || (item.timer.limit - ((new Date()).getTime() - item.timer.start) <= 0)){
            itemTitle = <h3><em className="h3-title">{fullThreshold}{item.name}</em><i></i></h3>;
        }else{
            itemTitle = <h3 className="count-down"><b></b>即将发售：<CountDown {...item.timer} /></h3>;
        }
        return itemTitle;
    }
    render(){
        return this.itemTitle(this.props.item) 
    }
}

InvestItemTitle.PropTypes = {
    item: PropTypes.object,
}

export default InvestItemTitle;