//
//  BCInvestmentRecordTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCInvestmentRecordTableViewCell.h"

@interface BCInvestmentRecordTableViewCell ()

@property (nonatomic, strong) UILabel *tendererLabel;
@property (nonatomic, strong) UILabel *investmentAmountLabel;
@property (nonatomic, strong) UILabel *investmentTimeLabel;

@end

@implementation BCInvestmentRecordTableViewCell

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
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 10, 1, 10));
    }];
    
    self.tendererLabel = [[UILabel alloc] init];
    self.tendererLabel.font = [UIFont systemFontOfSize:18.0f];
    [backView addSubview:self.tendererLabel];
    
    [self.tendererLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(2);
    }];
    
    self.investmentTimeLabel = [[UILabel alloc] init];
    self.investmentTimeLabel.textColor = RGB_COLOR(199, 199, 199);
    self.investmentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:self.investmentTimeLabel];
    
    [self.investmentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(0);
        make.top.equalTo(self.tendererLabel.mas_bottom);
        make.height.equalTo(self.tendererLabel);
    }];
    
    self.investmentAmountLabel = [[UILabel alloc] init];
    self.investmentAmountLabel.textColor = RGB_COLOR(119, 119, 119);
    self.investmentAmountLabel.font = [UIFont systemFontOfSize:18.0f];
    self.investmentAmountLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.investmentAmountLabel];
    
    [self.investmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-10);
        make.left.equalTo(self.tendererLabel.mas_right).mas_offset(10);
    }];
}

#pragma mark - Custom Method

- (void)reloadData:(InvestmentRecordModel *)model {
    if ([model.tenderer rangeOfString:@"*"].location != NSNotFound) {
        self.tendererLabel.textColor = Color666666;
    } else {
        self.tendererLabel.textColor = RGB_COLOR(228, 0, 18);
    }
    self.tendererLabel.text = model.tenderer;
    self.investmentAmountLabel.text = model.investmentAmount;
    self.investmentTimeLabel.text = model.investmentTime;
}

@end
