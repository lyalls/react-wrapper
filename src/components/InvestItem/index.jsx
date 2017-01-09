import React , {Component, PropTypes} from 'react';
import InvestItemTitle from '../InvestItemTitle/index.jsx'
import AnnualRate from '../AnnualRate/index.jsx'
import ItemTags from '../ItemTags/index.jsx'
import BaseComponent from '../BaseComponent/index.jsx'

class InvestItem extends Component {
    constructor(props) {
        super(props);
    }
    componentDidMount() {
        
    }
    // 投资详情
    getInvestDetail (borrowId,pname,ifnew,limitTime) {
        this.props.getInvestDetail(...arguments);
    };

    render(){
        let item = this.props.item;
        return (
            this.props.isNativeApp 
            ?   <li>
                     <div className="app-pro-box" onClick={this.getInvestDetail.bind(this,item.id,false,item.isNew, item.limitTime)}>
                         <InvestItemTitle item={item}/>
                         <dl className="app-pro-info">
                             <dt><strong>{item.annualRate}<b className="font-12">%</b></strong><span>{item.investmentHorizon}</span><span className="cir-progress">{item.tenderSchedule}%</span></dt>
                             <dd>
                                 <ul className="pro-act-tag">
                                     <ItemTags investItem={item} isNativeApp />
                                 </ul>
                             </dd>
                         </dl>
                         <div className="pro-tags"><img src="./images/app_gou.png" /></div>
                     </div>
                  </li>
            :   <li>
                    <div className={ "pro-box " + item.biao_type_zi_bgcss} onClick={this.getInvestDetail.bind(this,item.id,false,item.isNew, item.limitTime)}>
                        <InvestItemTitle item={item}/>
                        <dl className="pro-info">
                            <dt>
                                <AnnualRate investItem={item} />
                                <ItemTags investItem = {item} />
                            </dt>
                            <dd><span><b>借款期限：</b>{item.investmentHorizon}</span><span><b>可投金额：</b>{item.availableAmount} 元</span></dd>
                        </dl>
                    </div>
                    <div className={"index-list-tag "+ item.biaotag}>{item.biao_type_zi}</div>
                    {(item.is_zhiding == true) ? <img src="./images/icon-recommend.png" className="recommend-mark"/> : null}
                </li>
        )
    }
}

InvestItem.PropTypes = {
    isNativeApp: PropTypes.bool,
    item: PropTypes.object,
    getInvestDetail: PropTypes.func,
}

export default InvestItem;