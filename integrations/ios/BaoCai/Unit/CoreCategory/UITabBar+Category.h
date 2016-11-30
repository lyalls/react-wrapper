//
//  UITabBar+Category.h
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/5/4.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Category)

- (void)showBadgeOnItemIndex:(int)index;

- (void)hideBadgeOnItemIndex:(int)index;
-(void)setTopLineColor:(UIColor*)color;
@end

@interface BadgePointView : UIView

@end
