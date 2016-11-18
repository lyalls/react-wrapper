//
//  MyTransferTransferTableViewCell.m
//  BaoCai
//
//  Created by baocai on 16/9/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTransferTransferTableViewCell.h"

@interface MyTransferTransferTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePeriod;

@end

@implementation MyTransferTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topLineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.topLineView width:Screen_width - 20 lineLength:1 lineSpacing:1 lineColor:RGB_COLOR(242, 242, 242)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)infoBtnClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"转让成功后收取" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)reloadData:(MyTransferListItemModel *)model {
    self.nameLabel.text = model.name;
    self.investmentAmountLabel.text = [NSString stringWithFormat:@"%@元", model.investmentAmount];
    self.transferAmountLabel.text = [NSString stringWithFormat:@"%@元", model.transferAmount];
    self.counterFeeLabel.text = [NSString stringWithFormat:@"%@元", model.counterFee];
    self.transferTimeLabel.text = model.transferTime;
    self.changePeriod.text = [NSString stringWithFormat:@"剩余%@期/共%@期", model.changePeriod, model.borrowPeriod];
}

#pragma mark - Private method

- (void)drawDashLineWithLineView:(UIView *)lineView width:(CGFloat)width lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.bounds) / 2, CGRectGetHeight(lineView.bounds))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.bounds)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, width, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
