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
        let fullThreshold = (item.isFullThreshold==1)
                        ? this.props.isNativeApp 
                            ? null
                            : <span className="red-tag">满抢</span>
                        : null;
        let memberIcon = (item.biao_type_zi == '会员标') 
                        ? this.props.isNativeApp
                            ? item.tenderCrownImageUrl && item.tenderCrownImageUrl !== ""
                                ? <BaseComponent absolute left={0} height={12} width={12} centerY={0}>
                                    <img src={item.tenderCrownImageUrl}/>
                                  </BaseComponent>
                                : <BaseComponent absolute left={0} centerY={0} width={12}>
                                    <h3 style={{textAlign: "left", fontSize: 8}} ><em><strong className="icon-crown"></strong></em></h3>
                                  </BaseComponent>
                            : <strong className="icon-crown"></strong>
                        :null;
        let adjustLeft = this.props.isNativeApp && item.tenderCrownImageUrl && item.tenderCrownImageUrl !== ""
                        ? 4 : 10;
        let itemName = (item.isLimit != 1 || item.limitTime<=0 ) 
                        ? this.props.isNativeApp 
                            ? <BaseComponent height={30} right={0} left={0}>
                                {memberIcon}
                                <BaseComponent absolute left={memberIcon==null ? 0 : 12 + adjustLeft} centerY={0} right={60}>
                                    <span>
                                        <strong style={{left: 0, right: 0, fontSize: 17, overflow: "hidden", textAlign: 'left', display: "block", whiteSpace: "nowrap", textOverflow: "ellipsis"}}>{item.name}</strong>
                                    </span>
                                </BaseComponent>
                              </BaseComponent>
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