import React, {Component, PropTypes} from 'react';
import Slider from 'react-slick';

class Carousel extends Component {
    constructor(props) {
        super(props);
    }

    render(){
        if(this.props.items && this.props.items.length > 0){

            let settings = {
                    dots: (this.props.items.length > 1),
                    speed: 500,
                    arrows: false,
            }
            if(this.props.items.length > 1){
                settings = Object.assign(settings, {
                    infinite: true,
                    autoplay: true,
                    autoplaySpeed: 5000
                })
            }
            let content = this.props.items.map( (item, i) => (
                        <a  key = { 'banner' + i } 
                            id = {'banner'+i} 
                            href = { item.actionUrl }>
                            <img src = {item.imageUrl} />
                        </a>
                    ));
            return (
                <div className="wx-banner">
                    <div className="index-banner">
                    <Slider {...settings} >
                    { 
                        content
                    }
                    </Slider>
                    </div>
                </div>
            );
        }else{
            return (<div></div>)
        }
    }
}

Carousel.propTypes = {
    items: PropTypes.array
}

export default Carousel;