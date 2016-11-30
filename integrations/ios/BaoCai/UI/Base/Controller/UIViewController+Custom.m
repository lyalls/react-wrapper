//
//  UIViewController+Custom.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIViewController+Custom.h"

#import "UILoginViewController.h"
#import "UIWebBrowserViewController.h"
#import "UIMyTableViewController.h"

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
    
    if ([self.navigationController.visibleViewController isKindOfClass:[UIMyTableViewController class]]) {
        [self.navigationController.navigationBar removeBottomBorder];
    } else {
        [self.navigationController.navigationBar setBottomBorderColor:RGB_COLOR(229, 229, 229) height:0.5];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    if ([self.navigationController.visibleViewController isKindOfClass:[UIMyTableViewController class]]) {
        [self.navigationController.navigationBar removeBottomBorder];
    } else {
        [self.navigationController.navigationBar setBottomBorderColor:RGB_COLOR(229, 229, 229) height:0.5];
    }
}

#pragma clang diagnostic pop

- (__kindof UIViewController *)getControllerByStoryBoardType:(StoryBoardType)storyBoardType identifier:(NSString *)identifier {
    NSString *storyBoardName = @"";
    switch (storyBoardType) {
        case StoryBoardTypeMain:
            storyBoardName = @"Main";
            break;
        case StoryBoardTypeAccountSecurity:
            storyBoardName = @"AccountSecurity";
            break;
        case StoryBoardTypeRecharge:
            storyBoardName = @"Recharge";
            break;
        case StoryBoardTypeWithdrawals:
            storyBoardName = @"Withdrawals";
            break;
        case StoryBoardTypeMy:
            storyBoardName = @"My";
            break;
        case StoryBoardTypeTender:
            storyBoardName = @"Tender";
            break;
    }
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

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
    [LoginRegisterRequest logoutRequestWithSuccess:nil failure:nil];
    [UserDefaultsHelper sharedManager].userInfo = nil;
    [UserDefaultsHelper sharedManager].gesturePwd = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)openWebBrowserWithUrl:(NSString *)url {
    [self openWebBrowserWithUrl:url model:nil];
}

- (void)openWebBrowserWithUrl:(NSString *)url model:(id)model {
    if (url.length == 0) return;
    UIWebBrowserViewController *webBrowser = [[UIWebBrowserViewController alloc] init];
    webBrowser.hidesBottomBarWhenPushed = YES;
    webBrowser.url = url;
    webBrowser.inviteFirends = model;
    [self.navigationController pushViewController:webBrowser animated:YES];
}

@end
