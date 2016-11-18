//
//  UITenderDetailViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"
#import "TenderDetailTableViewCell.h"

@interface UITenderDetailViewController : UIViewController <TenderDetailTableViewCellDelegate>

@property (nonatomic, strong) NSString *tenderId;
@property (nonatomic, strong) TenderItemModel *itemModel;

@end
