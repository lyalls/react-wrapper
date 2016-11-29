//
//  TenderItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderItemTableViewCell.h"
#import "TenderProgressCircleView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TenderItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *tenderTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tenderRightImageView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *tenderCrownImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentHorizonLabel;

@property (weak, nonatomic) IBOutlet TenderProgressCircleView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *tenderScheduleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelConstraint;
@property (weak, nonatomic) IBOutlet UIView *limitTimeView;
@property (weak, nonatomic) IBOutlet UILabel *limitHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitSecondLabel;
@property (weak, nonatomic) IBOutlet UIButton *tenderStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *borrowAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *investPersonNumLabeL;

@property (weak, nonatomic) IBOutlet UIButton *tip1Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip1BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip2Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip2BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip3Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip3BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip4Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip4BtnWidthConstraint;

@property (nonatomic, strong) CAShapeLayer *border;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TenderItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.limitHourLabel.backgroundColor = OrangeColor;
        self.limitMinuteLabel.backgroundColor = OrangeColor;
        self.limitSecondLabel.backgroundColor = OrangeColor;
    }
}

#pragma mark - Custom Method

- (void)reloadData:(TenderItemModel *)model {
    if (model.tenderSolidBorderColor) {
        if ([model.tenderSolidBorderColor isEqualToString:@"255,255,255"]) {
            self.bottomView.layer.borderWidth = 0.0;
        } else {
            self.bottomView.layer.borderWidth = 0.5;
            self.bottomView.layer.borderColor = [UIColor getColorWithRGBStr:model.tenderSolidBorderColor].CGColor;
        }
    } else {
        self.bottomView.layer.borderWidth = 0.0;
    }
    [self.tenderTypeImageView sd_setImageWithURL:[model.tenderTypeImageUrl toURL]];
    [self.tenderRightImageView sd_setImageWithURL:[model.tenderRightImageUrl toURL]];
    
    if (model.tenderTypeBorderColor) {
        [self setTopViewBorder:[UIColor getColorWithRGBStr:model.tenderTypeBorderColor]];
    } else {
        [self setTopViewBorder:[UIColor whiteColor]];
    }
    if ([model.tenderCrownImageUrl isEqualToString:@""]) {
        self.nameLabelLeftConstraint.constant = 28;
        self.tenderCrownImageView.hidden = YES;
    } else {
        self.nameLabelLeftConstraint.constant = 43;
        self.tenderCrownImageView.hidden = NO;
        [self.tenderCrownImageView sd_setImageWithURL:[model.tenderCrownImageUrl toURL]];
    }
    self.nameLabel.text = model.name;
    self.annualRateLabel.text = model.annualRate;
    self.addRateLabel.text = [NSString stringWithFormat:@"%%%@", (model.increaseApr && model.increaseApr.floatValue > 0) ? [NSString stringWithFormat:@"+%@%%", model.increaseApr] : @""];
    self.investmentHorizonLabel.text = model.investmentHorizon;
    
    if (model.tenderSchedule.integerValue == 100) {
        self.progressView.hidden = YES;
        self.nameLabelConstraint.constant = 15;
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
        
        self.tip1Btn.hidden = YES;
        self.tip2Btn.hidden = YES;
        self.tip3Btn.hidden = YES;
        self.tip4Btn.hidden = YES;
    } else {
        NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
        //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
        NSInteger limitTime = model.limitTime.integerValue - (currentTimeInterval - model.limitTimeInterval);
        if (model.isLimit && limitTime > 0) {
            self.progressView.hidden = YES;
            self.nameLabelConstraint.constant = 115;
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
            self.nameLabelConstraint.constant = 15;
            self.limitTimeView.hidden = YES;
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
        self.tenderStatusBtn.hidden = YES;
        self.borrowAmountLabel.hidden = YES;
        self.investPersonNumLabeL.hidden = YES;
        
        self.tip1Btn.hidden = YES;
        self.tip2Btn.hidden = YES;
        self.tip3Btn.hidden = YES;
        self.tip4Btn.hidden = YES;
        //存在红包券和加息券
        if (model.isBonusticket && model.isAllowIncrease) {
            self.tip1Btn.hidden = NO;
            [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:@"红包券" imageName:@"tenderTip_red_1.png" type:1];
            self.tip2Btn.hidden = NO;
            if (model.isTag || model.isMin) {
                [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:@"加息券" imageName:@"tenderTip_red_2.png" type:2];
                self.tip3Btn.hidden = NO;
                if (model.isTag && model.isMin) {
                    [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_2.png" type:2];
                    self.tip4Btn.hidden = NO;
                    [self setButton:self.tip4Btn layoutConstraint:self.tip4BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                } else if (model.isTag) {
                    [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                } else if (model.isMin) {
                    [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                }
            } else {
                [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:@"加息券" imageName:@"tenderTip_red_3.png" type:3];
            }
        }
        //存在红包券或加息券
        else if (model.isBonusticket || model.isAllowIncrease) {
            self.tip1Btn.hidden = NO;
            if (model.isReward || model.isTag || model.isMin) {
                if (model.isBonusticket) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:@"红包券" imageName:@"tenderTip_red_1.png" type:1];
                } else if (model.isAllowIncrease) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:@"加息券" imageName:@"tenderTip_red_1.png" type:1];
                }
                self.tip2Btn.hidden = NO;
                if (model.isReward && model.isTag) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_2.png" type:2];
                    self.tip3Btn.hidden = NO;
                    if (model.isMin) {
                        [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_2.png" type:2];
                        self.tip4Btn.hidden = NO;
                        [self setButton:self.tip4Btn layoutConstraint:self.tip4BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                    } else {
                        [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                    }
                } else if (model.isReward && model.isMin) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_2.png" type:2];
                    self.tip3Btn.hidden = NO;
                    [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                } else if (model.isTag && model.isMin) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_2.png" type:2];
                    self.tip3Btn.hidden = NO;
                    [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                } else if (model.isReward) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_3.png" type:3];
                } else if (model.isTag) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                } else if (model.isMin) {
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                }
            } else {
                if (model.isBonusticket) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:@"红包券" imageName:@"tenderTip_red_0.png" type:0];
                } else if (model.isAllowIncrease) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:@"加息券" imageName:@"tenderTip_red_0.png" type:0];
                }
            }
        }
        //不存在红包券和加息券
        else {
            if (model.isReward || model.isTag || model.isMin) {
                self.tip1Btn.hidden = NO;
                if (model.isReward && model.isTag) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_1.png" type:1];
                    self.tip2Btn.hidden = NO;
                    if (model.isMin) {
                        [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_2.png" type:2];
                        self.tip3Btn.hidden = NO;
                        [self setButton:self.tip3Btn layoutConstraint:self.tip3BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                    } else {
                        [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_3.png" type:3];
                    }
                } else if (model.isReward && model.isMin) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_1.png" type:1];
                    self.tip2Btn.hidden = NO;
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                } else if (model.isTag && model.isMin) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_1.png" type:1];
                    self.tip2Btn.hidden = NO;
                    [self setButton:self.tip2Btn layoutConstraint:self.tip2BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_3.png" type:3];
                } else if (model.isReward) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.promotionTitle imageName:@"tenderTip_yellow_0.png" type:0];
                } else if (model.isTag) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.tagTitle imageName:@"tenderTip_orange_0.png" type:0];
                } else if (model.isMin) {
                    [self setButton:self.tip1Btn layoutConstraint:self.tip1BtnWidthConstraint title:model.minAccountText imageName:@"tenderTip_main_0.png" type:0];
                }
            }
        }
    }
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
        self.nameLabelConstraint.constant = 15;
        self.limitTimeView.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)displayLimitTime:(NSInteger)limitTime {
    self.limitHourLabel.text = [NSString stringWithFormat:@"%02ld", limitTime / 3600];
    self.limitMinuteLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 / 60];
    self.limitSecondLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 % 60];
}

- (void)setButton:(UIButton *)button layoutConstraint:(NSLayoutConstraint *)layoutConstraint title:(NSString *)title imageName:(NSString *)imageName type:(NSInteger)type {
    NSDictionary *attributes = @{NSFontAttributeName : button.titleLabel.font};
    [button setTitle:title forState:UIControlStateNormal];
    switch (type) {
        case 0:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            layoutConstraint.constant = [title boundingRectWithSize:CGSizeMake(Screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 15 + 10;
        }
            break;
        case 1:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            layoutConstraint.constant = [title boundingRectWithSize:CGSizeMake(Screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 17 + 10;
        }
            break;
        case 2:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            layoutConstraint.constant = [title boundingRectWithSize:CGSizeMake(Screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 24 + 10;
        }
            break;
        case 3:
        {
            [button setBackgroundImage:[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 12) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            layoutConstraint.constant = [title boundingRectWithSize:CGSizeMake(Screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 22 + 10;
        }
            break;
        default:
            break;
    }
}

- (void)setTopViewBorder:(UIColor *)borderColor {
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = borderColor.CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, Screen_width - 29, 96)].CGPath;
    border1.frame = CGRectMake(0, 0, Screen_width - 29, 96);
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
