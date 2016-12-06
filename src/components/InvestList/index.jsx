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
        this.props.getInvestDetail(...arguments);
    };

    // 立即投资
    getTenderInfoDetail(borrowId) {
        this.props.getTenderInfoDetail(...arguments);
    };

    // 跳转页面
    gotoPage(pageName, params){
        this.props.gotoPage(pageName, params);
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
        let separateNoviceItem = this.props.isSeparateFirstNoviceItem;
        let investList = (separateNoviceItem)? this.props.investList.investsList.slice(1) : this.props.investList.investsList;
        let noviceItemData = (separateNoviceItem)? this.props.investList.investsList[0] : {};
        let noviceItemTitle = this.itemTitle(noviceItemData);
        return (
                <BaseComponent fullWidth>
                    {
                        separateNoviceItem
                        ? <BaseComponent fullWidth>
                            <BaseComponent fullWidth height={8*this.props.heightScale} backgroundColor={"#EFEFEF"} />
                            <IntroIcons
                                onClick={this.gotoPage.bind(this, 'aboutus', {url: this.props.introUrl})}
                            />
                            <BaseComponent fullWidth height={8*this.props.heightScale} backgroundColor={"#EFEFEF"} />
                            <NoviceItem heightScale = {this.props.heightScale} height = {this.props.noviceHeight} 
                                    itemData={noviceItemData} itemTitle={noviceItemTitle}
                                    onClick={this.getInvestDetail.bind(this,noviceItemData.id,false,noviceItemData.isNew, noviceItemData.limitTime)}
                            />
                            <BaseComponent fullWidth height={8*this.props.heightScale} backgroundColor={"#EFEFEF"} />
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
                        {
                            separateNoviceItem
                            ?<BaseComponent>
                                <BaseComponent fullWidth height={8*this.props.heightScale} backgroundColor={"#EFEFEF"} />
                                <BaseComponent fullWidth 
                                    height={12*this.props.heightScale} 
                                    backgroundColor={"#EFEFEF"}  
                                >
                                    <BaseComponent absolute centerY={0} centerX={0} color={"#D0D0D0"} fontSize={12}> 
                                        投资有风险，选择需谨慎 
                                    </BaseComponent>
                                </BaseComponent>
                             </BaseComponent>
                            :<div className="loading-btn" onClick={this.gotoPage.bind(this,'investList')}>查看更多项目</div>
                        }
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
    isSeparateFirstNoviceItem: PropTypes.bool,
    getInvestDetail: PropTypes.func,
    getTenderInfoDetail: PropTypes.func,
    gotoPage: PropTypes.func,
    introUrl: PropTypes.string,
}

export default InvestList;



