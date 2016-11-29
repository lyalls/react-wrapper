//
//  TenderDetailTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderDetailTableViewCell.h"

#import "TenderProgressCircleView.h"

#import "TenderCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TenderDetailTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *tenderTypeImageView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTateLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentHorizonLabel;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (weak, nonatomic) IBOutlet TenderProgressCircleView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *tenderScheduleLabel;
@property (weak, nonatomic) IBOutlet UIView *limitTimeView;
@property (weak, nonatomic) IBOutlet UILabel *limitHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitSecondLabel;
@property (weak, nonatomic) IBOutlet UIButton *tenderStatusBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *tenderAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *anticipatedIncomeLabel;

@property (weak, nonatomic) IBOutlet UIView *leftPointView;
@property (weak, nonatomic) IBOutlet UIView *rightPointView;

@property (weak, nonatomic) IBOutlet UIButton *tip1Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip1BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip2Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip2BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip3Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip3BtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tip4Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip4BtnWidthConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) CAShapeLayer *border;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TenderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftPointView.layer.cornerRadius = 8;
    self.rightPointView.layer.cornerRadius = 8;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TenderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TenderCollectionViewCell"];
    [self.collectionView setBorder:RGB_COLOR(193, 193, 193) width:0.5];
}

- (void)reloadData:(TenderItemModel *)model {
    [self.tenderTypeImageView sd_setImageWithURL:[model.tenderTypeImageUrl toURL]];
    
    if (model.tenderTypeBorderColor) {
        [self setTopViewBorder:[UIColor getColorWithRGBStr:model.tenderTypeBorderColor]];
    } else {
        [self setTopViewBorder:[UIColor whiteColor]];
    }
    self.nameLabel.text = model.name;
    self.annualRateLabel.text = model.annualRate;
    self.addTateLabel.text = [NSString stringWithFormat:@"%%%@", (model.increaseApr && model.increaseApr.floatValue > 0) ? [NSString stringWithFormat:@"+%@%%", model.increaseApr] : @""];
    self.investmentHorizonLabel.text = model.investmentHorizon;
    
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
    
    [self.collectionView reloadData];
}

- (void)timerCountdown:(NSTimer *)timer {
    TenderItemModel *model = (TenderItemModel *)timer.userInfo;
    
    NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
    //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
    NSInteger limitTime = model.limitTime.integerValue - (currentTimeInterval - model.limitTimeInterval);
    if (limitTime > 0) {
        [self displayLimitTime:limitTime];
    } else {
        //现在投资剩余时间 = 请求投资剩余时间 - (现在时间 - 请求时间)
        NSInteger remainTime = model.remainTime.integerValue - (currentTimeInterval - model.remainTimeInterval);
        if (remainTime > 0) {
            [self displayRemainTime:remainTime];
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:5 inSection:0], nil]];
        }
        self.progressView.hidden = NO;
        self.progressView.percent = model.tenderSchedule.integerValue;
        self.progressView.color = OrangeColor;
        self.tenderScheduleLabel.text = [NSString stringWithFormat:@"%@%%", model.tenderSchedule];
        self.tenderScheduleLabel.textColor = OrangeColor;
        [self.progressView setNeedsDisplay];
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

- (void)displayLimitTime:(NSInteger)limitTime {
    self.limitHourLabel.text = [NSString stringWithFormat:@"%02ld", limitTime / 3600];
    self.limitMinuteLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 / 60];
    self.limitSecondLabel.text = [NSString stringWithFormat:@"%02ld", limitTime % 3600 % 60];
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
    border1.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, Screen_width - 25, 370)].CGPath;
    border1.frame = CGRectMake(0, 0, Screen_width - 25, 370);
    border1.lineWidth = 0.5;
    border1.lineCap = @"square";
    border1.lineDashPattern = @[@4, @2];
    if (self.border) {
        [self.topView.layer replaceSublayer:self.border with:border1];
    } else {
        [self.topView.layer addSublayer:border1];
    }
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TenderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TenderCollectionViewCell" forIndexPath:indexPath];
    
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
