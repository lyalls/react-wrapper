//
//  BCBaseTabBarViewController.m
//  BaoCai
//
//  Created by lishuo on 16/11/16.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBaseTabBarViewController.h"
#import "BCBaseNavigationViewController.h"
#import "UIHomeTableViewController.h"
#import "UITenderListTableViewController.h"
#import "UIDiscoverViewController.h"
#import "UIMyTableViewController.h"


@interface BCBaseTabBarViewController ()<UITabBarDelegate>

@end

@implementation BCBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *backView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] insertSubview:backView atIndex:0];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.opaque = NO;
    [self.tabBar setTintColor:RGB_COLOR(253, 149, 44)];
    [self.tabBar setTopLineColor:RGB_COLOR(229, 229, 229)];
    self.delegate = self;
    
    UIHomeTableViewController *homeViewController = [[UIHomeTableViewController alloc] init];
    BCBaseNavigationViewController *homeNav = [[BCBaseNavigationViewController alloc] initWithRootViewController:homeViewController];
    homeNav.title = @"首页";
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_1_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITenderListTableViewController *tenderListViewController = [[UITenderListTableViewController alloc] init];
    BCBaseNavigationViewController *tenderListNav = [[BCBaseNavigationViewController alloc] initWithRootViewController:tenderListViewController];
    tenderListNav.title = @"理财";
    tenderListNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tenderListNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIDiscoverViewController *discoverViewController = [[UIDiscoverViewController alloc] init];
    BCBaseNavigationViewController *discoverNav = [[BCBaseNavigationViewController alloc] initWithRootViewController:discoverViewController];
    discoverNav.title = @"发现";
    discoverNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_3_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIMyTableViewController *myViewController = [[UIMyTableViewController alloc] init];
    BCBaseNavigationViewController *myNav = [[BCBaseNavigationViewController alloc] initWithRootViewController:myViewController];
    myNav.title = @"我的";
    myNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_4_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav, tenderListNav, discoverNav, myNav, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginSuccess {
    [self setSelectedIndex:3];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSuccessNotification object:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

@end
