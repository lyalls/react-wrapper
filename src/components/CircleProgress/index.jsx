import React , {Component, PropTypes} from 'react';
import BaseComponent, { RGB_Decimal2String } from '../BaseComponent/index.jsx';
import $ from 'jquery';

let id = 0;

class CircleProgress extends Component {
	constructor(props) {
		super(props);
		this.stats={};
        this.stats.arcsId='CircleProgressArcs'+id;
        this.stats.circleId='CircleProgress'+id;
		id++;

		this.stats.strokeWidth = this.props.strokeWidth === undefined ? 2 : this.props.strokeWidth;
		this.stats.startAngle = this.props.startAngle === undefined ? 0 : this.props.startAngle;
		this.stats.backgroundStrokeColor = this.props.backgroundStrokeColor || "#DDDDDD";
		this.stats.tintStrokeColor = this.props.tintStrokeColor || "#AAAAAA";
		this.stats.backgroundFillColor = this.props.backgroundFillColor || "none";
		this.stats.tintFillColor = this.props.tintFillColor || "none";
		this.stats.dashArray = this.props.dashArray || "750";
		this.stats.lineCap = this.props.lineCap || "rect";
	}
	componentDidMount() {
        this.setCircleProgress((this.props.progress||0)*2*Math.PI , this.props.doAnimation);
    }
    setCircleProgress(progress, doAnimation=false){
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
            for (let i = 0; i < 2; i++) {
                //var n = Math.random()*Math.PI*1.99999;
                let targetArc = i===0 ? 2*Math.PI : (doAnimation ? perc: progress);
                let radius = that.props.radius-that.stats.strokeWidth/2;
                let startAngle = that.stats.startAngle;
                let targetAngle = targetArc+that.stats.startAngle;
                let x = -(that.props.extendRadius || 0);
                let y = -(that.props.extendRadius || 0);
                 $('<path />').attr('d', createSvgArc(x, y, radius, startAngle, targetAngle))
                    .attr('stroke', i===0 ? that.stats.backgroundStrokeColor : that.stats.tintStrokeColor)
                    .attr('stroke-width', that.stats.strokeWidth)
                    .attr('stroke-dasharray', that.stats.dashArray)
                    .attr('stroke-linecap', that.stats.lineCap)
                    .attr('fill', that.stats.tintFillColor)
                    .appendTo($('#'+that.stats.arcsId))
                if(i==1 && that.props.anchorStyle === 'round' &&  targetAngle - startAngle < Math.PI * 1.98 ){
                    let paints = ['M', x + Math.cos(targetAngle)*radius , y - Math.sin(targetAngle)*radius];
                    Array.prototype.push.apply(paints, [
                        'A', that.stats.strokeWidth/2 + 0.5, that.stats.strokeWidth/2 + 0.5, 
                             targetAngle, 
                             1, 0, 
                             x + Math.cos(targetAngle+(that.stats.strokeWidth/2+0.5)/radius*Math.PI)*radius ,
                             y - Math.sin(targetAngle+(that.stats.strokeWidth/2+0.5)/radius*Math.PI)*radius ,
                        'A', that.stats.strokeWidth/2 + 0.5, that.stats.strokeWidth/2 + 0.5, 
                             targetAngle, 
                             1, 0, 
                             x + Math.cos(targetAngle)*radius , y - Math.sin(targetAngle)*radius
                    ]);
                    $('<path />').attr('d', paints.join(' '))
                    .attr('stroke', that.stats.tintStrokeColor)
                    .attr('stroke-width', 1)
                    .attr('fill', "#fff")
                    .appendTo($('#'+that.stats.arcsId))
                }
            }
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
            if (endAngle - startAngle >= Math.PI*2 ) {
                endAngle = ((Math.PI*1.99999 + startAngle)*1000 % (Math.PI*2*1000))/1000;
            }

            var largeArc = endAngle - startAngle <= Math.PI ? 0 : 1;

            var paints = ['M', x+Math.cos(startAngle)*r, y-(Math.sin(startAngle)*r),
                'A', r, r, 0, largeArc, 0, x+Math.cos(endAngle)*r, y-(Math.sin(endAngle)*r),
            ];
            return paints.join(' ');
            // return ['M', x, y,
            //     'L', x+Math.cos(startAngle)*r, y-(Math.sin(startAngle)*r), 
            //     'A', r, r, 0, largeArc, 0, x+Math.cos(endAngle)*r, y-(Math.sin(endAngle)*r),
            //     'L', x, y
            // ].join(' ');
        }
    }
	render() {
		return (
			<BaseComponent id={this.stats.circleId} absolute width={2*this.props.radius + 2*(this.props.extendRadius || 0)} height={2*this.props.radius+ 2*(this.props.extendRadius || 0)} top={0} left={0} >
	            <svg width={"100%"} height={"100%"}>
	                <circle cx={this.props.radius+ (this.props.extendRadius || 0)} 
                        cy={this.props.radius+ (this.props.extendRadius || 0)} 
                        r={this.props.radius-this.stats.strokeWidth/2} 
	                    stroke="none"
	                    strokeWidth={this.stats.strokeWidth}
	                    fill={this.stats.backgroundFillColor}
                        strokeDasharray={this.stats.dashArray}
	                    strokeLinecap={this.stats.lineCap}
	                />
	                <g id={this.stats.arcsId} transform={" translate("+this.props.radius + " " + this.props.radius + ") rotate(-90) scale(1 -1)"}></g>
	            </svg>
	        </BaseComponent>
        )
	}
}

CircleProgress.PropTypes = {
	progress: PropTypes.number,
	radius: PropTypes.number.isRequired,
	strokeWidth: PropTypes.number,
	startAngle: PropTypes.number,
	backgroundStrokeColor: PropTypes.string,
	tintStrokeColor: PropTypes.string,
	backgroundFillColor: PropTypes.string,
	tintFillColor: PropTypes.string,
	dashArray: PropTypes.string,
	lineCap: PropTypes.string,
	doAnimation: PropTypes.bool,
    anchorStyle: PropTypes.string,
    extendRadius: PropTypes.number,
}

export default CircleProgress;