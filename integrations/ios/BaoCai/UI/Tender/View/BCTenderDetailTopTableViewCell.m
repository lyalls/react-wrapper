//
//  BCTenderDetailTopTableViewCell.m
//  BaoCai_Code
//
//  Created by 刘国龙 on 2016/9/26.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCTenderDetailTopTableViewCell.h"

#import "TenderProgressCircleView.h"

#import "BCTenderCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BCTenderDetailTopTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *tenderTypeImageView;
@property (nonatomic, strong) UILabel *tenderNameLabel;
@property (nonatomic, strong) UILabel *annualRateLabel;
@property (nonatomic, strong) UIView *rateView;
@property (nonatomic, strong) UILabel *addRateLabel;
@property (nonatomic, strong) UILabel *investHorizonLabel;
@property (nonatomic, strong) UIButton *tenderStatusBtn;

@property (nonatomic, strong) TenderProgressCircleView *progressView;
@property (nonatomic, strong) UILabel *tenderScheduleLabel;

@property (nonatomic, strong) UIView *limitTimeView;
@property (nonatomic, strong) UILabel *limitHourLabel;
@property (nonatomic, strong) UILabel *limitMinuteLabel;
@property (nonatomic, strong) UILabel *limitSecondLabel;

@property (nonatomic, strong) UIButton *tagBtn1;
@property (nonatomic, strong) UIButton *tagBtn2;
@property (nonatomic, strong) UIButton *tagBtn3;
@property (nonatomic, strong) UIView *leftPointView;
@property (nonatomic, strong) UIView *rightPointView;

@property (nonatomic, strong) CAShapeLayer *border;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *tenderAccountLabel;
@property (nonatomic, strong) UILabel *anticipatedIncomeLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation BCTenderDetailTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    self.leftPointView.layer.cornerRadius = self.leftPointView.bounds.size.width / 2;
    self.rightPointView.layer.cornerRadius = self.leftPointView.bounds.size.width / 2;
}

