//
//  BCTenderItemTableViewCell.h
//  BaoCai_Code
//
//  Created by 刘国龙 on 16/8/17.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

@interface BCTenderItemTableViewCell : UITableViewCell

- (void)reloadData:(TenderItemModel *)model;

@end
