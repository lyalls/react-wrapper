import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class ItemTags extends Component {
    constructor(props) {
        super(props);
    }
    componentDidMount() {
    }
    render(){

        // <dd>
        //     <ul className="pro-act-tag">
        //         <li><div className="act-tag-type-1 app-gold-tag"><span>200元起投</span><s></s></div></li>
        //         <li><div className="act-tag-type-2 app-palered-tag"><span>加息券</span></div></li>
        //         <li><div className="act-tag-type-2 app-yellow-tag"><span>抢</span></div></li>
        //         <li><div className="act-tag-type-3"><span>红包券</span><s></s></div></li>
        //     </ul>
        // </dd>

        let isRead = (this.props.investItem.isReward==1)
                        ? (this.props.isNativeApp) 
                            ? null
                            :<span key="itemTag1" className="take">{this.props.investItem.promotionTitle}</span> 
                        : null;

        let isBonusTicket = (this.props.investItem.isBonusticket == 1) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'bonusTicket'}
                            : <span key="itemTag2" >红包券</span> 
                        : null;

        let isAllowIncrease = (this.props.investItem.isAllowIncrease == 1) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'allowIncrease', className: 'app-palered-tag'}
                            : <span key="itemTag3" >加息券</span> 
                        : null;

        let isTag = (this.props.investItem.isTag == 1) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'tag', className: 'app-yellow-tag'}
                            : <span key="itemTag4" >{this.props.investItem.tagTitle}</span> 
                        : null;

        let isLimitMinAmount = (this.props.investItem.tenderAccountMin > 100) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'limitMinAmount', className: 'app-gold-tag'}
                            : <span key="itemTag5" >{this.props.StartInvestTag}元起投</span> 
                        : null;

        let tags = [isRead, isBonusTicket, isAllowIncrease, isTag, isLimitMinAmount];

        if(this.props.isNativeApp){
            let firstTag = null, lastTag = null;
            for(let i=0; i<tags.length; i++){
                let t = tags[i];
                if(t !== null){
                    if(firstTag === null) firstTag = t;
                    else lastTag = t;
                }
            }
            tags = tags.map((t,i) =>{
                if(t===null) return null;
                if(t === firstTag){
                    if(t===lastTag || lastTag === null){
                        t.className = "act-tag-type-1" + ( t.className ? " "+t.className : "");
                    }else{
                        t.className = "act-tag-type-1 " + ( t.className ? " "+t.className : "");
                    }
                }else if(t === lastTag){
                    t.className = "act-tag-type-3 " + ( t.className ? " "+t.className : "");
                }else{
                    t.className = "act-tag-type-2 " + ( t.className ? " "+t.className : "");
                }
                let key='itemTag_'+i;
                switch(t.type){
                case 'bonusTicket':
                    return <li key={key}><div className={t.className}><span>红包券</span><s></s></div></li>
                    break;
                case 'allowIncrease':
                    return <li key={key}><div className={t.className}><span>加息券</span></div></li>
                    break;
                case 'limitMinAmount':
                    return <li key={key}><div className={t.className}><span>{this.props.StartInvestTag}</span><s></s></div></li>
                    break;
                case 'tag':
                    return <li key={key}><div className={t.className}><span>{this.props.investItem.tagTitle}</span></div></li>
                    break;
                default:
                    return null;
                    break;
                }
            });
        }

        return(
            <div>
                {tags}
            </div>
        )
    }
}

ItemTags.PropTypes = {
    investItem: PropTypes.object,
    isNativeApp: PropTypes.bool,
}

export default ItemTags;