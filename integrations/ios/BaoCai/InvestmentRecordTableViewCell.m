//
//  InvestmentRecordTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "InvestmentRecordTableViewCell.h"

@interface InvestmentRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tendererLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentTimeLabel;

@end

@implementation InvestmentRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(InvestmentRecordModel *)model {
    if ([model.tenderer rangeOfString:@"*"].location != NSNotFound) {
        self.tendererLabel.textColor = RGB_COLOR(102, 102, 102);
    } else {
        self.tendererLabel.textColor = RGB_COLOR(228, 0, 18);
    }
    self.tendererLabel.text = model.tenderer;
    self.investmentAmountLabel.text = model.investmentAmount;
    self.investmentTimeLabel.text = model.investmentTime;
}

@end
