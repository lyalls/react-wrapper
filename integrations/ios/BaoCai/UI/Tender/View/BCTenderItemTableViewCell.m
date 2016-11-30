//
//  BCTenderItemTableViewCell.m
//  BaoCai_Code
//
//  Created by 刘国龙 on 16/8/17.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import "BCTenderItemTableViewCell.h"

#import "TenderProgressCircleView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BCTenderItemTableViewCell ()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *tenderTypeImageView;
@property (nonatomic, strong) UILabel *tenderNameLabel;
@property (nonatomic, strong) UILabel *annualRateLabel;
@property (nonatomic, strong) UILabel *addRateLabel;
@property (nonatomic, strong) UILabel *investHorizonLabel;
@property (nonatomic, strong) UIButton *tenderStatusBtn;

@property (nonatomic, strong) TenderProgressCircleView *progressView;
@property (nonatomic, strong) UILabel *tenderScheduleLabel;

@property (nonatomic, strong) UIView *limitTimeView;
@property (nonatomic, strong) UILabel *limitHourLabel;
@property (nonatomic, strong) UILabel *limitMinuteLabel;
@property (nonatomic, strong) UILabel *limitSecondLabel;

@property (nonatomic, strong) UILabel *borrowAmountLabel;
@property (nonatomic, strong) UILabel *investPersonNumLabeL;

@property (nonatomic, strong) UIButton *tagBtn1;
@property (nonatomic, strong) UIButton *tagBtn2;
@property (nonatomic, strong) UIButton *tagBtn3;

@property (nonatomic, strong) CAShapeLayer *border;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BCTenderItemTableViewCell

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
}

- (void)setupView {
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectNull];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    WS(weakSelf);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    self.borderView = [[UIView alloc] initWithFrame:CGRectNull];
    [topView addSubview:self.borderView];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView).with.insets(UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5));
    }];
    
    self.tenderNameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.tenderNameLabel.font = [UIFont systemFontOfSize:17.0];
    self.tenderNameLabel.textColor = Color666666;
    [self.borderView addSubview:self.tenderNameLabel];
    
    [self.tenderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView).with.offset(28);
        make.top.equalTo(self.borderView).with.offset(8);
        make.right.equalTo(self.borderView).with.offset(-15);
    }];
    
    self.annualRateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.annualRateLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.annualRateLabel.textColor = OrangeColor;
    [self.borderView addSubview:self.annualRateLabel];
    
    [self.annualRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tenderNameLabel);
        make.centerY.equalTo(self.borderView);
    }];
    
    self.addRateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.addRateLabel.font = [UIFont systemFontOfSize:15.0];
    self.addRateLabel.textColor = OrangeColor;
    [self.borderView addSubview:self.addRateLabel];
    
    [self.addRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.annualRateLabel.mas_right);
        make.bottom.equalTo(self.annualRateLabel).with.offset(-1);
    }];
    
    self.investHorizonLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.investHorizonLabel.font = [UIFont systemFontOfSize:15.0f];
    self.investHorizonLabel.textColor = Color666666;
    [self.borderView addSubview:self.investHorizonLabel];
    
    [self.investHorizonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.annualRateLabel).with.offset(-1);
        make.centerX.equalTo(self.tenderNameLabel).with.offset(20);
    }];
    
    self.tenderStatusBtn = [[UIButton alloc] initWithFrame:CGRectNull];
    [self.tenderStatusBtn setBackgroundImage:ImageNamed(@"tenderStatus.png") forState:UIControlStateNormal];
    [self.tenderStatusBtn setTitleColor:RGB_COLOR(204, 204, 204) forState:UIControlStateNormal];
    self.tenderStatusBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tenderStatusBtn.userInteractionEnabled = NO;
    [self.borderView addSubview:self.tenderStatusBtn];
    
    [self.tenderStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 25));
        make.centerY.equalTo(self.borderView);
        make.right.equalTo(self.tenderNameLabel);
    }];
    
    self.progressView = [[TenderProgressCircleView alloc] initWithFrame:CGRectNull];
    self.progressView.backgroundColor = [UIColor whiteColor];
    [self.borderView addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    self.tenderScheduleLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.tenderScheduleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.tenderScheduleLabel.textColor = OrangeColor;
    [self.progressView addSubview:self.tenderScheduleLabel];
    
    [self.tenderScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    [self setupLimitView];
    
    self.borrowAmountLabel = [[UILabel alloc] init];
    self.borrowAmountLabel.font = [UIFont systemFontOfSize:13.0f];
    self.borrowAmountLabel.textColor = RGB_COLOR(191, 191, 191);
    [self.borderView addSubview:self.borrowAmountLabel];
    
    [self.borrowAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-7);
        make.left.mas_equalTo(self.tenderNameLabel.mas_left);
    }];
    
    self.investPersonNumLabeL = [[UILabel alloc] init];
    self.investPersonNumLabeL.font = [UIFont systemFontOfSize:13.0f];
    self.investPersonNumLabeL.textColor = RGB_COLOR(191, 191, 191);
    [self.borderView addSubview:self.investPersonNumLabeL];
    
    [self.investPersonNumLabeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.borrowAmountLabel);
        make.right.mas_equalTo(-15);
    }];
    
    self.tenderTypeImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
    [self.contentView addSubview:self.tenderTypeImageView];
    
    [self.tenderTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 63));
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
    }];
    
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
        make.bottom.mas_equalTo(-5);
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

- (void)setupLimitView {
    self.limitTimeView = [[UIView alloc] init];
    [self.borderView addSubview:self.limitTimeView];
    
    [self.limitTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(self.borderView.mas_right);
        make.top.mas_equalTo(self.tenderNameLabel.mas_top);
        make.bottom.mas_equalTo(self.annualRateLabel.mas_bottom);
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
    
    if (model.tenderSchedule.integerValue == 100) {
        self.progressView.hidden = YES;
        [self.tenderNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.borderView).with.offset(-15);
        }];
        self.limitTimeView.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.tenderStatusBtn.hidden = NO;
        [self.tenderStatusBtn setTitle:model.statusMessage forState:UIControlStateNormal];
        self.borrowAmountLabel.hidden = NO;
        self.borrowAmountLabel.text = [NSString stringWithFormat:@"借款金额：%@元", model.borrowAmount];
        self.investPersonNumLabeL.hidden = NO;
        self.investPersonNumLabeL.text = [NSString stringWithFormat:@"投资人次：%@人", model.investPersonNum];
        
        self.tagBtn1.hidden = YES;
        self.tagBtn2.hidden = YES;
        self.tagBtn3.hidden = YES;
    } else {
        NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
        //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
        NSInteger limitTime = model.limitTime.integerValue - (currentTimeInterval - model.limitTimeInterval);
        if (model.isLimit && limitTime > 0) {
            self.progressView.hidden = YES;
            [self.tenderNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.borderView).with.offset(-115);
            }];
            self.limitTimeView.hidden = NO;
            [self displayLimitTime:limitTime];
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown:) userInfo:model repeats:YES];
        } else {
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
            [self.tenderNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.borderView).with.offset(-15);
            }];
            self.limitTimeView.hidden = YES;
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
        self.tenderStatusBtn.hidden = YES;
        self.borrowAmountLabel.hidden = YES;
        self.investPersonNumLabeL.hidden = YES;
        
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

@end
