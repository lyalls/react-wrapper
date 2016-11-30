//
//  AppDelegate.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCBaseTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BCBaseTabBarViewController *tabbarController;

-(void) showSetPwd:(UIViewController*)vc userinfo:(NSDictionary*)userinfo callback:(void (^)(void))callback;

@end
