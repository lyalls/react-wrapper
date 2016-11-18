//
//  AppDelegate.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabbarController;

-(void) showSetPwd:(UIViewController*)vc userinfo:(NSDictionary*)userinfo callback:(void (^)(void))callback;

@end
