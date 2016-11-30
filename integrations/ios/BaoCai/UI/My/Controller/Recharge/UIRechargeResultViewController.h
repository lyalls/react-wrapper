//
//  UIRechargeResultViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRechargeResultViewController : UIViewController

@property (nonatomic, strong) NSDictionary *orderDic;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *rechargeAmount;

@end
