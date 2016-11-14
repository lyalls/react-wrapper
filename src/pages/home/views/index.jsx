import React , {Component, PropTypes} from 'react';
import $ from 'jquery';
import Footer from '../../../components/footer/index.jsx';
import Header from '../../../components/header/index.jsx';

class Home extends Component {
    constructor(props) {
        super(props);
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentDidMount() {
        $('.content-for-m-header').attr('ui-content-for', 'm-header')
    }

    gotoList(){
        // window.location.replace( "#/invest/list" );

        window.location.href = "/#/invest/list" ;

        // $(location).attr('href', '/#/invest/list')
    }
    render(){
        return (
            <div className="scrollable">
            <div className="scrollable-content k_p0">
                <div className="content-for-m-header">
                    <Header/>
                </div>
                <article className="wx-mainbody">   
                    {
                        this.props.banner.items ? 
                        this.props.banner.items.map( (item, i) => (
                            <div key={i} className="wx-banner">
                                <div className="index-banner">
                                    <a href={item.actionUrl}>
                                        <img src={item.imageUrl} />
                                    </a>
                                </div>
                            </div>
                        )) 
                        : "" 
                    }
                    <div className="wx-index-pro-cont">
                        <ul className="wx-index-pro-list" >
                            {
                                this.props.investList.investsList ?
                                this.props.investList.investsList.map( (list, idx) =>{
                                    let itemTitle;
                                    let fullThreshold = (list.isFullThreshold==1)?<span className="red-tag">满抢</span>:"";
                                    if(list.isLimit != 1 || list.limitTime<=0){
                                        itemTitle = <h3><em className="h3-title">{fullThreshold}{list.name}</em><i></i></h3>;
                                    }else{
                                        itemTitle = <h3 className="count-down"><b></b>即将发售：<time>{list.timer}</time></h3>;
                                    }
                                    let isRead = (list.isReward==1)? <span className="take">{list.promotionTitle}</span> : "";
                                    let isBonusTicket = (list.isBonusticket == 1) ? <span >红包券</span> : "";
                                    let isAllowIncrease = (list.isAllowIncrease == 1) ? <span>加息券</span> : "";
                                    let isTag = (list.isTag == 1) ? <span>{list.tagTitle}</span> : "";
                                    let recommendMark = (list.is_zhiding == true) ? <img src="./images/icon-recommend.png" className="recommend-mark"/> : "";
                                    return (
                                        <li key={idx}>
                                            <div className={ "pro-box " + list.biao_type_zi_bgcss}>
                                                {itemTitle}
                                                <dl className="pro-info">
                                                    <dt>
                                                        <strong className={(list.isReward==0 && list.isBonusticket==0 && list.isAllowIncrease == 0 && list.isBonusticket==0)?'only-data':""}>
                                                            {list.annualRate}<b className="font-12">%</b>
                                                            {
                                                                (list.increaseApr > 0)? <b className="font-22">+{list.increaseApr}</b> : ""
                                                            }
                                                            {
                                                                (list.increaseApr > 0)? <b className="font-12">%</b>: ""
                                                            }
                                                        </strong>
                                                        {isRead}
                                                        {isBonusTicket}
                                                        {isAllowIncrease}
                                                        {isTag}
                                                    </dt>
                                                    <dd><span><b>借款期限：</b>{list.investmentHorizon}</span><span><b>可投金额：</b>{list.availableAmount} 元</span></dd>
                                                </dl>
                                            </div>
                                            <div className={"index-list-tag "+ list.biaotag}>{list.biao_type_zi}</div>
                                            {recommendMark}
                                        </li>
                                    )
                                })
                                : ""
                            }
                        </ul>
                        {
                            this.props.investList.investsLen === 1 ?
                            <div className="btn-area-com margin-t-1-5rem">
                                {
                                    (this.props.investList.investsLen === 1 && this.props.investList.investsList[0].statusMessage=='投资中' && this.props.investList.investsList[0].biao_type_zi != '限量标')
                                    ? <a className="orange-radius-btn wd-80">立即投资</a>
                                    : ""
                                }
                                {
                                    (this.props.investList.investsLen === 1 && this.props.investList.investsList[0].isLimit &&  this.props.investList.investsList[0].limitTime > 0)
                                    ? <a class="gray-radius-btn wd-80">即将发售</a>
                                    : ""
                                }
                                {
                                    (this.props.investList.lastTenderInfo !== false)
                                    ? <a class="gray-radius-btn wd-80">{this.props.investList.lastTenderInfo.addtime * 1000} 抢光</a>
                                    : ""
                                }
                            </div>
                            :""
                        }
                        <div className="loading-btn" onClick={this.gotoList}>查看更多项目</div>
                    </div>
                </article>
                <Footer />
            </div>
            </div>
        );
    }
}

Home.propTypes = {
    onLoading: PropTypes.func.isRequired,
    
}

export default Home;