//
//  BCMyTransferTurnOutTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTransferTurnOutTableViewCell.h"

@interface BCMyTransferTurnOutTableViewCell ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *investmentAmountLabel;
@property (nonatomic, strong) UILabel *transferAmountLabel;
@property (nonatomic, strong) UILabel *counterFeeLabel;
@property (nonatomic, strong) UILabel *transferTimeLabel;
@property (nonatomic, strong) UILabel *changePeriodLabel;
@property (nonatomic, strong) UILabel *tradingProfitLabel;
@property (nonatomic, strong) UILabel *arrivalAmountLabel;

@end

@implementation BCMyTransferTurnOutTableViewCell

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
    
    self.topLineView.backgroundColor = [UIColor clearColor];
    self.bottomLineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.topLineView width:SCREEN_WIDTH - 20 lineLength:1 lineSpacing:1 lineColor:BackViewColor];
    [self drawDashLineWithLineView:self.bottomLineView width:SCREEN_WIDTH - 20 lineLength:1 lineSpacing:1 lineColor:BackViewColor];
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
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = RGB_COLOR(119, 119, 119);
    self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.nameLabel.numberOfLines = 2;
    [backView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(0);
        make.height.equalTo(50);
    }];
    
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = BackViewColor;
    [backView addSubview:self.topLineView];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.right.equalTo(0);
    }];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = BackViewColor;
    [backView addSubview:self.bottomLineView];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.bottom.equalTo(-50);
        make.left.right.equalTo(0);
    }];
    
    [self setupBottomControl];
    
    self.arrivalAmountLabel = [[UILabel alloc] init];
    self.arrivalAmountLabel.textColor = OrangeColor;
    self.arrivalAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:self.arrivalAmountLabel];
    
    [self.arrivalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(self.bottomLineView.mas_bottom);
        make.bottom.equalTo(0);
    }];
    
    UILabel *daozhangLabel = [[UILabel alloc] init];
    daozhangLabel.text = @"实际到账金额：";
    daozhangLabel.textColor = Color666666;
    daozhangLabel.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:daozhangLabel];
    
    [daozhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLineView.mas_bottom);
        make.bottom.equalTo(0);
        make.right.equalTo(self.arrivalAmountLabel.mas_left);
    }];
}

- (void)setupBottomControl {
    UILabel *touziLabel = [[UILabel alloc] init];
    touziLabel.text = @"投资本金：";
    touziLabel.textColor = Color666666;
    touziLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:touziLabel];
    
    [touziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(self.topLineView.mas_bottom).mas_offset(5);
    }];
    
    self.investmentAmountLabel = [[UILabel alloc] init];
    self.investmentAmountLabel.textColor = Color999999;
    self.investmentAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.investmentAmountLabel];
    
    [self.investmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(touziLabel.mas_right);
        make.top.equalTo(self.topLineView.mas_bottom).mas_offset(5);
    }];
    
    UILabel *zhuanrangLabel = [[UILabel alloc] init];
    zhuanrangLabel.text = @"转让价格：";
    zhuanrangLabel.textColor = Color666666;
    zhuanrangLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:zhuanrangLabel];
    
    [zhuanrangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(touziLabel.mas_bottom);
        make.height.equalTo(touziLabel);
    }];
    
    self.transferAmountLabel = [[UILabel alloc] init];
    self.transferAmountLabel.textColor = Color999999;
    self.transferAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.transferAmountLabel];
    
    [self.transferAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhuanrangLabel.mas_right);
        make.top.equalTo(self.investmentAmountLabel.mas_bottom);
        make.height.equalTo(self.investmentAmountLabel);
    }];
    
    UILabel *shouxuLabel = [[UILabel alloc] init];
    shouxuLabel.text = @"手续费：";
    shouxuLabel.textColor = Color666666;
    shouxuLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:shouxuLabel];
    
    [shouxuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(zhuanrangLabel.mas_bottom);
        make.height.equalTo(touziLabel);
    }];
    
    self.counterFeeLabel = [[UILabel alloc] init];
    self.counterFeeLabel.textColor = Color999999;
    self.counterFeeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.counterFeeLabel];
    
    [self.counterFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shouxuLabel.mas_right);
        make.top.equalTo(self.transferAmountLabel.mas_bottom);
        make.height.equalTo(self.investmentAmountLabel);
    }];
    
    UILabel *riqiLabel = [[UILabel alloc] init];
    riqiLabel.text = @"转让成功日期：";
    riqiLabel.textColor = Color666666;
    riqiLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:riqiLabel];
    
    [riqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(shouxuLabel.mas_bottom);
        make.height.equalTo(touziLabel);
    }];
    
    self.transferTimeLabel = [[UILabel alloc] init];
    self.transferTimeLabel.textColor = Color999999;
    self.transferTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.transferTimeLabel];
    
    [self.transferTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(riqiLabel.mas_right);
        make.top.equalTo(self.counterFeeLabel.mas_bottom);
        make.height.equalTo(self.investmentAmountLabel);
    }];
    
    UILabel *qishuLabel = [[UILabel alloc] init];
    qishuLabel.text = @"转让时剩余期数：";
    qishuLabel.textColor = Color666666;
    qishuLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:qishuLabel];
    
    [qishuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(riqiLabel.mas_bottom);
        make.height.equalTo(touziLabel);
    }];
    
    self.changePeriodLabel = [[UILabel alloc] init];
    self.changePeriodLabel.textColor = Color999999;
    self.changePeriodLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.changePeriodLabel];
    
    [self.changePeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qishuLabel.mas_right);
        make.top.equalTo(self.transferTimeLabel.mas_bottom);
        make.height.equalTo(self.investmentAmountLabel);
    }];
    
    UILabel *yingkuiLabel = [[UILabel alloc] init];
    yingkuiLabel.text = @"交易盈亏：";
    yingkuiLabel.textColor = Color666666;
    yingkuiLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:yingkuiLabel];
    
    [yingkuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(qishuLabel.mas_bottom);
        make.bottom.equalTo(self.bottomLineView.mas_top).mas_offset(-5);
        make.height.equalTo(touziLabel);
    }];
    
    self.tradingProfitLabel = [[UILabel alloc] init];
    self.tradingProfitLabel.textColor = Color999999;
    self.tradingProfitLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.tradingProfitLabel];
    
    [self.tradingProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yingkuiLabel.mas_right);
        make.top.equalTo(self.changePeriodLabel.mas_bottom);
        make.height.equalTo(self.investmentAmountLabel);
        make.bottom.equalTo(self.bottomLineView.mas_top).mas_offset(-5);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MyTransferListItemModel *)model {
    self.nameLabel.text = model.name;
    self.investmentAmountLabel.text = [NSString stringWithFormat:@"%@元", model.investmentAmount];
    self.transferAmountLabel.text = [NSString stringWithFormat:@"%@元", model.transferAmount];
    self.counterFeeLabel.text = [NSString stringWithFormat:@"%@元", model.counterFee];
    self.tradingProfitLabel.text = [NSString stringWithFormat:@"%@元", model.tradingProfit ? : @""];
    self.transferTimeLabel.text = model.transferTime ? : @"";
    self.changePeriodLabel.text = [NSString stringWithFormat:@"%@个月", model.changePeriod ? : @""];
    self.arrivalAmountLabel.text = [NSString stringWithFormat:@"%@元", model.arrivalAmount ? : @""];
}

#pragma mark - Private method

- (void)drawDashLineWithLineView:(UIView *)lineView width:(CGFloat)width lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.bounds) / 2, CGRectGetHeight(lineView.bounds))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.bounds)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, width, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
