//
//  BCFullRecordTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCFullRecordTableViewCell.h"

@interface BCFullRecordTableViewCell ()

@property (nonatomic, strong) UILabel *rewardLabel;

@end

@implementation BCFullRecordTableViewCell

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
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"满抢";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = RGB_COLOR(245, 88, 66);
    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    [backView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(33, 15));
        make.left.top.bottom.equalTo(0);
    }];
    
    self.rewardLabel = [[UILabel alloc] init];
    self.rewardLabel.font = [UIFont systemFontOfSize:12.0f];
    self.rewardLabel.textColor = Color666666;
    [backView addSubview:self.rewardLabel];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLabel);
        make.right.equalTo(0);
        make.left.equalTo(tipLabel.mas_right).mas_offset(5);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(NSString *)string {
    self.rewardLabel.text = string;
    
    CGFloat width = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 33 - 5, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.rewardLabel.font, NSFontAttributeName, nil] context:nil].size.width;
    
    [self.rewardLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width + 5);
    }];
}

@end
