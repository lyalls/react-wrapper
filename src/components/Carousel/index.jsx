import React, {Component, PropTypes} from 'react';
import Slider from 'react-slick';
// require('slick-carousel');

class Carousel extends Component {
    constructor(props) {
        super(props);
        
    }

    render(){
        let settings = {
                    dots: this.props.items && this.props.items.length > 1, 
                    infinite: true,
                    speed: 500,
                    arrows: false,
                    autoplay: true,
                    autoplaySpeed: 5000
                };
        if(this.props.items && this.props.items.length > 0){
            let content = this.props.items.map( (item, i) => (
                        <a key = { 'banner' + i } id={'banner'+i} href={item.actionUrl}>
                            <img src={item.imageUrl} />
                        </a>
                    )) ;
            return (
                <Slider {...settings}>
                { content }
                </Slider>
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