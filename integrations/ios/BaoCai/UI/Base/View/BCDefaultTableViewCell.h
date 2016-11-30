//
//  BCDefaultTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/2.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCDefaultTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

- (void)reloadCellWithIconUrl:(NSString *)iconUrl title:(NSString *)title detail:(NSString *)detail;

@end
