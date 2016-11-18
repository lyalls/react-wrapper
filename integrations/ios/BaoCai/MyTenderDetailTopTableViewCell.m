//
//  MyTenderDetailTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTenderDetailTopTableViewCell.h"

@interface MyTenderDetailTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *leftPointView;
@property (weak, nonatomic) IBOutlet UIView *rightPointView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *principalInterestLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoverNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (nonatomic, strong) CAShapeLayer *border;

@end

@implementation MyTenderDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftPointView.layer.cornerRadius = 8;
    self.rightPointView.layer.cornerRadius = 8;
    
    [self setTopViewBorder:RGB_COLOR(223, 223, 223)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)reloadData:(MyTenderListItemModel *)model {
    self.nameLabel.text = model.name;
    self.investmentAmountLabel.text = model.investmentAmount;
    self.principalInterestLabel.text = model.tenderInterest;
    self.annualRateLabel.text = model.annualRate;
    self.recoverNumLabel.text = [NSString stringWithFormat:@"%@个月", model.borrowPeriod];
    self.borrowDateLabel.text = model.borrowDate;
    self.paymentMethodLabel.text = model.paymentMethod;
    
    [self.statusBtn setTitle:model.statusMsg forState:UIControlStateNormal];
}

- (void)reloadDataWithTransfer:(MyTransferListItemModel *)model {
    self.nameLabel.text = model.name;
    self.investmentAmountLabel.text = model.investmentAmount;
    self.principalInterestLabel.text = model.tenderInterest;
    self.annualRateLabel.text = model.annualRate;
    self.recoverNumLabel.text = [NSString stringWithFormat:@"%@个月", model.borrowPeriod];
    self.borrowDateLabel.text = model.borrowDate;
    self.paymentMethodLabel.text = model.paymentMethod;
    
    [self.statusBtn setTitle:model.statusMsg forState:UIControlStateNormal];
}

- (void)setTopViewBorder:(UIColor *)borderColor {
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = borderColor.CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, Screen_width - 25, 229.5)].CGPath;
    border1.frame = CGRectMake(0, 0, Screen_width - 25, 229.5);
    border1.lineWidth = 0.5;
    border1.lineCap = @"square";
    border1.lineDashPattern = @[@4, @2];
    if (self.border) {
        [self.topView.layer replaceSublayer:self.border with:border1];
    } else {
        [self.topView.layer addSublayer:border1];
    }
    
    self.border = border1;
}

@end
