import React , {Component, PropTypes} from 'react';
import BaseComponent from '../BaseComponent/index.jsx';

class NoviceItem extends Component {
	constructor(props) {
		super(props);
	}
	render(){
		let heightScale = window.innerHeight - 113 > 568 - 113 ? (window.innerHeight - 113) / (568 - 113) : 1 ;
		return (
			<BaseComponent height={400} fullWidth className={"novice-item"}>
				<BaseComponent height={76} width={19} x={25} y={0} 
					className={"novice-item-icon"} 
					style={{backgroundSize: "19px 76px"}}
				/>
				<BaseComponent left={50} right={50} top={8 * heightScale} height={30} className={"novice-item-name-label"} />
				{/* Missing progress circle view */}
				<BaseComponent centerX={0} centerY={0} width={177 * heightScale} height={177 * heightScale}>
					<BaseComponent left={15} right={15} top={15} bottom={15}
						className={"novice-item-circle-bg"}  
						style = {{backgroundSize: (177 * heightScale - 30) +'px'}}
					/>
				</BaseComponent>
			</BaseComponent>
		);
	}
}

export default NoviceItem;

