//
//  AppDelegate.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "UIStartAdvertViewController.h"
#import "UIGesturePwdViewController.h"
#import "UINewTicketListViewController.h"
#import "UITraderPasswordViewController.h"
#import "UITenderSuccessViewController.h"
#import "UIPickerViewController.h"
#import "UIShareViewController.h"
#import "UIMyTenderDetailViewController.h"
#import "UITransferListViewController.h"

#import "GuideView.h"
#import "HomeTicketView.h"

#import "GeneralRequest.h"
#import "LoginRegisterRequest.h"
#import "MyRequest.h"

#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMMobClick/MobClick.h"
#import "DeviceUtils.h"

#import "EMSDK.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, UITabBarControllerDelegate, UIStartAdvertViewControllerDelegate, UIGesturePwdDelegate>

@property (nonatomic, strong) UIGesturePwdViewController *gesturePwdView;

@property (nonatomic, strong) HomeTicketView *homeTicketView;

@property (nonatomic, assign) BOOL isCheckGesture;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *openUrl;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerThirdLibraryWithOptions:launchOptions];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB_COLOR(32, 33, 35), NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    
    [[UITabBar appearance] setTintColor:RGB_COLOR(253, 149, 44)];
    
    [UserDefaultsHelper sharedManager].isShow401Alert = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:RegisterSuccessNotification object:nil];
    
    self.tabbarController = (UITabBarController *)self.window.rootViewController;
    self.tabbarController.delegate = self;
    
    [GeneralRequest getBankAreaListWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if (![[dic stringForKey:@"bankAreaVersion"] isEqualToString:[UserDefaultsHelper sharedManager].bankAreaVersion]) {
                [[UserDefaultsHelper sharedManager] setBankAreaVersion:[dic stringForKey:@"bankAreaVersion"]];
                [[UserDefaultsHelper sharedManager] setAreaList:[dic objectForKey:@"areaList"]];
                [[UserDefaultsHelper sharedManager] setBankList:[dic objectForKey:@"bankList"]];
                [[UserDefaultsHelper sharedManager] setBankSupportList:[dic objectForKey:@"bankSupportList"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    if (![UserDefaultsHelper sharedManager].isFirstEnter) {
        [UserDefaultsHelper sharedManager].isFirstEnter = YES;
        
        [GeneralRequest sendIDFA];
    }
    
    [[UserDefaultsHelper sharedManager] setDeviceToken:nil];
    
    [self.window makeKeyAndVisible];
    if ([UserInfoModel sharedModel].token) {
        [LoginRegisterRequest refreshTokenWithSuccess:^(NSDictionary *dic, BCError *error) {
            if (error.code == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
            }
        } failure:^(NSError *error) {
            
        }];
        
        if ([UserDefaultsHelper sharedManager].gesturePwd) {
            self.isCheckGesture = YES;
            if (self.gesturePwdView == nil) {
                self.gesturePwdView = [[UIGesturePwdViewController alloc] init];
                self.gesturePwdView.delegate = self;
            }
            [self.gesturePwdView show:NO];
        }
    }
    
    if (![[UserDefaultsHelper sharedManager].version isEqualToString:VERSION]) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GuideView" owner:self options:nil];
        GuideView *guideView = [nib firstObject];
        guideView.frame = Screen_bounds;
        [guideView reloadData];
        [self.window addSubview:guideView];
        
        [UserDefaultsHelper sharedManager].version = VERSION;
    }
    //修改webview useragent
    UIWebView *webView = [[UIWebView alloc] init];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    //修改agent
    NSString *newUagent = [NSString stringWithFormat:@"%@/BaoCaiApp",secretAgent];
    NSDictionary *dictionary = @{@"UserAgent":newUagent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIStartAdvertViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier:@"UIStartAdvertViewController"];
    view.delegate = self;
    [self.window addSubview:view.view];
    [self.window bringSubviewToFront:view.view];
    //copy www to doc
    NSString * path = [NSString stringWithFormat:@"%@www",[DeviceUtils documentsPath]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:path] || [self checkUpdate])
    {
        [fm removeItemAtPath:path error:nil];
        NSString* source = [[NSBundle mainBundle] pathForResource:@"www" ofType:@""];
        NSLog(@"path:%@",source);
        NSError* error;
        BOOL res = [fm copyItemAtPath:source toPath:path error:&error];
        if(!res)
        {
            NSLog(@"error:%@",error);
        }
    }
    
    //更新检查,测试
    NSString* ver = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",path,@"/version.txt"] encoding:NSUTF8StringEncoding error:nil];
    ver = [ver stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [HTTPRequest updateWebSite:WEBUPDATE version:ver success:^(NSDictionary *dic, BCError *error) {
        
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        if (self.isCheckGesture) {
            self.userInfo = userInfo;
        } else {
            [self openReceiveRemoteNotification:userInfo];
        }
    }
    
    return YES;
}

- (void)registerThirdLibraryWithOptions:(NSDictionary *)launchOptions {
    //友盟推送
    [UMessage startWithAppkey:UMENGKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setAutoAlert:NO];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        } else {
            
        }
    }];
    
    //友盟分享
    [UMSocialData setAppKey:UMENGKEY];
    [UMSocialWechatHandler setWXAppId:WECHATAPPID appSecret:WECHATAPPSECRET url:@""];
    [UMSocialQQHandler setQQWithAppId:QQAPPID appKey:QQAPPKEY url:@""];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SINAWEIBOAPPKEY secret:SINAWEIBOSECRET RedirectURL:SINAWEIBOREDIRECTURL];
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
    
    //友盟统计
    UMConfigInstance.appKey = UMENGKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:SHORTVERSION];
    
