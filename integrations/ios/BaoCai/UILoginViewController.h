//
//  UILoginViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginCallback)(BOOL isLog);

@interface UILoginViewController : UIViewController

//打开登录
-(void) show:(UIViewController*)parent callback:(loginCallback)callback;
@end
