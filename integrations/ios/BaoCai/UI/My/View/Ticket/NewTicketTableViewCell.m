//
//  NewTicketTableViewCell.m
//  BaoCai
//
//  Created by lishuo on 16/9/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#define RGB(r,g,b)  [UIColor colorWithRed:r green:g blue:b alpha:1.0]

#import "NewTicketTableViewCell.h"
#import "MyCoupon.h"
#import "MyRequest.h"
@interface NewTicketTableViewCell()
@property (weak,nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak,nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak,nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak,nonatomic) IBOutlet UILabel *textDetailLabel;
@property (weak,nonatomic) IBOutlet UILabel *projectDetailLabel;;
@property (weak,nonatomic) IBOutlet UIImageView *markImageView;
@property (weak,nonatomic) IBOutlet UILabel *dateDetailLabel;

//@property (strong,nonatomic) UIImage *validImage;
//@property (strong,nonatomic) UIImage *invalidImage;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *view1PositionX;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *view2PositionX;

@end



@implementation NewTicketTableViewCell

-(void)updateConstraints
{
    [super updateConstraints];
    self.view1PositionX.constant = self.view1PositionX.constant*(SCREEN_WIDTH/320);
    self.view2PositionX.constant = self.view2PositionX.constant*(SCREEN_WIDTH/320);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)reloadData:(id)model type:(NSInteger)type
{
    
    
    if([model isKindOfClass:[RaiseRatesCoupon class]])
    {
        
        RaiseRatesCoupon *rmodel = model;
        _symbolLabel.text = @"+";
        _ratioLabel.text = [NSString stringWithFormat:@"%@",rmodel.apr] ;
        _couponTypeLabel.text = @"加    息    券";
        _textDetailLabel.text = [NSString stringWithFormat:@"● %@",rmodel.useMoney];
        
        _dateDetailLabel.text = rmodel.AppExpiredTime;
        //[_dateDetailLabel sizeToFit];
        _projectDetailLabel.hidden = YES;
        
        
    }
    else
    {
        
        RedBagCoupon *rmodel = model;
        _projectDetailLabel.hidden = NO;
        _symbolLabel.text = @"￥";
        _ratioLabel.text = [NSString stringWithFormat:@"%@",rmodel.money] ;
        _couponTypeLabel.text = @"红    包    券";
        _textDetailLabel.text = [NSString stringWithFormat:@"● %@",rmodel.ticketDesc];
        _projectDetailLabel.text = [rmodel.ticketDurationDesc isEqualToString:@""]?@"":[NSString stringWithFormat:@"● %@",rmodel.ticketDurationDesc];
        
        _dateDetailLabel.text = rmodel.expiredTime;
        
        
    }
    if(type == TicketListTypeUsed)
    {
        _symbolLabel.textColor = RGB_COLOR(204, 204, 204);;
        _ratioLabel.textColor = RGB_COLOR(204, 204, 204);;//RGB(197,197,197);
        
        _couponTypeLabel.textColor = RGB_COLOR(204, 204, 204);;
        _textDetailLabel.textColor = RGB_COLOR(204, 204, 204);;
        _dateDetailLabel.textColor = RGB_COLOR(204, 204, 204);;
        _projectDetailLabel.textColor = RGB_COLOR(204, 204, 204);;
        
        _markImageView.image = [[UIImage imageNamed:@"invalid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,220,0,SCREEN_WIDTH) resizingMode:UIImageResizingModeStretch];
        
    }
    else
    {
        _symbolLabel.textColor = RGB_COLOR(228, 0, 18);
        _ratioLabel.textColor = RGB_COLOR(228, 0, 18);
        _couponTypeLabel.textColor = RGB_COLOR(228, 0, 18);
        _textDetailLabel.textColor = RGB_COLOR(228, 0, 18);
        _dateDetailLabel.textColor = RGB_COLOR(228, 0, 18);
        _projectDetailLabel.textColor = RGB_COLOR(228, 0, 18);
        _markImageView.image = [[UIImage imageNamed:@"valid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,220,0,SCREEN_WIDTH) resizingMode:UIImageResizingModeStretch];
    }
    
    
    
}

@end
