import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';
import NoviceItem from '../NoviceItemInHomePage/index.jsx'
import AnnualRate from '../AnnualRate/index.jsx'
import ItemTags from '../ItemTags/index.jsx'
import IntroIcons from '../IntroIcons/index.jsx'

class InvestList extends Component {
    constructor(props) {
        super(props);
    }
    componentWillReceiveProps(nextProps) {
        this.setSessionStorage = nextProps.env.setSessionStorage;
    }

    // 显示对话框
    // dialog(){
    //     var modalInstance = $modal.open({
    //         animation: true,
    //         templateUrl: 'xlbDialog',
    //         controller:'homePop',
    //         size: 20,
    //         resolve: {
    //             items: function () {
    //                 return $scope.items;
    //             }
    //         }
    //     });
    //     modalInstance.result.then(function (selectedItem) {
    //         $scope.selected = selectedItem;
    //     }, function () {
    //         $log.info('Modal dismissed at:' + new Date());
    //     });
    // };

    // 投资详情
    getInvestDetail (borrowId,pname,ifnew,limitTime) {
        console.log(borrowId, pname, ifnew, limitTime);
        if (arguments.length >= 4 && arguments[3] > 0) {
            // dialog();
            return; //限量标不给跳转
        }
        if(pname){
            this.setSessionStorage('Detail_tender_plan_name',pname)
        }
        if(ifnew==0 || ifnew==1){
            this.setSessionStorage('Detail_tender_if_new',ifnew+'');
        }
        this.setSessionStorage('Detail_borrowId', borrowId);
        window.location.href = "/#/invest/detail";
    };

    // 立即投资
    getTenderInfoDetail(borrowId) {
        if (arguments.length >= 2 && arguments[1] > 0) return;
        if (borrowId) {
            this.setSessionStorage('Detail_borrowId', borrowId);
        }
        window.location.href = "/#/invest";
    };

    gotoPage(pageName){
        switch(pageName){
        case 'investList':
            window.location.href = "/#/invest/list";
            break;
        case 'aboutus':
            window.location.href = "/#/aboutus/index";
            break;
        default:
            break;
        }
    }
    gotoList(){
        this.gotoPage('investList');
    }
    itemTitle(item){
        let itemTitle;
        let fullThreshold = (item.isFullThreshold==1)?<span className="red-tag">满抢</span>:"";
        if(item.isLimit != 1 || item.limitTime<=0){
            itemTitle = <h3><em className="h3-title">{fullThreshold}{item.name}</em><i></i></h3>;
        }else{
            itemTitle = <h3 className="count-down"><b></b>即将发售：<time>{item.timer}</time></h3>;
        }
        return itemTitle;
    }
    render(){
        let separateNoviceItem = ((this.props.env.platform.isIOS || this.props.env.platform.isAndroid) && this.props.investList.investsList && this.props.investList.investsList.length > 0);
        let investList = (separateNoviceItem)? this.props.investList.investsList.slice(1) : this.props.investList.investsList;
        let noviceItemData = (separateNoviceItem)? this.props.investList.investsList[0] : {};
        let noviceItemTitle = this.itemTitle(noviceItemData);
        return (
                <BaseComponent fullWidth>
                    {
                        separateNoviceItem
                        ? <BaseComponent fullWidth>
                            <IntroIcons
                                onClick={this.gotoPage.bind(this, 'aboutus')}
                            />
                            <NoviceItem heightScale = {this.props.heightScale} height = {this.props.noviceHeight} 
                                    itemData={noviceItemData} itemTitle={noviceItemTitle}
                                    onClick={this.getInvestDetail.bind(this,noviceItemData.id,false,noviceItemData.isNew, noviceItemData.limitTime)}
                            />

                          </BaseComponent>
                        : ""
                    }
                    <div className="wx-index-pro-cont">
                        <ul className="wx-index-pro-list" >
                            {
                                investList ?
                                investList.map( (list, idx) =>{
                                    let itemTitle = this.itemTitle(list);
                                    let recommendMark = (list.is_zhiding == true) ? <img src="./images/icon-recommend.png" className="recommend-mark"/> : "";
                                    return (
                                        <li key={idx}>
                                            <div className={ "pro-box " + list.biao_type_zi_bgcss} onClick={this.getInvestDetail.bind(this,list.id,false,list.isNew, list.limitTime)}>
                                                {itemTitle}
                                                <dl className="pro-info">
                                                    <dt>
                                                        <AnnualRate investItem={list} />
                                                        <ItemTags investItem = {list} />
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
                            (this.props.investList && this.props.investList.investsLen === 1) ?
                            <div className="btn-area-com margin-t-1-5rem">
                                {
                                    (this.props.investList.investsLen === 1 && this.props.investList.investsList[0].statusMessage=='投资中' && this.props.investList.investsList[0].biao_type_zi != '限量标')
                                    ? <a className="orange-radius-btn wd-80" onClick={this.getTenderInfoDetail.bind(this, this.props.investList.investsList[0].id)}>立即投资</a>
                                    : ""
                                }
                                {
                                    (this.props.investList.investsLen === 1 && this.props.investList.investsList[0].isLimit &&  this.props.investList.investsList[0].limitTime > 0)
                                    ? <a class="gray-radius-btn wd-80">即将发售</a>
                                    : ""
                                }
                                {
                                    (this.props.investList.lastTenderInfo !== false)
                                    ? <a class="gray-radius-btn wd-80">
                                    {
                                        new Date(this.props.investList.lastTenderInfo.addtime * 1000).getMonth()+1  + "月" 
                                        +new Date(this.props.investList.lastTenderInfo.addtime * 1000).getDate() +"日"
                                        +new Date(this.props.investList.lastTenderInfo.addtime * 1000).getHours()+":"
                                        +new Date(this.props.investList.lastTenderInfo.addtime * 1000).getMinutes()+" 抢光"
                                    } 
                                    </a>
                                    : ""
                                }
                            </div>
                            :""
                        }
                        <div className="loading-btn" onClick={this.gotoList.bind(this)}>查看更多项目</div>
                    </div>
                </BaseComponent>
        );
    }
}

InvestList.PropTypes = {
    investList: PropTypes.object,
    env: PropTypes.object,
    heightScale: PropTypes.number,
    noviceHeight: PropTypes.number,
}

export default InvestList;



