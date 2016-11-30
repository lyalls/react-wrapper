//
//  UIAlertView+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickedButtonBlock) (NSInteger buttonIndex);

typedef void (^ClickedButtonBlockWithAlertView) (UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (Category)

- (void)clickedButtonEvent:(ClickedButtonBlock)event;
- (void)clickedButtonEventWithAlertView:(ClickedButtonBlockWithAlertView)event;

@end