- (void)setupView {
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectNull];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    WS(weakSelf);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(10, 10, 35, 10));
    }];
    
    self.borderView = [[UIView alloc] initWithFrame:CGRectNull];
    [topView addSubview:self.borderView];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView).with.insets(UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5));
    }];
    
    self.tenderNameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.tenderNameLabel.font = [UIFont systemFontOfSize:18.0];
    self.tenderNameLabel.numberOfLines = 0;
    self.tenderNameLabel.textColor = Color666666;
    [self.borderView addSubview:self.tenderNameLabel];
    
    [self.tenderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView).with.offset(33);
        make.top.equalTo(self.borderView).with.offset(8);
        make.right.equalTo(self.borderView).with.offset(-15);
        make.height.mas_equalTo(63);
    }];
    
    self.tenderTypeImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
    [self.contentView addSubview:self.tenderTypeImageView];
    
    [self.tenderTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 63));
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
    }];
    
    self.rateView = [[UIView alloc] init];
    [self.borderView addSubview:self.rateView];
    
    [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(self.tenderNameLabel.bottom).mas_offset(10);
    }];
    
    self.annualRateLabel = [[UILabel alloc] init];
    self.annualRateLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.annualRateLabel.textColor = OrangeColor;
    [self.rateView addSubview:self.annualRateLabel];
    
    [self.annualRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    
    self.addRateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.addRateLabel.font = [UIFont systemFontOfSize:15.0];
    self.addRateLabel.textColor = OrangeColor;
    [self.rateView addSubview:self.addRateLabel];
    
    [self.addRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.annualRateLabel.mas_right);
        make.bottom.equalTo(self.annualRateLabel).with.offset(-1);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = @"年利率";
    rateLabel.textColor = Color999999;
    rateLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.rateView addSubview:rateLabel];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.annualRateLabel.mas_bottom).mas_offset(15);
    }];
    
    self.investHorizonLabel = [[UILabel alloc] init];
    self.investHorizonLabel.textColor = Color666666;
    self.investHorizonLabel.font = [UIFont systemFontOfSize:15.0];
    [self.borderView addSubview:self.investHorizonLabel];
    
    [self.investHorizonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tenderNameLabel).mas_offset(15);
        make.centerY.equalTo(self.annualRateLabel);
    }];
    
    UILabel *investLabel = [[UILabel alloc] init];
    investLabel.text = @"借款期限";
    investLabel.textColor = Color999999;
    investLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.borderView addSubview:investLabel];
    
    [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.investHorizonLabel);
        make.centerY.equalTo(rateLabel);
    }];
    
    self.tenderStatusBtn = [[UIButton alloc] initWithFrame:CGRectNull];
    [self.tenderStatusBtn setBackgroundImage:ImageNamed(@"tenderStatus.png") forState:UIControlStateNormal];
    [self.tenderStatusBtn setTitleColor:RGB_COLOR(204, 204, 204) forState:UIControlStateNormal];
    self.tenderStatusBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tenderStatusBtn.userInteractionEnabled = NO;
    [self.borderView addSubview:self.tenderStatusBtn];
    
    [self.tenderStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 25));
        make.centerY.equalTo(self.rateView);
        make.right.equalTo(self.tenderNameLabel);
    }];
    
    self.progressView = [[TenderProgressCircleView alloc] initWithFrame:CGRectNull];
    self.progressView.backgroundColor = [UIColor whiteColor];
    [self.borderView addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.rateView);
        make.right.mas_equalTo(self.tenderNameLabel);
    }];
    
    self.tenderScheduleLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.tenderScheduleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.tenderScheduleLabel.textColor = OrangeColor;
    [self.progressView addSubview:self.tenderScheduleLabel];
    
    [self.tenderScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    [self setupLimitView];
    
    [self setupTagBtn];
    
    self.leftPointView = [[UIView alloc] initWithFrame:CGRectNull];
    self.leftPointView.backgroundColor = BackViewColor;
    [self.contentView addSubview:self.leftPointView];
    
    [self.leftPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.equalTo(self.contentView).with.offset(198);
        make.left.equalTo(self.contentView).with.offset(2);
    }];
    
    self.rightPointView = [[UIView alloc] initWithFrame:CGRectNull];
    self.rightPointView.backgroundColor = BackViewColor;
    [self.contentView addSubview:self.rightPointView];
    
    [self.rightPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.equalTo(self.contentView).with.offset(198);
        make.right.equalTo(self.contentView).with.offset(-2);
    }];
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.image = [UIImage imageNamed:@"tenderPoint.png"];
    centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:centerImageView];
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(6);
        make.left.mas_equalTo(self.leftPointView.mas_right);
        make.right.mas_equalTo(self.rightPointView.mas_left);
        make.centerY.equalTo(self.leftPointView);
    }];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = RGB_COLOR(193, 193, 193);
    [self.borderView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(132);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.collectionView setBorder:RGB_COLOR(193, 193, 193) width:0.5];
    
    [self.collectionView registerClass:[BCTenderCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BCTenderCollectionViewCell class])];
    
    [self setupBottom];
}

