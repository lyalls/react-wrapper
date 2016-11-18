//
//  MyTransferTransferTableViewCell.h
//  BaoCai
//
//  Created by baocai on 16/9/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTransferListItemModel.h"

@interface MyTransferTransferTableViewCell : UITableViewCell

- (void)reloadData:(MyTransferListItemModel *)model;

@end
