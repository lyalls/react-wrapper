import React , {Component, PropTypes} from 'react';
import BaseComponent, { RGB_Decimal2String } from '../BaseComponent/index.jsx';
import $ from 'jquery';

let id = 0;

class AnnualRate extends Component {
    constructor(props) {
        super(props);
        this.stats={id: 'AnnualRate'+id};
        this.stats.arcsId='AnnualRateArcs'+id;
        this.stats.circleId='AnnualRateCircle'+id;
        id++;
    }
    componentDidMount() {
        this.setCircleProgress(this.props.investItem.tenderSchedule*2*Math.PI/100);
    }
    setCircleProgress(progress, doAnimation=true){
        // Reference: https://codepen.io/smlsvnssn/pen/FolaA/
        let that=this;
        var perc = 0;
        /*$('#mapWrapper').click(function(){
        update();
        })*/
        update();
        //setInterval(update, 20);

        function update(){
            if(perc > progress) return;
            if(doAnimation){
                requestAnimationFrame(update)
            }
            // console.log(perc)
            $('#'+that.stats.arcsId).empty();
            // for (let i = 0; i < 2; i++) {
                //var n = Math.random()*Math.PI*1.99999;
                // stroke={RGB_Decimal2String("255,108,0")} strokeWidth={1.5}
                // strokeDasharray={"4,2"} strokeLinecap={"rect"}
                // fill="none"
                let targetArc = (doAnimation ? perc: progress);
                 $('<path />').attr('d', createSvgArc(0, 0, 19, 0, targetArc))
                    .attr('stroke', RGB_Decimal2String("255,108,0"))
                    .attr('stroke-width', 1.5)
                    .attr('stroke-dasharray', "8,4")
                    .attr('stroke-linecap', "rect")
                    .attr('fill', "none")
                    .appendTo($('#'+that.stats.arcsId))
            // }
            perc += Math.PI/50;
            // if(perc >= Math.PI*2) perc = 0;

            $('#'+that.stats.circleId).html($('#'+that.stats.circleId).html());
            //$('#arcs').children().attr('fill', '#000');
        }


        function createSvgArc (x, y, r, startAngle, endAngle) {
            if(startAngle>endAngle){
                var s = startAngle;
                startAngle = endAngle;
                endAngle = s;
            }
            if (endAngle - startAngle > Math.PI*2 ) {
                endAngle = Math.PI*1.99999;
            }

            var largeArc = endAngle - startAngle <= Math.PI ? 0 : 1;

            return ['M', x+Math.cos(startAngle)*r, y-(Math.sin(startAngle)*r),
                'A', r, r, 0, largeArc, 0, x+Math.cos(endAngle)*r, y-(Math.sin(endAngle)*r),
            ].join(' ');

            // return ['M', x, y,
            //     'L', x+Math.cos(startAngle)*r, y-(Math.sin(startAngle)*r), 
            //     'A', r, r, 0, largeArc, 0, x+Math.cos(endAngle)*r, y-(Math.sin(endAngle)*r),
            //     'L', x, y
            // ].join(' ');
        }

        function randomColorAsString() {
            return '#'+'0123456789abcdef'.split('').map(function(v,i,a){
            return i>5 ? null : a[Math.floor(Math.random()*16)] }).join('');
        }
    }
    render(){
    	return(
            this.props.isNativeApp 
            ?   <BaseComponent id={this.stats.id} left={28} right={0} top={12} >
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
                            <BaseComponent id={this.stats.circleId} absolute width={40} height={40} top={0} left={0} >
                                <svg width={"100%"} height={"100%"}>
                                    <circle cx={20} cy={20} r={19} 
                                        stroke={RGB_Decimal2String("239,239,239")} strokeWidth={1.5}
                                        strokeDasharray={"8,4"} strokeLinecap={"rect"}
                                        fill="none"
                                    />
                                    <g id={this.stats.arcsId} transform=" translate(20 20) rotate(-90) scale(1 -1)"></g>
                                </svg>
                            </BaseComponent>
                            <BaseComponent absolute centerY={0} centerX={0}>
                                <font style={{fontSize: 13, color: RGB_Decimal2String("255,108,0")}}>
                                    {this.props.investItem.tenderSchedule}%
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