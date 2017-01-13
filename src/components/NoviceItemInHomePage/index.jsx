import React , {Component, PropTypes} from 'react';
import BaseComponent, {RGB_Decimal2String} from '../BaseComponent/index.jsx';
import AnnualRate from '../AnnualRate/index.jsx';
import ItemTags from '../ItemTags/index.jsx';
import CircleProgress from '../CircleProgress/index.jsx';

class NoviceItem extends Component {
	constructor(props) {
		super(props);
	}
	render(){
		let heightScale = this.props.heightScale;
		let height = this.props.height;
		return (
			<BaseComponent height={height} fullWidth className={"novice-item"} onClick={this.props.onClick} backgroundColor={"#FFF"}>
				<BaseComponent height={76} width={19} x={25} y={0} 
					className={"novice-item-icon"} 
					customStyle={{backgroundSize: "19px 76px"}}
					absolute
				/>
				<BaseComponent left={50} right={50} top={8 * heightScale} height={30} 
								className={"novice-item-name-label"} absolute
								textAlign={'center'}
				>
					<BaseComponent centerX={0} centerY={0}>
					{this.props.itemTitle}
					</BaseComponent>
				</BaseComponent>
				{/* Missing progress circle view */}
				<BaseComponent centerX={0} centerY={0} width={177 * heightScale} height={177 * heightScale} absolute>
					{/* Circle progress */}
					<BaseComponent absolute left={3} right={3} top={3} bottom={3}
					>
						<CircleProgress 
							progress={(100||0)/100}
							radius={177 * heightScale / 2 - 9}
                            strokeWidth={3}
                            backgroundStrokeColor={RGB_Decimal2String("239,239,239")}
                            tintStrokeColor={RGB_Decimal2String("255,108,0")}
                            anchorStyle={"round"}
                            doAnimation
                            extendRadius={6}
						/>
					</BaseComponent>
					{/* Background image */}
					<BaseComponent absolute left={15} right={15} top={15} bottom={15}
						className={"novice-item-circle-bg"}  
						customStyle = {{backgroundSize: (177 * heightScale - 30) +'px'}}
					/>
					{/* Annual rate title */}
					<BaseComponent absolute className={"novice-item-annual-rate-title"}
									top={35*heightScale} width={47 * heightScale} height = {17 * heightScale} centerX={0}
									bgImgFitSize
					/>
					{/* Separator line */}
					<BaseComponent absolute customStyle={{backgroundColor: "#EFEFEF"}}
									top={60*heightScale} width={60*heightScale} height={1} centerX={0}
					/>
					{/* Annual rate data */}
					<BaseComponent absolute centerX={0} centerY={0} >
						<dl className="pro-info">
							<dt>
								<AnnualRate investItem={this.props.itemData} />
							</dt>
						</dl>
					</BaseComponent>
					{/* Duration */}
					<BaseComponent absolute centerX={0} bottom={30} fontSize={14 * heightScale} color={'white'} 
								sizeAdjustment={{width: 4, height: 0}} textAlign={'center'}>
						{this.props.itemData.investmentHorizon}
					</BaseComponent>
				</BaseComponent>
				{/* tags */}
				<BaseComponent absolute centerX={0} bottom={5*heightScale} >
					<dl className="pro-info">
						<dt>
							<ItemTags investItem={this.props.itemData} />
						</dt>
					</dl>
				</BaseComponent>
			</BaseComponent>
		);
	}
}

NoviceItem.PropTypes = {
	heightScale : PropTypes.number.isRequired,
	height: PropTypes.number.isRequired,
	itemData: PropTypes.object,
	itemTitle: PropTypes.element,
	onClick: PropTypes.func,
}

export default NoviceItem;

