//
//  BCMyTenderDetailTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTenderDetailTopTableViewCell.h"

@interface BCMyTenderDetailTopTableViewCell ()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIView *leftPointView;
@property (nonatomic, strong) UIView *rightPointView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *investmentAmountLabel;
@property (nonatomic, strong) UILabel *principalInterestLabel;
@property (nonatomic, strong) UILabel *annualRateLabel;
@property (nonatomic, strong) UILabel *recoverNumLabel;
@property (nonatomic, strong) UILabel *borrowDateLabel;
@property (nonatomic, strong) UILabel *paymentMethodLabel;
@property (nonatomic, strong) UIButton *statusBtn;

@property (nonatomic, strong) CAShapeLayer *border;

@end

@implementation BCMyTenderDetailTopTableViewCell

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

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    self.leftPointView.layer.cornerRadius = 8;
    self.rightPointView.layer.cornerRadius = 8;
    
    [self setViewBorder:RGB_COLOR(223, 223, 223)];
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
    
    self.borderView = [[UIView alloc] init];
    [backView addSubview:self.borderView];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5));
    }];
    
    self.leftPointView = [[UIView alloc] init];
    self.leftPointView.backgroundColor = BackViewColor;
    [self.contentView addSubview:self.leftPointView];
    
    [self.leftPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(16, 16));
        make.top.equalTo(125);
        make.left.equalTo(2);
    }];
    
    self.rightPointView = [[UIView alloc] init];
    self.rightPointView.backgroundColor = BackViewColor;
    [self.contentView addSubview:self.rightPointView];
    
    [self.rightPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(16, 16));
        make.top.equalTo(125);
        make.right.equalTo(-2);
    }];
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tenderPoint.png"]];
    pointImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:pointImageView];
    
    [pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(6);
        make.centerY.equalTo(self.leftPointView);
        make.left.equalTo(self.leftPointView.mas_right);
        make.right.equalTo(self.rightPointView.mas_left);
    }];
    
    [self setupTopControl];
    [self setupBottomControl];
}

- (void)setupTopControl {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.nameLabel.textColor = Color666666;
    self.nameLabel.numberOfLines = 2;
    [self.borderView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(40);
        make.left.top.equalTo(7.5);
        make.right.equalTo(-7.5);
    }];
    
    self.investmentAmountLabel = [[UILabel alloc] init];
    self.investmentAmountLabel.textColor = OrangeColor;
    self.investmentAmountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.borderView addSubview:self.investmentAmountLabel];
    
    [self.investmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(10);
    }];
    
    UILabel *benjinLabel = [[UILabel alloc] init];
    benjinLabel.text = @"投资本金(元)";
    benjinLabel.font = [UIFont systemFontOfSize:12.0f];
    benjinLabel.textColor = Color666666;
    [self.borderView addSubview:benjinLabel];
    
    [benjinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.investmentAmountLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.investmentAmountLabel.mas_left);
    }];
    
    self.principalInterestLabel = [[UILabel alloc] init];
    self.principalInterestLabel.textColor = OrangeColor;
    self.principalInterestLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.borderView addSubview:self.principalInterestLabel];
    
    [self.principalInterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.investmentAmountLabel);
        make.centerX.equalTo(self.nameLabel);
    }];
    
    UILabel *lixiLabel = [[UILabel alloc] init];
    lixiLabel.text = @"应收利息(元)";
    lixiLabel.font = [UIFont systemFontOfSize:12.0f];
    lixiLabel.textColor = Color666666;
    [self.borderView addSubview:lixiLabel];
    
    [lixiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.principalInterestLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.principalInterestLabel.mas_left);
    }];
    
    self.statusBtn = [[UIButton alloc] init];
    [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"tenderStatus.png"] forState:UIControlStateNormal];
    self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.statusBtn setTitleColor:RGB_COLOR(204, 204, 204) forState:UIControlStateNormal];
    self.statusBtn.userInteractionEnabled = NO;
    [self.borderView addSubview:self.statusBtn];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(72, 25));
        make.right.equalTo(self.nameLabel.mas_right);
        make.centerY.equalTo(self.investmentAmountLabel.mas_bottom).mas_offset(5);
    }];
}

