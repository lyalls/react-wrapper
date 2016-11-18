//
//  MyTenderDetailPaymentItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTenderDetailPaymentItemTableViewCell.h"

@interface MyTenderDetailPaymentItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *paymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentAmoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation MyTenderDetailPaymentItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(MyPaymentDetailItemModel *)model {
    self.paymentDateLabel.text = model.paymentDate;
    self.paymentAmoutLabel.text = model.paymentAmout;
    self.stateLabel.text = model.state;
}

@end
