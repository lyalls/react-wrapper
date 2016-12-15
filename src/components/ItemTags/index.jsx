import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class ItemTags extends Component {
    constructor(props) {
        super(props);
    }
    render(){
        let isRead = (this.props.investItem.isReward==1)? <span className="take">{this.props.investItem.promotionTitle}</span> : null;
        let isBonusTicket = (this.props.investItem.isBonusticket == 1) ? <span >红包券</span> : null;
        let isAllowIncrease = (this.props.investItem.isAllowIncrease == 1) ? <span>加息券</span> : null;
        let isTag = (this.props.investItem.isTag == 1) ? <span>{this.props.investItem.tagTitle}</span> : null;
        let isLimitMinAmount = (this.props.tenderAccountMin > 100) ? <span>{this.props.StartInvestTag}元起投</span> : null;
    	return(
    		<div>
                {isRead}
                {isBonusTicket}
                {isAllowIncrease}
                {isTag}
                {isLimitMinAmount}
            </div>
    	)
    }
}

ItemTags.PropTypes = {
	investItem: PropTypes.object
}

export default ItemTags;