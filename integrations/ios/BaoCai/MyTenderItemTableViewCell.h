//
//  MyTenderItemTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTenderListItemModel.h"
#import "MyTransferListItemModel.h"

#import "MyRequest.h"

@interface MyTenderItemTableViewCell : UITableViewCell

- (void)reloadData:(MyTenderListItemModel *)model myTenderItemTableViewCellType:(MyTenderItemTableViewCellType)type;

- (void)reloadData:(MyTransferListItemModel *)model myTransferItemTableViewCellType:(MyTransferItemTableViewCellType)type;

@end
