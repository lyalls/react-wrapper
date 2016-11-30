//
//  AppDelegate.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "UIStartAdvertViewController.h"
#import "UIGesturePwdViewController.h"
#import "UINewTicketListViewController.h"

#import "GuideView.h"
#import "HomeTicketView.h"

#import "GeneralRequest.h"
#import "LoginRegisterRequest.h"
#import "MyRequest.h"

#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"

#import "JPFPSStatus.h"

#import "EMSDK.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, UITabBarControllerDelegate, UIStartAdvertViewControllerDelegate, UIGesturePwdDelegate>

@property (nonatomic, strong) UIGesturePwdViewController *gesturePwdView;

@property (nonatomic, strong) HomeTicketView *homeTicketView;

@property (nonatomic, assign) BOOL isCheckGesture;
@property (nonatomic, strong) NSString *openUrl;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerThirdLibraryWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UserDefaultsHelper sharedManager].isShow401Alert = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:RegisterSuccessNotification object:nil];
    
//    self.tabbarController = (UITabBarController *)self.window.rootViewController;
//    self.tabbarController.delegate = self;
    
    self.tabbarController = [[BCBaseTabBarViewController alloc] init];
    //self.tabbarController.delegate = self;
    
    
    
#if defined(DEBUG) || defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
    
    self.window.rootViewController = self.tabbarController;
    
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
        guideView.frame = SCREEN_BOUNDS;
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
    
    UIStoryboard *baseStoryboard = [UIStoryboard storyboardWithName:@"Base" bundle:nil];
    
    UIStartAdvertViewController *view = [baseStoryboard instantiateViewControllerWithIdentifier:@"UIStartAdvertViewController"];
    view.delegate = self;
    [self.window addSubview:view.view];
    [self.window bringSubviewToFront:view.view];
    //copy www to doc
    NSString * path = [NSString stringWithFormat:@"%@www", kDocumentsPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if((![fm fileExistsAtPath:path] || [self checkUpdate]))
    {
        [fm removeItemAtPath:path error:nil];
        NSString* source = [[NSBundle mainBundle] pathForResource:@"www" ofType:@""];
        DLog(@"path:%@", source);
        if (source) {
            NSError* error;
            BOOL res = [fm copyItemAtPath:source toPath:path error:&error];
            if(!res)
            {
                NSLog(@"error:%@",error);
            }
        }
    }
    
    //更新检查,测试
    NSString* ver = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",path,@"/version.txt"] encoding:NSUTF8StringEncoding error:nil];
    
    [HTTPRequest updateWebSite:WEBUPDATE version:ver success:^(NSDictionary *dic, BCError *error) {
        
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self openReceiveRemoteNotification:userInfo];
    
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
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENGKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WECHATAPPID appSecret:WECHATAPPSECRET redirectURL:@""];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID appSecret:QQAPPKEY redirectURL:@""];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINAWEIBOAPPKEY  appSecret:SINAWEIBOSECRET redirectURL:SINAWEIBOREDIRECTURL];
    
    //友盟统计
    UMConfigInstance.appKey = UMENGKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:SHORTVERSION];
    
#if DEBUG
    [UMessage setLogEnabled:YES];
    [[UMSocialManager defaultManager] openLog:YES];
#else
    [UMessage setLogEnabled:NO];
    [[UMSocialManager defaultManager] openLog:NO];
#endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
        EMOptions *options = [EMOptions optionsWithAppkey:CustomServiceAppKey];
        options.apnsCertName = CustomServiceAPNsCertName;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    });
}

-(BOOL) checkUpdate
{
    NSString* oldver = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@www/version.txt", kDocumentsPath] encoding:NSUTF8StringEncoding error:nil];
    NSString* newver = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"www/version" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    return [newver compare:oldver];
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
    [self openReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
        [self openReceiveRemoteNotification:userInfo];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
        [self openReceiveRemoteNotification:userInfo];
    }
}

- (void)openReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"url"]) {
        NSString *url = [userInfo objectForKey:@"url"];
        UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
        [controller.visibleViewController openWebBrowserWithUrl:url];
    }
}

#pragma mark - 友盟分享

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}



#pragma mark - Notification

- (void)registerSuccess {
    if ([UserInfoModel sharedModel].rewardMsg && [UserInfoModel sharedModel].rewardMsg.count == 3) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTicketView" owner:nil options:nil];
        self.homeTicketView = [nib firstObject];
        self.homeTicketView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        WS(weakSelf);
        self.homeTicketView.block = ^() {
            [weakSelf.homeTicketView removeFromSuperview];
            UINewTicketListViewController *view = [[UINewTicketListViewController alloc] init];
            view.hidesBottomBarWhenPushed = YES;
            view.couponType = RedPacketCoupon;
            UINavigationController *controller = (UINavigationController *)[weakSelf.tabbarController.viewControllers objectAtIndex:weakSelf.tabbarController.selectedIndex];
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
        UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:0];
        [controller.visibleViewController openWebBrowserWithUrl:url];
    }
}

#pragma mark - UIGesturePwdDelegate

- (void)unlockSuccess {
    [self.gesturePwdView hide];
    if (self.openUrl) {
        UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:0];
        [controller.visibleViewController openWebBrowserWithUrl:self.openUrl];
        self.openUrl = nil;
    }
}

- (void)showLoginView {
    [self.gesturePwdView hide];
    UINavigationController *controller = (UINavigationController *)[self.tabbarController.viewControllers objectAtIndex:self.tabbarController.selectedIndex];
    [controller.visibleViewController logoutMethod];
    [controller.visibleViewController toLoginViewController];
}

@end
