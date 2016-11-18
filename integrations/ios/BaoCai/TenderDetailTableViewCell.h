//
//  TenderDetailTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

@class TenderDetailTableViewCell;

@protocol TenderDetailTableViewCellDelegate <NSObject>

- (void)timerStopWithTableViewCell:(TenderDetailTableViewCell *)tableViewCell;

@end

@interface TenderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TenderDetailTableViewCellDelegate> delegate;

- (void)reloadData:(TenderItemModel *)model;

@end
