//
//  BCMyTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTopTableViewCell.h"

@interface BCMyTopTableViewCell ()

@property (nonatomic, strong) UIButton *showOrHideBtn;
@property (nonatomic, strong) UILabel *netAssetsLabel;
@property (nonatomic, strong) UILabel *availableBalanceLabel;
@property (nonatomic, strong) UILabel *futureRevenueLabel;

@property (nonatomic, strong) MyPageDataModel *model;

@end

@implementation BCMyTopTableViewCell

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
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"MyTop_new.png"];
    [self.contentView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.netAssetsLabel = [[UILabel alloc] init];
    self.netAssetsLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    self.netAssetsLabel.textAlignment = NSTextAlignmentCenter;
    self.netAssetsLabel.textColor = [UIColor whiteColor];
    self.netAssetsLabel.text = @" ";
    [self.contentView addSubview:self.netAssetsLabel];
    
    [self.netAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];
    
    UILabel *netAssetsDescLabel = [[UILabel alloc] init];
    netAssetsDescLabel.text = @"净资产（元）";
    netAssetsDescLabel.textColor = [UIColor whiteColor];
    netAssetsDescLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:netAssetsDescLabel];
    
    [netAssetsDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.netAssetsLabel.mas_bottom).offset(10);
    }];
    
    self.showOrHideBtn = [[UIButton alloc] init];
    [self.showOrHideBtn setImage:[UIImage imageNamed:@"MyShow.png"] forState:UIControlStateNormal];
    [self.showOrHideBtn addTarget:self action:@selector(showOrHideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.showOrHideBtn];
    
    [self.showOrHideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.mas_equalTo(netAssetsDescLabel.mas_right);
        make.centerY.equalTo(netAssetsDescLabel);
    }];
    
    UIView *availableBalanceView = [[UIView alloc] init];
    [self.contentView addSubview:availableBalanceView];
    
    [availableBalanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    
    self.availableBalanceLabel = [[UILabel alloc] init];
    self.availableBalanceLabel.textColor = [UIColor whiteColor];
    self.availableBalanceLabel.font = [UIFont systemFontOfSize:18.0f];
    self.availableBalanceLabel.textAlignment = NSTextAlignmentCenter;
    [availableBalanceView addSubview:self.availableBalanceLabel];
    
    [self.availableBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.right.mas_equalTo(0);
    }];
    
    UILabel *availableBalanceDescLabel = [[UILabel alloc] init];
    availableBalanceDescLabel.text = @"可用金额(元)";
    availableBalanceDescLabel.textColor = [UIColor whiteColor];
    availableBalanceDescLabel.font = [UIFont systemFontOfSize:14.0f];
    availableBalanceDescLabel.textAlignment = NSTextAlignmentCenter;
    [availableBalanceView addSubview:availableBalanceDescLabel];
    
    [availableBalanceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.left.right.mas_equalTo(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(229, 229, 229);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-11);
        make.left.mas_equalTo(availableBalanceView.mas_right);
    }];
    
    UIView *futureRevenueView = [[UIView alloc] init];
    [self.contentView addSubview:futureRevenueView];
    
    [futureRevenueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(availableBalanceView.mas_width);
    }];
    
    self.futureRevenueLabel = [[UILabel alloc] init];
    self.futureRevenueLabel.textColor = [UIColor whiteColor];
    self.futureRevenueLabel.font = [UIFont systemFontOfSize:18.0f];
    self.futureRevenueLabel.textAlignment = NSTextAlignmentCenter;
    [futureRevenueView addSubview:self.futureRevenueLabel];
    
    [self.futureRevenueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.right.mas_equalTo(0);
    }];
    
    UILabel *futureRevenueDescLabel = [[UILabel alloc] init];
    futureRevenueDescLabel.text = @"待收本息(元)";
    futureRevenueDescLabel.textColor = [UIColor whiteColor];
    futureRevenueDescLabel.font = [UIFont systemFontOfSize:14.0f];
    futureRevenueDescLabel.textAlignment = NSTextAlignmentCenter;
    [futureRevenueView addSubview:futureRevenueDescLabel];
    
    [futureRevenueDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.left.right.mas_equalTo(0);
    }];
}



- (void)reloadData:(MyPageDataModel *)model {
    self.model = model;
    if ([UserDefaultsHelper sharedManager].isShowMoney) {
        self.showOrHideBtn.selected = NO;
        self.netAssetsLabel.text = model.netAssets;
        self.availableBalanceLabel.font = [UIFont systemFontOfSize:18];
        self.availableBalanceLabel.text = model.availableBalance;
        self.futureRevenueLabel.font = [UIFont systemFontOfSize:18];
        self.futureRevenueLabel.text = model.futureRevenue;
    } else {
        self.showOrHideBtn.selected = YES;
        self.netAssetsLabel.text = @"*****";
        self.availableBalanceLabel.font = [UIFont systemFontOfSize:20];
        self.availableBalanceLabel.text = @"****";
        self.futureRevenueLabel.font = [UIFont systemFontOfSize:20];
        self.futureRevenueLabel.text = @"****";
    }
}

- (void)showOrHideBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.netAssetsLabel.text = self.model.netAssets;
        self.availableBalanceLabel.font = [UIFont systemFontOfSize:18];
        self.availableBalanceLabel.text = self.model.availableBalance;
        self.futureRevenueLabel.font = [UIFont systemFontOfSize:18];
        self.futureRevenueLabel.text = self.model.futureRevenue;
        [UserDefaultsHelper sharedManager].isShowMoney = YES;
    } else {
        btn.selected = YES;
        self.netAssetsLabel.text = @"*****";
        self.availableBalanceLabel.font = [UIFont systemFontOfSize:20];
        self.availableBalanceLabel.text = @"****";
        self.futureRevenueLabel.font = [UIFont systemFontOfSize:20];
        self.futureRevenueLabel.text = @"****";
        [UserDefaultsHelper sharedManager].isShowMoney = NO;
    }
}

@end
