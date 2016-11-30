//
//  UINavigationBar+Category.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/25.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UINavigationBar+Category.h"

@implementation UINavigationBar (Category)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    if ([self viewWithTag:9999]) {
        return;
    }
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    bottomBorder.tag = 9999;
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}

- (void)removeBottomBorder {
    if ([self viewWithTag:9999]) {
        [[self viewWithTag:9999] removeFromSuperview];
    }
}

@end
