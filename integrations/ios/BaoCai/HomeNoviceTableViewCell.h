//
//  HomeNoviceTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenderItemModel.h"

@interface HomeNoviceTableViewCell : UITableViewCell

- (void)reloadData:(TenderItemModel *)model;

@end