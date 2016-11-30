//
//  BCMyTenderDetailTopTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTenderListItemModel.h"
#import "MyTransferListItemModel.h"

@interface BCMyTenderDetailTopTableViewCell : UITableViewCell

- (void)reloadData:(MyTenderListItemModel *)model;
- (void)reloadDataWithTransfer:(MyTransferListItemModel *)model;

@end
