import React , {Component, PropTypes} from 'react';
import $ from 'jquery';
import Carousel from '../../../components/Carousel/index.jsx';
import Footer from '../../../components/Footer/index.jsx';
import Header from '../../../components/Header/index.jsx';
import InvestList from '../../../components/InvestList/index.jsx';
import NoviceItem from '../../../components/NoviceItemInHomePage/index.jsx'


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

    render(){
        return (
            <div className="scrollable">
            <div className="scrollable-content k_p0">
                {
                    (this.props.env.platform.isWechat)?<div className="content-for-m-header"><Header/></div>:""
                }
                <article className="wx-mainbody">   
                    <Carousel items={this.props.banner.items} />

                    {
                        (this.props.env.platform.isWechat || this.props.env.platform.isIOS || this.props.env.platform.isAndroid) 
                        ? <NoviceItem />
                        : ""
                    }
                    <InvestList 
                        env = {this.props.env}
                        investList = {this.props.investList} 
                    />
                </article>
                <Footer />
            </div>
            </div>
        );
    }
}

Home.propTypes = {
    env: PropTypes.object.isRequired,
    onLoading: PropTypes.func.isRequired,
}

export default Home;