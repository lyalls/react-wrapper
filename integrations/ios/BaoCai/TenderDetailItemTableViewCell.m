//
//  TenderDetailItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderDetailItemTableViewCell.h"

@interface TenderDetailItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TenderDetailItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(TenderDetailMenuModel *)model {
    self.iconImageView.image = model.iconImage;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
}

@end
