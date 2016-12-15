import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class AnnualRate extends Component {
    constructor(props) {
        super(props);
    }
    render(){
    	return(
    		<strong className={ (     this.props.investItem.isReward!=1 
                                    && this.props.investItem.isBonusticket!=1 
                                    && this.props.investItem.isAllowIncrease!=1 
                                    && this.props.investItem.isTag!=1
                                    && this.props.investItem.tenderAccountMin<=100
                                )
                                ? 'only-data' : ""
                    }
            >
                {this.props.investItem.annualRate}<b className="font-12">%</b>
                {
                    (this.props.investItem.increaseApr > 0)
                    ? <b className="font-22">+{this.props.investItem.increaseApr}</b>
                    : null
                }
                {
                    (this.props.investItem.increaseApr > 0)
                    ? <b className="font-12">%</b>
                    :null
                }
            </strong>
    	)
    }
}

AnnualRate.PropTypes = {
	investItem: PropTypes.object
}

export default AnnualRate;