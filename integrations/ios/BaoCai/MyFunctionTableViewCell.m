//
//  MyFunctionTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyFunctionTableViewCell.h"

@interface MyFunctionTableViewCell ()

@property (nonatomic, strong) FunctionClickBlock block;

@end

@implementation MyFunctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(FunctionClickBlock)block {
    self.block = block;
}

- (IBAction)rechargeBtnClick:(id)sender {
    self.block(FunctionTypeRecharge);
}

- (IBAction)withdrawalsBtnClick:(id)sender {
    self.block(FunctionTypeWithdrawals);
}

@end