- (void)setupBottomControl {
    UILabel *lilvLabel = [[UILabel alloc] init];
    lilvLabel.text = @"年利率：";
    lilvLabel.font = [UIFont systemFontOfSize:12.0];
    lilvLabel.textColor = Color666666;
    [self.borderView addSubview:lilvLabel];
    
    [lilvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.investmentAmountLabel.mas_bottom).mas_offset(60);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    
    self.annualRateLabel = [[UILabel alloc] init];
    self.annualRateLabel.font = [UIFont systemFontOfSize:12.0f];
    self.annualRateLabel.textColor = Color999999;
    [self.borderView addSubview:self.annualRateLabel];
    
    [self.annualRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lilvLabel.mas_right);
        make.centerY.equalTo(lilvLabel);
    }];
    
    UILabel *qishuLabel = [[UILabel alloc] init];
    qishuLabel.text = @"期数：";
    qishuLabel.font = [UIFont systemFontOfSize:12.0];
    qishuLabel.textColor = Color666666;
    [self.borderView addSubview:qishuLabel];
    
    [qishuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lilvLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(lilvLabel.mas_left);
    }];
    
    self.recoverNumLabel = [[UILabel alloc] init];
    self.recoverNumLabel.font = [UIFont systemFontOfSize:12.0f];
    self.recoverNumLabel.textColor = Color999999;
    [self.borderView addSubview:self.recoverNumLabel];
    
    [self.recoverNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qishuLabel.mas_right);
        make.centerY.equalTo(qishuLabel);
    }];
    
    UILabel *jiekuanLabel = [[UILabel alloc] init];
    jiekuanLabel.text = @"借款时间：";
    jiekuanLabel.font = [UIFont systemFontOfSize:12.0];
    jiekuanLabel.textColor = Color666666;
    [self.borderView addSubview:jiekuanLabel];
    
    [jiekuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qishuLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(qishuLabel.mas_left);
    }];
    
    self.borrowDateLabel = [[UILabel alloc] init];
    self.borrowDateLabel.font = [UIFont systemFontOfSize:12.0f];
    self.borrowDateLabel.textColor = Color999999;
    [self.borderView addSubview:self.borrowDateLabel];
    
    [self.borrowDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jiekuanLabel.mas_right);
        make.centerY.equalTo(jiekuanLabel);
    }];
    
    UILabel *huankuanLabel = [[UILabel alloc] init];
    huankuanLabel.text = @"还款方式：";
    huankuanLabel.font = [UIFont systemFontOfSize:12.0];
    huankuanLabel.textColor = Color666666;
    [self.borderView addSubview:huankuanLabel];
    
    [huankuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiekuanLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(jiekuanLabel.mas_left);
    }];
    
    self.paymentMethodLabel = [[UILabel alloc] init];
    self.paymentMethodLabel.font = [UIFont systemFontOfSize:12.0f];
    self.paymentMethodLabel.textColor = Color999999;
    [self.borderView addSubview:self.paymentMethodLabel];
    
    [self.paymentMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(huankuanLabel.mas_right);
        make.centerY.equalTo(huankuanLabel);
    }];
}

- (void)setViewBorder:(UIColor *)borderColor {
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = borderColor.CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRect:self.borderView.bounds].CGPath;
    border1.frame = self.borderView.bounds;
    border1.lineWidth = 0.5;
    border1.lineCap = @"square";
    border1.lineDashPattern = @[@4, @2];
    if (self.border) {
        [self.borderView.layer replaceSublayer:self.border with:border1];
    } else {
        [self.borderView.layer addSublayer:border1];
    }
    
    self.border = border1;
}

#pragma mark - Custom method

- (void)reloadData:(MyTenderListItemModel *)model {
    [self layoutIfNeeded];
    
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
    [self layoutIfNeeded];
    
    self.nameLabel.text = model.name;
    self.investmentAmountLabel.text = model.investmentAmount;
    self.principalInterestLabel.text = model.tenderInterest;
    self.annualRateLabel.text = model.annualRate;
    self.recoverNumLabel.text = [NSString stringWithFormat:@"%@个月", model.borrowPeriod];
    self.borrowDateLabel.text = model.borrowDate;
    self.paymentMethodLabel.text = model.paymentMethod;
    
    [self.statusBtn setTitle:model.statusMsg forState:UIControlStateNormal];
}

@end
