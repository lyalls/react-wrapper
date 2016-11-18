//
//  TenderProgressCircleView.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderProgressCircleView.h"

@implementation TenderProgressCircleView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGFloat lengths[] = {((self.bounds.size.width - 2) * PI) * 0.08, ((self.bounds.size.width) * PI) * 0.02};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextAddArc(context, (self.bounds.size.width) / 2, (self.bounds.size.height) / 2, (self.bounds.size.width - 2) / 2, -PI / 2, 2 * PI, 0);
    CGContextSetStrokeColorWithColor(context, RGB_COLOR(239, 239, 239).CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, (self.bounds.size.width) / 2, (self.bounds.size.height) / 2, (self.bounds.size.width - 2) / 2, -PI / 2, (self.percent * 2 * PI) / 100 - PI / 2, 0);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
