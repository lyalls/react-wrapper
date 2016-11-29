//
//  UIViewController+Custom.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMMobClick/MobClick.h"

@interface UIViewController (Custom) <UIGestureRecognizerDelegate, UITabBarControllerDelegate>

- (__kindof UIViewController *)getControllerByMainStoryWithIdentifier:(NSString *)identifier;

- (void)presentTranslucentViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)toLoginViewController;

- (void)logoutMethod;

- (void)show401FailureMethod;

- (void)skipMyMethod;

- (void)openWebBrowserWithUrl:(NSString *)url;

- (void)openWebBrowserWithUrl:(NSString *)url model:(id)model;

- (void)openWebWithUrl:(NSString *)url;

@end
