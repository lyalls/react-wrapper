//
//  UITabBar+Category.m
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/5/4.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import "UITabBar+Category.h"

#define TabbarItemNums 4.0

@implementation UITabBar (Category)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    CGFloat itemWidth = self.frame.size.width / TabbarItemNums;
    CGFloat itemCenterWidth = itemWidth / 2;
    CGFloat y = ceilf(0.101 * self.frame.size.height);
    BadgePointView *badgeView = [[BadgePointView alloc] initWithFrame:CGRectMake((itemWidth * index) + itemCenterWidth + 4, y, 8, 8)];
    badgeView.tag = 888 + index;
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end

@implementation BadgePointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.5, 0.5, self.frame.size.width - 1, self.frame.size.width - 1)];
    [path setLineWidth:0.5];
    [[UIColor redColor] set];
    [path fill];
    [[UIColor whiteColor] set];
    [path stroke];
}

@end
