//
//  BCTenderDetailTopTableViewCell.h
//  BaoCai_Code
//
//  Created by 刘国龙 on 2016/9/26.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

@class BCTenderDetailTopTableViewCell;

@protocol BCTenderDetailTopTableViewCellDelegate <NSObject>

- (void)timerStopWithTableViewCell:(BCTenderDetailTopTableViewCell *)tableViewCell;

@end

@interface BCTenderDetailTopTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BCTenderDetailTopTableViewCellDelegate> delegate;

- (void)reloadData:(TenderItemModel *)model;

@end
