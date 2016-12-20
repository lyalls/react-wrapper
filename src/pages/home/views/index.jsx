import React , {Component, PropTypes} from 'react';
import $ from 'jquery';
import Carousel from '../../../components/Carousel/index.jsx';
import Footer from '../../../components/Footer/index.jsx';
import Header from '../../../components/Header/index.jsx';
import InvestList from '../../../components/InvestList/index.jsx';
import BaseComponent from '../../../components/BaseComponent/index.jsx';
import IntroIcons from '../../../components/IntroIcons/index.jsx'
import ReactPullToRefresh from 'react-pull-to-refresh';
import InduceBarDownloadApp, {shouldShowDownloadAppBar} from '../../../components/InduceBarDownloadApp/index.jsx';
import {OpenDialog} from '../../../components/Dialog/index.jsx';


class Home extends Component {
    constructor(props) {
        super(props);
        // Init state
        this.state = {isDownloadAppBarHidden: !shouldShowDownloadAppBar()}
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentWillReceiveProps(nextProps) {
    }
    componentDidMount() {
        
    }
    componentWillUnmount() {
        
    }

    // Pull down refresh
    handleRefresh(resolve, reject){
        this.props.onLoading();
    }
    // End of pull refresh

    // Dialog
    openDialog(msg){
        console.log('Openning dialog modal with msg:', msg, 'this:', this);
        this.setState({isDialogOpen : true});
        this.setState({dialogContent : msg});
        OpenDialog({content: msg, dismiss: this.closeDialog.bind(this)})
    }
    closeDialog(){
        console.log('Closing dialog modal');
        this.setState({isDialogOpen : false});
    }
    // End of Dialog
    //
    getInvestDetail(...args){
        this.props.getInvestDetail(...args, this.openDialog.bind(this));
    }

    // Download App Bar
    setDownloadAppBarHidden(shouldHide){
        this.setState({isDownloadAppBarHidden: shouldHide});
    }
    render(){
        let isShowNotice = false;
        let heightScale = window.innerHeight > 568 - 113 ? (window.innerHeight) / (568 - 113) : 1 ;
        let noviceHeight = 233 * heightScale + (isShowNotice ? 0 : (20 * heightScale + 8 * heightScale));
        let isSeparateFirstNoviceItem = (this.props.env.platform.canInvokeNativeMethod() && this.props.investList.items && this.props.investList.items.length > 0);
        // isSeparateFirstNoviceItem |= this.props.env.platform.isWechat;
        let showPullToRefresh = this.props.env.platform.canInvokeNativeMethod();
        // let wrapper = showPullToRefresh 
        //             ?   <ReactPullToRefresh
        //                     onRefresh={this.handleRefresh.bind(this)}
        //                     className="your-own-class-if-you-want"
        //                     style={{
        //                         textAlign: 'center'
        //                     }}
        //                 >
        //                 <h3 style={{top: -30, position: 'abstolute'}}>Pull down to refresh</h3>
        //                 {
        //                     (this.props.env.platform.isWechat)
        //                     ?<div className="content-for-m-header"><Header/></div>
        //                     :""
        //                 } 
        //                 </ReactPullToRefresh>
        //             :   <div className="scrollable">
        //                 <div className="scrollable-content k_p0">
        //                 </div>
        //                 </div>
        return (

            <div className="scrollable">
            <div className={ (this.state.isDownloadAppBarHidden ? "" : 'index-btm-padding ') + "scrollable-content"} id="mContent">
                {
                    this.props.env.platform.canInvokeNativeMethod()
                    ? null
                    : <Header
                        isLogin = {
                            this.props.env.platform.isWechat && this.props.userInfo !== undefined && this.props.userInfo.user !== undefined
                        }
                        gotoPage = {this.props.gotoPage}
                      />
                }
                <article id="article_list" className="wx-mainbody" style={{minHeight: "100%", overflow: 'hidden'}}>   
                    <Carousel items={this.props.banner.items} env={this.props.env}/>
                    {
                        this.props.env.platform.canInvokeNativeMethod()
                        ? <BaseComponent fullWidth height={8*heightScale} backgroundColor={"#EFEFEF"} />
                        : null
                    }
                    <IntroIcons
                        gotoIntro={this.props.gotoPage.bind(null, 'aboutus', {url: this.props.introUrl})}
                        isLogin={
                            this.props.env.platform.isWechat && this.props.userInfo !== undefined && this.props.userInfo.user !== undefined
                        }
                        gotoPage={this.props.gotoPage}
                        env={this.props.env}
                    />
                    <InvestList 
                        userInfo = {this.props.userInfo}
                        env = {this.props.env}
                        heightScale = {heightScale} noviceHeight = {noviceHeight}
                        investList = {this.props.investList} 
                        isSeparateFirstNoviceItem = {isSeparateFirstNoviceItem}
                        getTenderInfoDetail={this.props.getTenderInfoDetail}
                        getInvestDetail={this.getInvestDetail.bind(this)}
                        gotoPage={this.props.gotoPage}
                        introUrl={(this.props.intro !== undefined)?this.props.intro.url:null}
                    />
                </article>
                {
                    this.props.env.platform.canInvokeNativeMethod() ? null : <Footer gotoPage={this.props.gotoPage}/>
                }
            </div>
            {
                this.props.env.platform.canInvokeNativeMethod() 
                ? null 
                : this.state.isDownloadAppBarHidden 
                    ? null
                    : <InduceBarDownloadApp gotoPage={this.props.gotoPage} setHidden={this.setDownloadAppBarHidden.bind(this)}/> 
            }
            </div>
        );
    }
}

Home.propTypes = {
    env: PropTypes.object.isRequired,
    onLoading: PropTypes.func.isRequired,
    getInvestDetail: PropTypes.func,
    getTenderInfoDetail: PropTypes.func,
    gotoPage: PropTypes.func,
}

export default Home;