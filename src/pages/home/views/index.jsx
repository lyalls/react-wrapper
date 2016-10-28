import React , {Component, PropTypes} from 'react';

class Home extends Component {
    constructor(props) {
        super(props);
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentWillReceiveProps(nextProps) {
        console.log('Home page receiving new props:', nextProps);
    }
    componentWillUpdate(nextProps, nextState) { 
    }
    render(){
        return (
            <div>
                <header className="wx-header wx-index-head">
                    <h1 className="logo"></h1>
                    <a href="/users/account" className="wx-index-top-my"></a>
                </header>
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
                                    let increaseApr = (list.increaseApr > 0)? <div><b className="font-22">+{list.increaseApr}</b><b className="font-12">%</b></div> : "";
                                    let isRead = (list.isReward==1)? <span className="take">{list.promotionTitle}</span> : "";
                                    let isBonusTicket = (list.isBonusticket == 1) ? <span >红包券</span> : "";
                                    let isAllowIncrease = (list.isAllowIncrease == 1) ? <span>加息券</span> : "";
                                    let isTag = (list.isTag == 1) ? <span>{list.tagTitle}</span> : "";
                                    let recommendMark = (list.is_zhiding == true) ? <img src="./images/icon-recommend.png" className="recommend-mark"/> : "";
                                    return (
                                        <li key={idx}>
                                            <div className={ "pro-box" + list.biao_type_zi_bgcss}>
                                                {itemTitle}
                                                <dl className="pro-info">
                                                    <dt>
                                                        <strong className={(list.isReward==0 && list.isBonusticket==0 && list.isAllowIncrease == 0 && list.isBonusticket==0)?'only-data':""}>
                                                            {list.annualRate}
                                                            <b className="font-12">%</b>
                                                            {increaseApr}
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
                    </div>
                </article>
            </div>
        );
    }
}

Home.propTypes = {
    onLoading: PropTypes.func.isRequired
}

export default Home;