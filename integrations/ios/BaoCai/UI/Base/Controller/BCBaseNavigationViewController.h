//
//  BCBaseNavigationViewController.h
//  BaoCai
//
//  Created by lishuo on 16/11/16.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCBaseNavigationViewController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated isHidesBottomBar:(BOOL)hidden;

@end