- (void)setupLimitView {
    self.limitTimeView = [[UIView alloc] init];
    [self.borderView addSubview:self.limitTimeView];
    
    [self.limitTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(self.borderView.mas_right);
        make.top.mas_equalTo(self.rateView.mas_top);
        make.bottom.mas_equalTo(self.rateView.mas_bottom);
    }];
    
    UIView *limitTimeViewLine = [[UIView alloc] init];
    limitTimeViewLine.backgroundColor = RGB_COLOR(235, 235, 235);
    [self.limitTimeView addSubview:limitTimeViewLine];
    
    [limitTimeViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(1);
    }];
    
    UILabel *limitTimeSaleLabel = [[UILabel alloc] init];
    limitTimeSaleLabel.text = @"即将发售";
    limitTimeSaleLabel.font = [UIFont systemFontOfSize:14.0f];
    limitTimeSaleLabel.textColor = OrangeColor;
    [self.limitTimeView addSubview:limitTimeSaleLabel];
    
    [limitTimeSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(5);
    }];
    
    self.limitHourLabel = [[UILabel alloc] init];
    self.limitHourLabel.font = [UIFont systemFontOfSize:12.0f];
    self.limitHourLabel.backgroundColor = OrangeColor;
    self.limitHourLabel.textColor = [UIColor whiteColor];
    self.limitHourLabel.textAlignment = NSTextAlignmentCenter;
    [self.limitTimeView addSubview:self.limitHourLabel];
    
    [self.limitHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *colon1Label = [[UILabel alloc] init];
    colon1Label.text = @":";
    colon1Label.font = [UIFont systemFontOfSize:13.0f];
    colon1Label.textColor = OrangeColor;
    colon1Label.textAlignment = NSTextAlignmentCenter;
    [self.limitTimeView addSubview:colon1Label];
    
    [colon1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.left.mas_equalTo(self.limitHourLabel.mas_right);
        make.centerY.equalTo(self.limitHourLabel);
    }];
    
    self.limitMinuteLabel = [[UILabel alloc] init];
    self.limitMinuteLabel.font = [UIFont systemFontOfSize:12.0f];
    self.limitMinuteLabel.backgroundColor = OrangeColor;
    self.limitMinuteLabel.textColor = [UIColor whiteColor];
    self.limitMinuteLabel.textAlignment = NSTextAlignmentCenter;
    [self.limitTimeView addSubview:self.limitMinuteLabel];
    
    [self.limitMinuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(colon1Label.mas_right);
        make.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *colon2Label = [[UILabel alloc] init];
    colon2Label.text = @":";
    colon2Label.font = [UIFont systemFontOfSize:13.0f];
    colon2Label.textColor = OrangeColor;
    colon2Label.textAlignment = NSTextAlignmentCenter;
    [self.limitTimeView addSubview:colon2Label];
    
    [colon2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.left.mas_equalTo(self.limitMinuteLabel.mas_right);
        make.centerY.equalTo(self.limitHourLabel);
    }];
    
    self.limitSecondLabel = [[UILabel alloc] init];
    self.limitSecondLabel.font = [UIFont systemFontOfSize:12.0f];
    self.limitSecondLabel.backgroundColor = OrangeColor;
    self.limitSecondLabel.textColor = [UIColor whiteColor];
    self.limitSecondLabel.textAlignment = NSTextAlignmentCenter;
    [self.limitTimeView addSubview:self.limitSecondLabel];
    
    [self.limitSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(colon2Label.mas_right);
        make.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (void)setupTagBtn {
    self.tagBtn1 = [[UIButton alloc] initWithFrame:CGRectNull];
    self.tagBtn1.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.tagBtn1.userInteractionEnabled = NO;
    [self.tagBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tagBtn1 setBackgroundImage:ImageNamed(@"tenderTip1.png") forState:UIControlStateNormal];
    [self.tagBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.contentView addSubview:self.tagBtn1];
    
    [self.tagBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.mas_equalTo(-5);
        make.top.equalTo(self.contentView).with.offset(165);
    }];
    
    self.tagBtn2 = [[UIButton alloc] initWithFrame:CGRectNull];
    self.tagBtn2.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.tagBtn2.userInteractionEnabled = NO;
    [self.tagBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tagBtn2 setBackgroundImage:ImageNamed(@"tenderTip2.png") forState:UIControlStateNormal];
    [self.tagBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.contentView addSubview:self.tagBtn2];
    
    [self.tagBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 22));
        make.right.equalTo(self.tagBtn1.mas_left).with.offset(8);
        make.centerY.equalTo(self.tagBtn1);
    }];
    
    self.tagBtn3 = [[UIButton alloc] initWithFrame:CGRectNull];
    self.tagBtn3.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.tagBtn3.userInteractionEnabled = NO;
    [self.tagBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tagBtn3 setBackgroundImage:ImageNamed(@"tenderTip3.png") forState:UIControlStateNormal];
    [self.tagBtn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.contentView addSubview:self.tagBtn3];
    
    [self.tagBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 22));
        make.right.equalTo(self.tagBtn2.mas_left).with.offset(8);
        make.centerY.equalTo(self.tagBtn1);
    }];
}

