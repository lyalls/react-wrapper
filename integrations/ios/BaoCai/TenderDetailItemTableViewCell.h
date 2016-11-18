//
//  TenderDetailItemTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderDetailMenuModel.h"

@interface TenderDetailItemTableViewCell : UITableViewCell

- (void)reloadData:(TenderDetailMenuModel *)model;

@end
