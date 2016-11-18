//
//  MyTenderCapitalCollectionViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTenderCapitalCollectionViewCell.h"

@interface MyTenderCapitalCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MyTenderCapitalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.valueLabel.font = [UIFont systemFontOfSize:12 * homeHeightScale];
    self.nameLabel.font = [UIFont systemFontOfSize:11 * homeHeightScale];
    
    self.lineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.lineView width:1 lineLength:1 lineSpacing:1 lineColor:RGB_COLOR(242, 242, 242)];
}

#pragma mark - Custom Method

- (void)reloadData:(NSMutableDictionary *)dic isEnd:(BOOL)isEnd isCenter:(BOOL)isCenter {
    self.valueLabel.text = [dic objectForKey:@"value"];
    self.valueLabel.textAlignment = isCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.nameLabel.textAlignment = isCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    
    self.lineView.hidden = isEnd;
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
