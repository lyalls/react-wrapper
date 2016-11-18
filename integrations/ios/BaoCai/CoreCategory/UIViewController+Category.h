//
//  UIViewController+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/9.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

- (void)setTitleColor:(UIColor *)color;

- (void)onNavigationBack;

- (void)gotoNavigationRoot;

- (void)setBackBarButtonTitle:(NSString *)title;
- (void)setLeftBarButtonTitle:(NSString *)title action:(SEL)action;
- (void)setRightBarButtonTitle:(NSString *)title action:(SEL)action;

- (void)setLeftBarButtonOfDefault:(SEL)action;

- (void)setLeftBarButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action;

- (void)setRightBarButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action;

- (void)setNavigationBarWithColor:(UIColor *)color;

- (void)setNavigationBarWithImage:(UIImage *)image;

- (NSString *)cellIdentifier;

@end