#if DEBUG
    [UMessage setLogEnabled:YES];
    [UMSocialData openLog:YES];
#else
    [UMessage setLogEnabled:NO];
    [UMSocialData openLog:NO];
#endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
        EMOptions *options = [EMOptions optionsWithAppkey:CustomServiceAppKey];
        options.apnsCertName = CustomServiceAPNsCertName;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    });
}

-(BOOL) checkUpdate
{
    NSString* oldver = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@www/version.txt",[DeviceUtils documentsPath]] encoding:NSUTF8StringEncoding error:nil];
    NSString* newver = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"www/version" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    return (NSOrderedDescending == [newver compare:oldver]);
}

-(void) showSetPwd:(UIViewController*)vc userinfo:(NSDictionary*)userinfo callback:(void (^)(void))callback
{
    UIGesturePwdViewController* view  = [[UIGesturePwdViewController alloc] init];
    view.delegate = self;
    view.pwdCallback = callback;
    [view setIsSet:YES];
    view.userInfo = userinfo;
    [vc presentViewController:view animated:YES completion:nil];
}

#pragma mark - 环信客服

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    //收起输入键盘
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    if ([UserInfoModel sharedModel].token) {
        [LoginRegisterRequest refreshTokenWithSuccess:^(NSDictionary *dic, BCError *error) {
            if (error.code == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
            }
        } failure:^(NSError *error) {
            
        }];
        
        if ([UserDefaultsHelper sharedManager].isShareExit) {
            [UserDefaultsHelper sharedManager].isShareExit = NO;
            return;
        }
        if ([UserDefaultsHelper sharedManager].gesturePwd) {
            self.isCheckGesture = YES;
            if (self.gesturePwdView == nil) {
                self.gesturePwdView = [[UIGesturePwdViewController alloc] init];
                self.gesturePwdView.delegate = self;
            }
            [self.gesturePwdView show:NO];
        }
    }
}

#pragma mark - 友盟推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UserDefaultsHelper sharedManager] setDeviceToken:token];
    
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        if (self.isCheckGesture) {
            self.userInfo = userInfo;
        } else {
            [self openReceiveRemoteNotification:userInfo];
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
        if (self.isCheckGesture) {
            self.userInfo = userInfo;
        } else {
            [self openReceiveRemoteNotification:userInfo];
        }
    }
}

