//
//  MyTenderDetailViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTenderListItemModel.h"
#import "MyTransferListItemModel.h"

@interface UIMyTenderDetailViewController : UITableViewController

@property (nonatomic, strong) MyTenderListItemModel *tenderItemModel;
@property (nonatomic, strong) MyTransferListItemModel *transferItemModel;

@end
