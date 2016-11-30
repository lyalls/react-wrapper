//
//  BCInvestmentRecordTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvestmentRecordModel.h"

@interface BCInvestmentRecordTableViewCell : UITableViewCell

- (void)reloadData:(InvestmentRecordModel *)model;

@end
