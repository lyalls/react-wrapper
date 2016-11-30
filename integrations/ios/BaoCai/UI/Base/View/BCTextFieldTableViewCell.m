//
//  BCTextFieldTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/9.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCTextFieldTableViewCell.h"

@implementation BCTextFieldTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = Color666666;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.bottom.equalTo(0);
        make.left.equalTo(self.titleLabel.mas_right).mas_offset(20);
    }];
}

#pragma mark - Custom method

- (void)reloadCellWithTitle:(NSString *)title textFieldPlaceholder:(NSString *)textFieldPlaceholder {
    if (title == nil || title.length == 0) {
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
        }];
    } else {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).mas_offset(20);
        }];
    }
    
    self.titleLabel.text = title;
    self.textField.placeholder = textFieldPlaceholder;
}

@end
