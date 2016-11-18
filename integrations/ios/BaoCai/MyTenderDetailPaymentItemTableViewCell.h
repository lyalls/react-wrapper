//
//  MyTenderDetailPaymentItemTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyPaymentDetailItemModel.h"

@interface MyTenderDetailPaymentItemTableViewCell : UITableViewCell

- (void)reloadData:(MyPaymentDetailItemModel *)model;

@end