- (void)openReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"type"]) {
        NSInteger type = [userInfo integerForKey:@"type"];
        switch (type) {
                //充值成功
                case 1:
                //散标还款到账-“按月付息”利息
                case 3:
                //散标还款到账- “按月付息”本金和利息
                case 4:
                //散标还款到账- “等额本息”本金和利息
                case 5:
                //债权转让成功
                case 6:
            {
                UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
                if ([controller.visibleViewController isKindOfClass:[UITraderPasswordViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UITenderSuccessViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIPickerViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIShareViewController class]]) {
                    [controller.visibleViewController dismissViewControllerAnimated:NO completion:^{
                        [controller.visibleViewController skipMyMethod];
                    }];
                } else {
                    [controller.visibleViewController skipMyMethod];
                }
            }
                break;
                //满标复审通过
                case 2:
            {
                UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
                if ([controller.visibleViewController isKindOfClass:[UITraderPasswordViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIPickerViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIShareViewController class]]) {
                    [controller.visibleViewController dismissViewControllerAnimated:NO completion:^{
                        UIMyTenderDetailViewController *view = [controller.visibleViewController getControllerByMainStoryWithIdentifier:@"UIMyTenderDetailViewController"];
                        view.tenderItemModel = [[MyTenderListItemModel alloc] initWithDic:userInfo];
                        [controller.visibleViewController.navigationController pushViewController:view animated:YES];
                    }];
                } else {
                    UIMyTenderDetailViewController *view = [controller.visibleViewController getControllerByMainStoryWithIdentifier:@"UIMyTenderDetailViewController"];
                    view.tenderItemModel = [[MyTenderListItemModel alloc] initWithDic:userInfo];
                    [controller.visibleViewController.navigationController pushViewController:view animated:YES];
                }
            }
                break;
                //购买转让标成功
                case 7:
            {
                UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
                if ([controller.visibleViewController isKindOfClass:[UITraderPasswordViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIPickerViewController class]] ||
                    [controller.visibleViewController isKindOfClass:[UIShareViewController class]]) {
                    [controller.visibleViewController dismissViewControllerAnimated:NO completion:^{
                        UITransferListViewController *view = [controller.visibleViewController getControllerByMainStoryWithIdentifier:@"UITransferListViewController"];
                        view.showPageIndex = 3;
                        [controller.visibleViewController.navigationController pushViewController:view animated:YES];
                    }];
                } else {
                    UITransferListViewController *view = [controller.visibleViewController getControllerByMainStoryWithIdentifier:@"UITransferListViewController"];
                    view.showPageIndex = 3;
                    [controller.visibleViewController.navigationController pushViewController:view animated:YES];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 友盟分享

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark - UITabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.viewControllers indexOfObject:viewController] == 3) {
        if (![UserInfoModel sharedModel].token) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotification object:nil];
            [viewController toLoginViewController];
            
            return NO;
        }
    }
    return YES;
}

- (void)loginSuccess {
    [self.tabbarController setSelectedIndex:3];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSuccessNotification object:nil];
}

#pragma mark - Notification

- (void)registerSuccess {
    if ([UserInfoModel sharedModel].rewardMsg && [UserInfoModel sharedModel].rewardMsg.count == 3) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTicketView" owner:nil options:nil];
        self.homeTicketView = [nib firstObject];
        self.homeTicketView.frame = CGRectMake(0, 0, Screen_width, Screen_height);
        WS(weakSelf);
        self.homeTicketView.block = ^() {
            [weakSelf.homeTicketView removeFromSuperview];
            
            UINavigationController *controller = (UINavigationController *)[weakSelf.tabbarController.viewControllers objectAtIndex:weakSelf.tabbarController.selectedIndex];
            UINewTicketListViewController *view = [controller.visibleViewController getControllerByMainStoryWithIdentifier:@"UINewTicketListViewController"];
            view.couponType = RedPacketCoupon;
            [controller.visibleViewController.navigationController pushViewController:view animated:YES];
        };
        [self.homeTicketView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf.homeTicketView removeFromSuperview];
        }];
        [self.homeTicketView reloadData:[UserInfoModel sharedModel].rewardMsg];
        [self.window addSubview:self.homeTicketView];
    }
}

#pragma mark - UIStartAdvertViewControllerDelegate

- (void)startAdvertOpenUrl:(NSString *)url {
    if (self.isCheckGesture) {
        self.openUrl = url;
    } else {
        [self openWebBrowserWithUrl:url];
    }
}

- (void)openWebBrowserWithUrl:(NSString *)url {
    UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:0];
    [controller.visibleViewController openWebBrowserWithUrl:url];
}

#pragma mark - UIGesturePwdDelegate

- (void)unlockSuccess {
    [self.gesturePwdView hide];
    if (self.userInfo) {
        [self openReceiveRemoteNotification:self.userInfo];
        self.userInfo = nil;
    }
    if (self.openUrl) {
        [self openWebBrowserWithUrl:self.openUrl];
        self.openUrl = nil;
    }
}

- (void)showLoginView {
    SHOWPROGRESSHUD;
    [LoginRegisterRequest logoutRequestWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [self.gesturePwdView hide];
            UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
            if ([controller.visibleViewController isKindOfClass:[UITraderPasswordViewController class]] ||
                [controller.visibleViewController isKindOfClass:[UITenderSuccessViewController class]] ||
                [controller.visibleViewController isKindOfClass:[UIPickerViewController class]] ||
                [controller.visibleViewController isKindOfClass:[UIShareViewController class]]) {
                [controller.visibleViewController dismissViewControllerAnimated:NO completion:^{
                    [controller.visibleViewController logoutMethod];
                    [controller.visibleViewController toLoginViewController];
                }];
            } else {
                [controller.visibleViewController logoutMethod];
                [controller.visibleViewController toLoginViewController];
            }
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"退出失败，请稍后再试");
    }];
}

@end
