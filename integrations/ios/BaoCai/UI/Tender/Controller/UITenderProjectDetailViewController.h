//
//  UITenderProjectDetailViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

@interface UITenderProjectDetailViewController : UIViewController

@property (nonatomic, strong) TenderItemModel *itemModel;
@property (nonatomic, assign) BOOL isTenderRecord;

@end
