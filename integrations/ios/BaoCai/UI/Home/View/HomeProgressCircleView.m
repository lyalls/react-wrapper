//
//  HomeProgressCircleView.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "HomeProgressCircleView.h"

@implementation HomeProgressCircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextAddArc(context, (self.bounds.size.width) / 2, (self.bounds.size.height) / 2, (self.bounds.size.width - 10) / 2, -PI / 2, 2 * PI, 0);
    CGContextSetStrokeColorWithColor(context, RGB_COLOR(239, 239, 239).CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetLineWidth(context, 5);
    CGContextAddArc(context, (self.bounds.size.width) / 2, (self.bounds.size.height) / 2, (self.bounds.size.width - 10) / 2, -PI / 2, (self.percent * 2 * PI) / 100 - PI / 2, 0);
    CGContextSetStrokeColorWithColor(context, OrangeColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
