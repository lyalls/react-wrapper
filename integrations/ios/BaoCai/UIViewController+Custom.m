//
//  UIViewController+Custom.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIViewController+Custom.h"

#import "UILoginViewController.h"
#import "UIWebBrowserViewController.h"
#import "UIWebViewController.h"
#import "UIViewController+WebView.h"

#import "LoginRegisterRequest.h"

#import "EMSDK.h"

@implementation UIViewController (Custom)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)viewDidLoad {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

#pragma clang diagnostic pop

- (__kindof UIViewController *)getControllerByMainStoryWithIdentifier:(NSString *)identifier {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)presentTranslucentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IOS8) {
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:animated completion:^{
        }];
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:viewController animated:animated completion:^{
            viewController.view.superview.backgroundColor = [UIColor clearColor];
        }];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

- (void)toLoginViewController {
    UIStoryboard *loginRegisterStoryboard = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
    
    UILoginViewController *view = [loginRegisterStoryboard instantiateViewControllerWithIdentifier:@"LoginViewNav"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)logoutMethod {
    [UserDefaultsHelper sharedManager].isShow401Alert = NO;
    [UserDefaultsHelper sharedManager].userInfo = nil;
    [UserDefaultsHelper sharedManager].gesturePwd = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)show401FailureMethod {
    [UserDefaultsHelper sharedManager].isShow401Alert = NO;
    [UserDefaultsHelper sharedManager].userInfo = nil;
    [UserDefaultsHelper sharedManager].gesturePwd = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)skipMyMethod {
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)openWebBrowserWithUrl:(NSString *)url {
    [self openWebBrowserWithUrl:url model:nil];
}

- (void)openWebBrowserWithUrl:(NSString *)url model:(id)model {
    if (url.length == 0) return;
    UIWebBrowserViewController *webBrowser = [self getControllerByMainStoryWithIdentifier:@"UIWebBrowserViewController"];
    webBrowser.hidesBottomBarWhenPushed = YES;
    webBrowser.url = url;
    webBrowser.inviteFirends = model;
    [self.navigationController pushViewController:webBrowser animated:YES];
}

- (void)openWebWithUrl:(NSString *)url {
    if (url.length == 0) return;
    UIWebViewController *web = [[UIWebViewController alloc] init];
    web.hidesBottomBarWhenPushed = YES;
    web.req = [self getWebBrowserRequestWithUrl:url];
    web.canScroll = YES;
    [self.navigationController pushViewController:web animated:YES];
}

@end
