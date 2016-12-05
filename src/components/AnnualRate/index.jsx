import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class AnnualRate extends Component {
    constructor(props) {
        super(props);
    }
    render(){
    	return(
    		<strong className={(this.props.investItem.isReward==0 && this.props.investItem.isBonusticket==0 && this.props.investItem.isAllowIncrease == 0 && this.props.investItem.isBonusticket==0)?'only-data':""}>
                {this.props.investItem.annualRate}<b className="font-12">%</b>
                {
                    (this.props.investItem.increaseApr > 0)? <b className="font-22">+{this.props.investItem.increaseApr}</b> : ""
                }
                {
                    (this.props.investItem.increaseApr > 0)? <b className="font-12">%</b>: ""
                }
            </strong>
    	)
    }
}

AnnualRate.PropTypes = {
	investItem: PropTypes.object
}

export default AnnualRate;