- (void)setupBottom {
    self.bottomView = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.borderView.mas_bottom).mas_offset(12);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"投资";
    label1.textColor = Color666666;
    label1.font = [UIFont systemFontOfSize:12.0f];
    [self.bottomView addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    self.tenderAccountLabel = [[UILabel alloc] init];
    self.tenderAccountLabel.textColor = OrangeColor;
    self.tenderAccountLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bottomView addSubview:self.tenderAccountLabel];
    
    [self.tenderAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.centerY.equalTo(label1);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"，预计收益";
    label2.textColor = Color666666;
    label2.font = [UIFont systemFontOfSize:12.0f];
    [self.bottomView addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tenderAccountLabel.mas_right);
        make.centerY.equalTo(label1);
    }];
    
    self.anticipatedIncomeLabel = [[UILabel alloc] init];
    self.anticipatedIncomeLabel.textColor = OrangeColor;
    self.anticipatedIncomeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bottomView addSubview:self.anticipatedIncomeLabel];
    
    [self.anticipatedIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right);
        make.centerY.equalTo(label1);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"元";
    label3.textColor = Color666666;
    label3.font = [UIFont systemFontOfSize:12.0f];
    [self.bottomView addSubview:label3];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.anticipatedIncomeLabel.mas_right);
        make.right.mas_equalTo(0);
        make.centerY.equalTo(label1);
    }];
}

- (void)setTopViewBorder:(UIColor *)borderColor {
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = borderColor.CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRect:self.borderView.bounds].CGPath;
    border1.frame = self.borderView.bounds;
    border1.lineWidth = 0.5;
    border1.lineCap = @"square";
    border1.lineDashPattern = @[@4, @2];
    if (self.border) {
        [self.border removeFromSuperlayer];
    }
    [self.borderView.layer addSublayer:border1];
    
    self.border = border1;
}

#pragma mark - Custom method

