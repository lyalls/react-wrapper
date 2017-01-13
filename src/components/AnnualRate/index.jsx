import React , {Component, PropTypes} from 'react';
import BaseComponent, { RGB_Decimal2String } from '../BaseComponent/index.jsx';
import CircleProgress from '../CircleProgress/index.jsx';

class AnnualRate extends Component {
    constructor(props) {
        super(props);
    }
    componentDidMount() {
    }
    render(){
    	return(
            this.props.isNativeApp 
            ?   <BaseComponent left={28} right={0} top={14} >
                    <BaseComponent  customStyle={{width: "100%"}}>
                        <strong style={{fontSize: 20, color: RGB_Decimal2String("255,108,0")}}>
                            {this.props.investItem.annualRate}
                        </strong>
                        <font style={{fontSize: 15, color: RGB_Decimal2String("255,108,0")}}>
                            %
                        </font>
                        {
                            (this.props.investItem.increaseApr > 0)
                            ? <font style={{fontSize: 15, color: RGB_Decimal2String("255,108,0")}}>
                                +{this.props.investItem.increaseApr}
                              </font>
                            : null
                        }
                        <BaseComponent  absolute centerX={0} centerY={0}>
                            <font style={{fontSize: 15, color: RGB_Decimal2String("108,108,108")}}>
                                {this.props.investItem.investmentHorizon}
                            </font>
                        </BaseComponent>
                        <BaseComponent  absolute right={40} centerY={0} width={40} height={40}>
                            <CircleProgress
                                progress={(this.props.investItem.tenderSchedule||0)/100} 
                                radius={20}
                                strokeWidth={2}
                                backgroundStrokeColor={RGB_Decimal2String("239,239,239")}
                                tintStrokeColor={RGB_Decimal2String("255,108,0")}
                                dashArray={"8,6"}
                                doAnimation
                            />
                            <BaseComponent absolute centerY={0} centerX={0}>
                                <font style={{fontSize: 13, color: RGB_Decimal2String("255,108,0")}}>
                                    {this.props.investItem.tenderSchedule+"%"}
                                </font>
                            </BaseComponent>
                        </BaseComponent>
                    </BaseComponent>
                </BaseComponent>
            :   <strong className={ (     this.props.investItem.isReward!=1 
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
	investItem: PropTypes.object,
    isNativeApp: PropTypes.bool
}

export default AnnualRate;