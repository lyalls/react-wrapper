//
//  MyTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTopTableViewCell.h"

@interface MyTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *showOrHideBtn;
@property (weak, nonatomic) IBOutlet UILabel *netAssetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *futureRevenueLabel;

@property (nonatomic, strong) MyPageDataModel *model;

@end

@implementation MyTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (IBAction)showOrHideBtnClick:(UIButton *)btn {
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