- (void)reloadData:(TenderItemModel *)model {
    [self layoutIfNeeded];
    
    [self.tenderTypeImageView sd_setImageWithURL:[model.tenderTypeImageUrl toURL]];
    
    if (model.tenderTypeBorderColor) {
        [self setTopViewBorder:[UIColor getColorWithRGBStr:model.tenderTypeBorderColor]];
    } else {
        [self setTopViewBorder:[UIColor whiteColor]];
    }
    self.tenderNameLabel.text = model.name;
    self.annualRateLabel.text = model.annualRate;
    self.addRateLabel.text = [NSString stringWithFormat:@"%%%@", (model.increaseApr && model.increaseApr.floatValue > 0) ? [NSString stringWithFormat:@"+%@%%", model.increaseApr] : @""];
    self.investHorizonLabel.text = model.investmentHorizon;
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    //借款金额（元）
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic1 setObject:@"借款金额（元）" forKey:@"name"];
    [dic1 setObject:model.borrowAmount ? model.borrowAmount : @"" forKey:@"value"];
    [self.displayArray addObject:dic1];
    //保障方式
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic2 setObject:@"保障方式" forKey:@"name"];
    [dic2 setObject:model.safeguardWay ? model.safeguardWay : @"" forKey:@"value"];
    [self.displayArray addObject:dic2];
    //起投金额（元）
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic3 setObject:@"起投金额（元）" forKey:@"name"];
    [dic3 setObject:model.tenderMin ? model.tenderMin : @"" forKey:@"value"];
    [self.displayArray addObject:dic3];
    //最大限额（元）
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic4 setObject:@"最大限额（元）" forKey:@"name"];
    [dic4 setObject:model.tenderMax ? model.tenderMax : @"" forKey:@"value"];
    [self.displayArray addObject:dic4];
    //还款方式
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic5 setObject:@"还款方式" forKey:@"name"];
    [dic5 setObject:model.paymentMethod ? model.paymentMethod : @"" forKey:@"value"];
    [self.displayArray addObject:dic5];
    //剩余时间
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic6 setObject:@"" forKey:@"name"];
    [dic6 setObject:@"" forKey:@"value"];
    [self.displayArray addObject:dic6];
    
    if (model.tenderSchedule.integerValue == 100) {
        self.progressView.hidden = YES;
        self.limitTimeView.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.tenderStatusBtn.hidden = NO;
        [self.tenderStatusBtn setTitle:model.statusMessage forState:UIControlStateNormal];
        self.bottomView.hidden = YES;
        
        self.tagBtn1.hidden = YES;
        self.tagBtn2.hidden = YES;
        self.tagBtn3.hidden = YES;
    } else {
        NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
        //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
        NSInteger limitTime = model.limitTime.integerValue - (currentTimeInterval - model.limitTimeInterval);
        if (model.isLimit && limitTime > 0) {
            self.progressView.hidden = YES;
            self.limitTimeView.hidden = NO;
            [self displayLimitTime:limitTime];
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown:) userInfo:model repeats:YES];
        } else {
            //现在投资剩余时间 = 请求投资剩余时间 - (现在时间 - 请求时间)
            NSInteger remainTime = model.remainTime.integerValue - (currentTimeInterval - model.remainTimeInterval);
            if (remainTime > 0) {
                [self displayRemainTime:remainTime];
            }
            self.progressView.hidden = NO;
            self.progressView.percent = model.tenderSchedule.integerValue;
            if (model.isFull && model.isFullThreshold) {
                self.progressView.color = RGB_COLOR(255, 92, 92);
                self.tenderScheduleLabel.text = @"满抢";
                self.tenderScheduleLabel.textColor = RGB_COLOR(255, 92, 92);
            } else {
                self.progressView.color = OrangeColor;
                self.tenderScheduleLabel.text = [NSString stringWithFormat:@"%@%%", model.tenderSchedule];
                self.tenderScheduleLabel.textColor = OrangeColor;
            }
            [self.progressView setNeedsDisplay];
            self.limitTimeView.hidden = YES;
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
        self.tenderStatusBtn.hidden = YES;
        self.bottomView.hidden = NO;
        self.tenderAccountLabel.text = model.tenderAccount;
        self.anticipatedIncomeLabel.text = model.anticipatedIncome;
        
        self.tagBtn1.hidden = YES;
        self.tagBtn2.hidden = YES;
        self.tagBtn3.hidden = YES;
        //存在红包券和加息券
        if (model.isBonusticket && model.isAllowIncrease) {
            self.tagBtn1.hidden = NO;
            [self setButton:self.tagBtn1 title:@"红包券" imageName:@"tenderTip_red_1.png" type:1];
            self.tagBtn2.hidden = NO;
            if (model.isTag) {
                [self setButton:self.tagBtn2 title:@"加息券" imageName:@"tenderTip_red_2.png" type:2];
                self.tagBtn3.hidden = NO;
                [self setButton:self.tagBtn3 title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
            }
            else {
                [self setButton:self.tagBtn2 title:@"加息券" imageName:@"tenderTip_red_3.png" type:3];
            }
        }
        //存在红包券或加息券
        else if (model.isBonusticket || model.isAllowIncrease) {
            self.tagBtn1.hidden = NO;
            if (model.isReward || model.isTag) {
                if (model.isBonusticket) {
                    [self setButton:self.tagBtn1 title:@"红包券" imageName:@"tenderTip_red_1.png" type:1];
                }
                else if (model.isAllowIncrease) {
                    [self setButton:self.tagBtn1 title:@"加息券" imageName:@"tenderTip_red_1.png" type:1];
                }
                self.tagBtn2.hidden = NO;
                if (model.isReward && model.isTag) {
                    [self setButton:self.tagBtn2 title:model.promotionTitle imageName:@"tenderTip_yellow_2.png" type:2];
                    self.tagBtn3.hidden = NO;
                    [self setButton:self.tagBtn3 title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                }
                else if (model.isReward) {
                    [self setButton:self.tagBtn2 title:model.promotionTitle imageName:@"tenderTip_yellow_3.png" type:3];
                }
                else if (model.isTag) {
                    [self setButton:self.tagBtn2 title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                }
            }
            else {
                if (model.isBonusticket) {
                    [self setButton:self.tagBtn1 title:@"红包券" imageName:@"tenderTip_red_0.png" type:0];
                }
                else if (model.isAllowIncrease) {
                    [self setButton:self.tagBtn1 title:@"加息券" imageName:@"tenderTip_red_0.png" type:0];
                }
            }
        }
        //不存在红包券和加息券
        else if (model.isReward || model.isTag) {
            self.tagBtn1.hidden = NO;
            if (model.isReward && model.isTag) {
                [self setButton:self.tagBtn1 title:model.promotionTitle imageName:@"tenderTip_yellow_1.png" type:1];
                self.tagBtn2.hidden = NO;
                [self setButton:self.tagBtn2 title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
            }
            else if (model.isReward) {
                [self setButton:self.tagBtn1 title:model.promotionTitle imageName:@"tenderTip_yellow_0.png" type:0];
            }
            else if (model.isTag) {
                [self setButton:self.tagBtn1 title:model.tagTitle imageName:@"tenderTip_orange_0.png" type:0];
            }
        }
    }
    
    [self.collectionView reloadData];
}

- (void)displayLimitTime:(NSInteger)limitTime {
    self.limitHourLabel.text = [NSString stringWithFormat:@"%02ld", limitTime / 3600];
    self.limitMinuteLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 / 60];
    self.limitSecondLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 % 60];
}

- (void)timerCountdown:(NSTimer *)timer {
    TenderItemModel *model = (TenderItemModel *)timer.userInfo;
    
    NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
    //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
    NSInteger limitTime = model.limitTime.integerValue - (currentTimeInterval - model.limitTimeInterval);
    if (limitTime > 0) {
        [self displayLimitTime:limitTime];
    } else {
        self.progressView.hidden = NO;
        self.progressView.percent = model.tenderSchedule.integerValue;
        self.progressView.color = OrangeColor;
        self.tenderScheduleLabel.text = [NSString stringWithFormat:@"%@%%", model.tenderSchedule];
        self.tenderScheduleLabel.textColor = OrangeColor;
        [self.progressView setNeedsDisplay];
        [self.tenderNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.borderView).with.offset(-15);
        }];
        self.limitTimeView.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        if ([self.delegate respondsToSelector:@selector(timerStopWithTableViewCell:)]) {
            [self.delegate timerStopWithTableViewCell:self];
        }
    }
}

