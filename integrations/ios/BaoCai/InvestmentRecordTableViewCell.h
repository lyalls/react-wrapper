//
//  InvestmentRecordTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvestmentRecordModel.h"

@interface InvestmentRecordTableViewCell : UITableViewCell

- (void)reloadData:(InvestmentRecordModel *)model;

@end
