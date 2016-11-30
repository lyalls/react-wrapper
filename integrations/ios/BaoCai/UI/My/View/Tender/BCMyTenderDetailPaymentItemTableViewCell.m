//
//  BCMyTenderDetailPaymentItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTenderDetailPaymentItemTableViewCell.h"

@interface BCMyTenderDetailPaymentItemTableViewCell ()

@property (nonatomic, strong) UILabel *paymentDateLabel;
@property (nonatomic, strong) UILabel *paymentAmoutLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation BCMyTenderDetailPaymentItemTableViewCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    self.paymentDateLabel = [[UILabel alloc] init];
    self.paymentDateLabel.font = [UIFont systemFontOfSize:11.0f];
    self.paymentDateLabel.textColor = Color666666;
    self.paymentDateLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.paymentDateLabel];
    
    [self.paymentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    
    self.paymentAmoutLabel = [[UILabel alloc] init];
    self.paymentAmoutLabel.font = [UIFont systemFontOfSize:11.0f];
    self.paymentAmoutLabel.textColor = Color666666;
    self.paymentAmoutLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.paymentAmoutLabel];
    
    [self.paymentAmoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(self.paymentDateLabel.mas_right);
        make.width.equalTo(self.paymentDateLabel);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.font = [UIFont systemFontOfSize:11.0f];
    self.stateLabel.textColor = Color666666;
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.stateLabel];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(self.paymentAmoutLabel.mas_right);
        make.width.equalTo(self.paymentAmoutLabel);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MyPaymentDetailItemModel *)model {
    self.paymentDateLabel.text = model.paymentDate;
    self.paymentAmoutLabel.text = model.paymentAmout;
    self.stateLabel.text = model.state;
}

@end
