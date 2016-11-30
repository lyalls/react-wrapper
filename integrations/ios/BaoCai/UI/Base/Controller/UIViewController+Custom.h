//
//  UIViewController+Custom.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMMobClick/MobClick.h"

typedef NS_ENUM(NSUInteger, StoryBoardType) {
    StoryBoardTypeMain,
    StoryBoardTypeAccountSecurity,
    StoryBoardTypeRecharge,
    StoryBoardTypeWithdrawals,
    StoryBoardTypeMy,
    StoryBoardTypeTender
};

@interface UIViewController (Custom) <UIGestureRecognizerDelegate, UITabBarControllerDelegate>

- (__kindof UIViewController *)getControllerByStoryBoardType:(StoryBoardType)storyBoardType identifier:(NSString *)identifier;

//- (__kindof UIViewController *)getControllerByMainStoryWithIdentifier:(NSString *)identifier;

- (void)presentTranslucentViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)toLoginViewController;

- (void)logoutMethod;

- (void)openWebBrowserWithUrl:(NSString *)url;

- (void)openWebBrowserWithUrl:(NSString *)url model:(id)model;

@end
