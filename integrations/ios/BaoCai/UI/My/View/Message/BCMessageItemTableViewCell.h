//
//  BCMessageItemTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageItemModel.h"

@interface BCMessageItemTableViewCell : UITableViewCell

- (void)reloadData:(MessageItemModel *)model;

@end
