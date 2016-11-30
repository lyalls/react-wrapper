//
//  UIGesturePwdViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^setPasswordCallback) ();

@protocol UIGesturePwdDelegate;

@interface UIGesturePwdViewController : UIViewController

@property (nonatomic, assign) id<UIGesturePwdDelegate> delegate;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, copy) setPasswordCallback pwdCallback;

- (void)show:(BOOL)isSet;
- (void)hide;
- (void)setIsSet:(BOOL)isSet;

@end

@protocol UIGesturePwdDelegate <NSObject>

@optional

- (void)setPasswordSuccess;
- (void)setPasswordFaile;

- (void)showLoginView;
- (void)unlockSuccess;

@end
