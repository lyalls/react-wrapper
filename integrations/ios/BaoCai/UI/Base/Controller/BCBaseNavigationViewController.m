//
//  BCBaseNavigationViewController.m
//  BaoCai
//
//  Created by lishuo on 16/11/16.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBaseNavigationViewController.h"

@interface BCBaseNavigationViewController ()

@end

@implementation BCBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB_COLOR(32, 33, 35), NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
     self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated isHidesBottomBar:(BOOL)hidden {
    if (hidden == YES) {
        [self pushViewController:viewController animated:animated];
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
        [super pushViewController:viewController animated:animated];
    }
}

@end
