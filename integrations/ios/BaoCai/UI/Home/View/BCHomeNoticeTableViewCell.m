//
//  BCHomeNoticeTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCHomeNoticeTableViewCell.h"

#import <MarqueeLabel/MarqueeLabel.h>

@interface BCHomeNoticeTableViewCell ()

@property (nonatomic, strong) MarqueeLabel *marqueeLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation BCHomeNoticeTableViewCell

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
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
    iconImageView.image = [UIImage imageNamed:@"homeNoticeIcon"];
    [self.contentView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];
    
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectNull];
    [self.closeBtn setImage:[UIImage imageNamed:@"homeNoticeCloseIcon"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    
    self.marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectNull];
    self.marqueeLabel.marqueeType = MLContinuous;
    self.marqueeLabel.scrollDuration = 20;
    self.marqueeLabel.animationDelay = 0;
    self.marqueeLabel.textColor = RGB_COLOR(204, 204, 204);
    self.marqueeLabel.font = [UIFont systemFontOfSize:10 * autoSizeScaleHeight];
    [self.contentView addSubview:self.marqueeLabel];
    
    [self.marqueeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(12);
        make.right.equalTo(self.closeBtn.mas_left).offset(0);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)reloadData:(NSMutableArray *)strings closeNotice:(void (^)())closeNotice {
    NSMutableString *displayStr = [NSMutableString stringWithCapacity:0];
    
    for (NSString *str in strings) {
        [displayStr appendFormat:@"%@  ", str];
    }
    
    self.marqueeLabel.text = displayStr;
    [self.marqueeLabel restartLabel];
    
    [self.closeBtn addTargetHandler:^(UIButton *sender) {
        if (closeNotice) {
            closeNotice();
        }
    }];
}

@end
