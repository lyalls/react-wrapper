import React , {Component, PropTypes} from 'react';
import InvestItemTitle from '../InvestItemTitle/index.jsx'
import AnnualRate from '../AnnualRate/index.jsx'
import ItemTags from '../ItemTags/index.jsx'
import BaseComponent, { RGB_Decimal2String } from '../BaseComponent/index.jsx'


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
                    {
                        // 标的类型图片
                        item.tenderTypeImageUrl && item.tenderTypeImageUrl !== ""
                        ? <BaseComponent absolute left={-5} top={10} width={32} height={63}>
                            <img src={item.tenderTypeImageUrl} />
                          </BaseComponent>
                        : null
                    }
                    {
                        // 底层背景
                        !item.tenderSolidBorderColor || item.tenderSolidBorderColor === "" || item.tenderSolidBorderColor === "255,255,255"
                        ? null
                        : <BaseComponent absolute top={-5} rigit={-5} left={-5} bottom={-5}
                            customStyle={{borderWidth: 1, borderStyle: 'solid', borderColor: RGB_Decimal2String(item.tenderSolidBorderColor)}}
                          />
                    }
                    <div className="app-pro-box" 
                            style={
                                {borderColor: RGB_Decimal2String(item.tenderTypeBorderColor)}
                            }
                            onClick={this.getInvestDetail.bind(this,item.id,false,item.isNew, item.limitTime)}>
                        {
                            // 会员标的右上角图标
                            item.tenderRightImageUrl && item.tenderRightImageUrl !== ""
                            ? <BaseComponent absolute top={10} right={10} width={23} height={23}>
                                <img src={item.tenderRightImageUrl}/>
                              </BaseComponent>
                            : null
                        }
                        <BaseComponent left={28} top={4} right={15}>
                            <InvestItemTitle item={item} isNativeApp/>
                        </BaseComponent>
                        <dl className="app-pro-info">
                            {
                                // <dt><strong>{item.annualRate}<b className="font-12">%</b></strong><span>{item.investmentHorizon}</span><span className="cir-progress">{item.tenderSchedule}%</span></dt>
                            }
                            <AnnualRate investItem={item} isNativeApp />
                            <BaseComponent top={10} height={35}/>
                            <dd>
                                <ul className="pro-act-tag">
                                    <ItemTags investItem={item} isNativeApp />
                                </ul>
                            </dd>
                        </dl>
                        {
                            // <div className="pro-tags"><img src={item.tenderTypeImageUrl} /></div>
                        }
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