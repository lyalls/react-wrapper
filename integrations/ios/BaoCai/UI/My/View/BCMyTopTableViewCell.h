//
//  BCMyTopTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyPageDataModel.h"

@interface BCMyTopTableViewCell : UITableViewCell

- (void)reloadData:(MyPageDataModel *)model;

@end
