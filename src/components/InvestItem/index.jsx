import React , {Component, PropTypes} from 'react';
import InvestItemTitle from '../InvestItemTitle/index.jsx'
import AnnualRate from '../AnnualRate/index.jsx'
import ItemTags from '../ItemTags/index.jsx'

class InvestItem extends Component {
    constructor(props) {
        super(props);
    }
    // 投资详情
    getInvestDetail (borrowId,pname,ifnew,limitTime) {
        this.props.getInvestDetail(...arguments);
    };

    render(){
        let item = this.props.item;
    	let itemTitle = <InvestItemTitle item={this.props.item}/>;
        let recommendMark = (item.is_zhiding == true) ? <img src="./images/icon-recommend.png" className="recommend-mark"/> : "";
        return (
            <li>
                <div className={ "pro-box " + item.biao_type_zi_bgcss} onClick={this.getInvestDetail.bind(this,item.id,false,item.isNew, item.limitTime)}>
                    {itemTitle}
                    <dl className="pro-info">
                        <dt>
                            <AnnualRate investItem={item} />
                            <ItemTags investItem = {item} />
                        </dt>
                        <dd><span><b>借款期限：</b>{item.investmentHorizon}</span><span><b>可投金额：</b>{item.availableAmount} 元</span></dd>
                    </dl>
                </div>
                <div className={"index-item-tag "+ item.biaotag}>{item.biao_type_zi}</div>
                {recommendMark}
            </li>
        )
    }
}

InvestItem.PropTypes = {
    item: PropTypes.object,
    getInvestDetail: PropTypes.func,
}

export default InvestItem;