//
//  BCMyTenderItemTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTenderListItemModel.h"
#import "MyTransferListItemModel.h"

#import "MyRequest.h"

@interface BCMyTenderItemTableViewCell : UITableViewCell

- (void)reloadData:(MyTenderListItemModel *)model myTenderItemTableViewCellType:(MyTenderItemTableViewCellType)type;

- (void)reloadData:(MyTransferListItemModel *)model myTransferItemTableViewCellType:(MyTransferItemTableViewCellType)type;

@end
