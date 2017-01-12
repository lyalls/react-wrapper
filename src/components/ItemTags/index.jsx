import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class ItemTags extends Component {
    constructor(props) {
        super(props);
    }
    componentDidMount() {
    }
    render(){
        let isRead = (this.props.investItem.isReward==1)
                        ? (this.props.isNativeApp) 
                            ? {type: 'promotionTag', className: 'app-palered-tag take'}
                            :<span key="itemTag1" className="take">{this.props.investItem.promotionTitle}</span> 
                        : null;

        let isBonusTicket = (this.props.investItem.isBonusticket == 1) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'bonusTicket'}
                            : <span key="itemTag2" >红包券</span> 
                        : null;

        let isAllowIncrease = (this.props.investItem.isAllowIncrease == 1) 
                        ? (this.props.isNativeApp) 
                            ? {type: 'allowIncrease'}
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
                t.tail = null;
                t.head = null;
                if(t === firstTag){
                    if(t===lastTag || lastTag === null){
                        lastTag = t;
                        t.className = "act-tag-type-4" + ( t.className ? " "+t.className : "");
                        t.head = <s></s>;
                        t.tail = <b></b>;
                    }else{
                        t.className = "act-tag-type-1" + ( t.className ? " "+t.className : "");
                        t.head = <s></s>;
                    }
                }else if(t === lastTag){
                    t.className = "act-tag-type-3" + ( t.className ? " "+t.className : "");
                    t.head = <s></s>;
                }else{
                    t.className = "act-tag-type-2" + ( t.className ? " "+t.className : "");
                }
                t.key='itemTag_'+i;
                switch(t.type){
                case 'promotionTag':
                    return <li key={t.key}><div className={t.className}><span>{this.props.investItem.promotionTitle}</span>{t.head}{t.tail}</div></li>
                case 'bonusTicket':
                    return <li key={t.key}><div className={t.className}><span>红包券</span>{t.head}{t.tail}</div></li>
                    break;
                case 'allowIncrease':
                    return <li key={t.key}><div className={t.className}><span>加息券</span>{t.head}{t.tail}</div></li>
                    break;
                case 'limitMinAmount':
                    return <li key={t.key}><div className={t.className}><span>{this.props.investItem.StartInvestTag}元起投</span>{t.head}{t.tail}</div></li>
                    break;
                case 'tag':
                    return <li key={t.key}><div className={t.className}><span>{this.props.investItem.tagTitle}</span>{t.head}{t.tail}</div></li>
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