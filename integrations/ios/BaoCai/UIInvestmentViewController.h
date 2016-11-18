//
//  UIInvestmentViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

@interface UIInvestmentViewController : UITableViewController

@property (nonatomic, strong) TenderItemModel *itemModel;

@property (nonatomic, strong) NSString *activityCode;

@end
