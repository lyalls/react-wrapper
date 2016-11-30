//
//  BCBottomTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBottomTableViewCell.h"

@implementation BCBottomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"投资有风险 选择需谨慎";
    titleLabel.textColor = RGB_COLOR(208, 208, 208);
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = RGB_COLOR(208, 208, 208);
    [self.contentView addSubview:leftLineView];
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
        make.centerY.equalTo(titleLabel);
    }];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB_COLOR(208, 208, 208);
    [self.contentView addSubview:rightLineView];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(titleLabel.mas_right).offset(5);
        make.centerY.equalTo(titleLabel);
    }];
}

@end
