import React , {Component, PropTypes} from 'react';
import CountDown from '../CountDown/index.jsx'
import BaseComponent from '../BaseComponent/index.jsx'

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
                    if(that.timeout){
                        clearTimeout(that.timeout);
                        that.timeout = null;
                    }
                }, timeLimit)
            }
        }
    }
    componentWillReceiveProps(nextProps) {
    }
    componentWillUnmount() {
        if(this.timeout){
            clearTimeout(this.timeout);
        }
    }
    render(){
        let item = this.props.item;
        let fullThreshold = (item.isFullThreshold==1)?<span className="red-tag">满抢</span>:null;
        let memberIcon = (item.biao_type_zi == '会员标') 
                        ? this.props.isNativeApp && item.tenderCrownImageUrl && item.tenderCrownImageUrl !== ""
                            ? <BaseComponent left={28} height={12} width={12} centerY={0}>
                                <img src={item.tenderCrownImageUrl}/>
                              </BaseComponent>
                            : <strong className="icon-crown"></strong>
                        :null;
        let itemName = (item.isLimit != 1 || item.limitTime<=0 ) 
                        ? this.props.isNativeApp 
                            ? 
                              <h3 style={{fontSize: 17, textAlign: 'left', wordWrap: 'break-word'}}>
                                <em>{memberIcon}{fullThreshold}{item.name}</em>
                              </h3>
                            : <h3>
                                <em className="h3-title">{memberIcon}{fullThreshold}{item.name}</em>
                                {this.props.isNativeApp ? null : <i></i> }
                              </h3> 
                        : null;
        let countDown =(item.timer && (item.timer.limit - ((new Date()).getTime() - item.timer.start) > 0)) ? 
                        <h3 className="count-down"><b></b>即将发售：<CountDown {...item.timer} /></h3> 
                        : null;
        
        return (<div>{itemName}{countDown}</div>);
    }
}

InvestItemTitle.PropTypes = {
    item: PropTypes.object.isRequired,
    isNativeApp: PropTypes.bool,
}

export default InvestItemTitle;