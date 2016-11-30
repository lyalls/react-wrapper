//
//  UITransferTurnOutViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTransferListItemModel.h"

#import "MyRequest.h"

@interface UITransferTurnOutViewController : UIViewController

@property (nonatomic, strong) MyTransferListItemModel *transferItemModel;
@property (nonatomic, assign) MyTransferItemTableViewCellType transferItemType;

@end