- (void)setButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName type:(NSInteger)type {
    NSDictionary *attributes = @{NSFontAttributeName : button.titleLabel.font};
    [button setTitle:title forState:UIControlStateNormal];
    
    CGFloat btnWidth = 0;
    
    switch (type) {
        case 0:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            btnWidth = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 15 + 10;
        }
            break;
        case 1:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            btnWidth = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 17 + 10;
        }
            break;
        case 2:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            btnWidth = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 24 + 10;
        }
            break;
        case 3:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 12) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            btnWidth = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 22 + 10;
        }
            break;
        default:
            break;
    }
    
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWidth, 22));
    }];
}

- (void)displayRemainTime:(NSInteger)remainTime {
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    NSInteger remainDay = remainTime / (3600 * 24);
    if (remainDay > 0) {
        [string appendFormat:@"%ld天", remainDay];
    }
    NSInteger remainHour = remainTime % (3600 * 24) / 3600;
    if (remainHour > 0) {
        [string appendFormat:@"%02ld小时", remainHour];
    }
    NSInteger remainMinute = remainTime % (3600 * 24) % 3600 / 60;
    if (remainMinute > 0) {
        [string appendFormat:@"%02ld分", remainMinute];
    }
    
    NSMutableDictionary *dic = [self.displayArray objectAtIndex:5];
    [dic setObject:@"剩余时间" forKey:@"name"];
    [dic setObject:string forKey:@"value"];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCTenderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BCTenderCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:[self.displayArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Collection View Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionView.bounds.size.width - 0.5) / 2, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.4;
}

@end
