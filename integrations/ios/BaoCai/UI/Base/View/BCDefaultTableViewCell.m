//
//  BCDefaultTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/2.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCDefaultTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BCDefaultTableViewCell ()

@end

@implementation BCDefaultTableViewCell

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
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = Color666666;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:13.0f];
    self.detailLabel.textColor = Color999999;
    [self.contentView addSubview:self.detailLabel];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
}

- (void)reloadCellWithIconUrl:(NSString *)iconUrl title:(NSString *)title detail:(NSString *)detail {
    self.iconImageView.image = nil;
    self.titleLabel.text = @"";
    self.detailLabel.text = @"";
    
    if (iconUrl == nil || iconUrl.length == 0) {
        self.iconImageView.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
        }];
    } else {
        self.iconImageView.hidden = NO;
        if ([iconUrl hasPrefix:@"http://"] || [iconUrl hasPrefix:@"https://"]) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
        } else {
            self.iconImageView.image = [UIImage imageNamed:iconUrl];
        }
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
        }];
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.right).mas_offset(5);
        }];
    }
    
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
    } else {
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
        }];
    }
    
    self.titleLabel.text = title;
    
    if (detail == nil || detail.length == 0) {
        self.detailLabel.hidden = YES;
    } else {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = detail;
    }
    self.titleLabel.textColor = Color666666;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.detailLabel.textColor = Color999999;
    self.detailLabel.font = [UIFont systemFontOfSize:13.0f];
}

@end
