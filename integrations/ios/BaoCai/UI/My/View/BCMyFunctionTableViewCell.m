//
//  BCMyFunctionTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyFunctionTableViewCell.h"

@interface BCMyFunctionTableViewCell ()

@property (nonatomic, strong) FunctionClickBlock block;

@end

@implementation BCMyFunctionTableViewCell

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
    UIButton *rechargeBtn = [[UIButton alloc] init];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [rechargeBtn setTitleColor:Color999999 forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(229, 229, 229);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(1);
        make.centerY.equalTo(rechargeBtn);
        make.left.mas_equalTo(rechargeBtn.mas_right);
    }];
    
    UIButton *withdrawalsBtn = [[UIButton alloc] init];
    [withdrawalsBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawalsBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [withdrawalsBtn setTitleColor:Color999999 forState:UIControlStateNormal];
    [withdrawalsBtn addTarget:self action:@selector(withdrawalsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:withdrawalsBtn];
    
    [withdrawalsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(lineView.mas_right);
        make.width.mas_equalTo(rechargeBtn.mas_width);
    }];
}

- (void)reloadData:(FunctionClickBlock)block {
    self.block = block;
}

- (void)rechargeBtnClick:(id)sender {
    self.block(FunctionTypeRecharge);
}

- (void)withdrawalsBtnClick:(id)sender {
    self.block(FunctionTypeWithdrawals);
}

@end
