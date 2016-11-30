//
//  BCMyTenderDetailPaymentTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTenderDetailPaymentTopTableViewCell.h"

@implementation BCMyTenderDetailPaymentTopTableViewCell

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
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"收款详情";
    detailLabel.textColor = OrangeColor;
    detailLabel.font = [UIFont systemFontOfSize:16.0f];
    [backView addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(0);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGB_COLOR(253, 221, 203);
    [backView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(detailLabel.mas_bottom);
        make.height.equalTo(30);
    }];
    
    UILabel *riqiLabel = [[UILabel alloc] init];
    riqiLabel.text = @"还款日期";
    riqiLabel.textColor = Color999999;
    riqiLabel.font = [UIFont systemFontOfSize:13.0f];
    riqiLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:riqiLabel];
    
    [riqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
    }];
    
    UILabel *jineLabel = [[UILabel alloc] init];
    jineLabel.text = @"应收金额(元)";
    jineLabel.textColor = Color999999;
    jineLabel.font = [UIFont systemFontOfSize:13.0f];
    jineLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:jineLabel];
    
    [jineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(riqiLabel.mas_right);
        make.width.equalTo(riqiLabel);
    }];
    
    UILabel *zhuangtaiLabel = [[UILabel alloc] init];
    zhuangtaiLabel.text = @"状态";
    zhuangtaiLabel.textColor = Color999999;
    zhuangtaiLabel.font = [UIFont systemFontOfSize:13.0f];
    zhuangtaiLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:zhuangtaiLabel];
    
    [zhuangtaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.left.equalTo(jineLabel.mas_right);
        make.width.equalTo(jineLabel);
    }];
}

@end
