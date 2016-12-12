import React , {Component, PropTypes} from 'react';
import $ from 'jquery';
import Carousel from '../../../components/Carousel/index.jsx';
import Footer from '../../../components/Footer/index.jsx';
import Header from '../../../components/Header/index.jsx';
import InvestList from '../../../components/InvestList/index.jsx';
import BaseComponent from '../../../components/BaseComponent/index.jsx';
import ReactPullToRefresh from 'react-pull-to-refresh';

class Home extends Component {
    constructor(props) {
        super(props);
    }
    componentWillMount() {
        this.props.onLoading();
    }
    componentWillReceiveProps(nextProps) {
    }
    componentDidMount() {
        if(this.props.env.platform.isWechat){
            $('.content-for-m-header').attr('ui-content-for', 'm-header')
        }
    }
    componentWillUnmount() {
        
    }

    render(){
        let isShowNotice = false;
        let heightScale = window.innerHeight > 568 - 113 ? (window.innerHeight) / (568 - 113) : 1 ;
        let noviceHeight = 233 * heightScale + (isShowNotice ? 0 : (20 * heightScale + 8 * heightScale));
        let isSeparateFirstNoviceItem = (this.props.env.platform.canInvokeNativeMethod() && this.props.investList.investsList && this.props.investList.investsList.length > 0);
         isSeparateFirstNoviceItem |= this.props.env.platform.isWechat;

        /*<ReactPullToRefresh
                onRefresh={this.props.onLoading.bind(this)}
             >
                <BaseComponent fullWidth backgroundColor={"#EFEFEF"} height={100} top={-100}>
                    <BaseComponent centerY={0} centerX={0} color={"#D0D0D0"}>
                        值得信赖的投资理财平台
                    </BaseComponent>
                </BaseComponent>
             </ReactPullToRefresh>
        */
        return (
            <div className="scrollable">
            <div className="scrollable-content k_p0">
                {
                    (this.props.env.platform.isWechat)
                    ?<div className="content-for-m-header"><Header/></div>
                    :""
                }
                <article className="wx-mainbody">   
                    <Carousel items={this.props.banner.items} env={this.props.env}/>
                    <InvestList className={ 
                        isNative ? "native-class ....": "wechat-class..."
                     }
                        env = {this.props.env}
                        heightScale = {heightScale} noviceHeight = {noviceHeight}
                        investList = {this.props.investList} 
                        isSeparateFirstNoviceItem = {isSeparateFirstNoviceItem}
                        getTenderInfoDetail={this.props.getTenderInfoDetail}
                        getInvestDetail={this.props.getInvestDetail}
                        gotoPage={this.props.gotoPage}
                        introUrl={(this.props.intro !== undefined)?this.props.intro.url:null}
                    />
                </article>
                {
                    (this.props.env.platform.isWechat)?<Footer />:""
                }
            </div>
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