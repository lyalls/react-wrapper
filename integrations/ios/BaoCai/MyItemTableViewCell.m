//
//  MyItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyItemTableViewCell.h"

@interface MyItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *unReadView;
@property (weak, nonatomic) IBOutlet UIImageView *versionView;

@end

@implementation MyItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.unReadView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(MyItemModel *)model {
    self.descLabel.hidden = YES;
    self.unReadView.hidden = YES;
    self.versionView.hidden = YES;
    
    self.iconImageView.image = model.iconImage;
    self.titleLabel.text = model.title;
    
    if (model.type == MyItemModelTypeTitleDesc) {
        self.descLabel.hidden = NO;
        
        self.descLabel.text = model.desc;
    } else if (model.type == MyItemModelTypeUnRead) {
        self.unReadView.hidden = !model.isHasUnRead;
    } else if (model.type == MyItemModelTypeNewVersion) {
        self.versionView.hidden = !model.isHasNewVersion;
    }
}

@end
