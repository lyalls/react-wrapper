//
//  UIBindPhoneViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BindPhoneSuccess)(NSString *phoneNum);

@interface UIBindPhoneViewController : UITableViewController

@property (nonatomic, strong) BindPhoneSuccess block;

@property (nonatomic, strong) NSDictionary *userInfoDic;

@end
