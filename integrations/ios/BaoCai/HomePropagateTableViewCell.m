//
//  HomePropagateTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "HomePropagateTableViewCell.h"

@interface HomePropagateTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon1TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon1WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel1TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabel1TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descLabel1;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon2TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon2WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel2TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabel2TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon3TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon3WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon3HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel3TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabel3TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descLabel3;

@end

@implementation HomePropagateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.icon1TopConstraint.constant = self.icon1TopConstraint.constant * homeHeightScale;
    self.icon2TopConstraint.constant = self.icon2TopConstraint.constant * homeHeightScale;
    self.icon3TopConstraint.constant = self.icon3TopConstraint.constant * homeHeightScale;
    
    self.icon1WidthConstraint.constant = self.icon1WidthConstraint.constant * homeHeightScale;
    self.icon2WidthConstraint.constant = self.icon2WidthConstraint.constant * homeHeightScale;
    self.icon3WidthConstraint.constant = self.icon3WidthConstraint.constant * homeHeightScale;
    
    self.icon1HeightConstraint.constant = self.icon1HeightConstraint.constant * homeHeightScale;
    self.icon2HeightConstraint.constant = self.icon2HeightConstraint.constant * homeHeightScale;
    self.icon3HeightConstraint.constant = self.icon3HeightConstraint.constant * homeHeightScale;
    
    self.titleLabel1TopConstraint.constant = self.titleLabel1TopConstraint.constant * homeHeightScale;
    self.titleLabel2TopConstraint.constant = self.titleLabel2TopConstraint.constant * homeHeightScale;
    self.titleLabel3TopConstraint.constant = self.titleLabel3TopConstraint.constant * homeHeightScale;
    
    self.titleLabel1.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    self.titleLabel2.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    self.titleLabel3.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    
    self.descLabel1TopConstraint.constant = self.descLabel1TopConstraint.constant * homeHeightScale;
    self.descLabel2TopConstraint.constant = self.descLabel2TopConstraint.constant * homeHeightScale;
    self.descLabel3TopConstraint.constant = self.descLabel3TopConstraint.constant * homeHeightScale;
    
    self.descLabel1.font = [UIFont systemFontOfSize:8 * homeHeightScale];
    self.descLabel2.font = [UIFont systemFontOfSize:8 * homeHeightScale];
    self.descLabel3.font = [UIFont systemFontOfSize:8 * homeHeightScale];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
