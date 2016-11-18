//
//  HomeNoviceTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "HomeNoviceTableViewCell.h"
#import "HomeProgressCircleView.h"

@interface HomeNoviceTableViewCell ()

@property (weak, nonatomic) IBOutlet HomeProgressCircleView *progressCircleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressCircleViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressCircleViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *annualRateTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *annualRateWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *annualRateHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentHorizonLabel;

@property (weak, nonatomic) IBOutlet UILabel *tip1Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip1LabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip1LabelRightContraint;

@property (weak, nonatomic) IBOutlet UILabel *tip2Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip2LabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip2LabelRightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *tip3Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip3LabelHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewBottomConstraint;

@end

@implementation HomeNoviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.progressCircleViewWidthConstraint.constant = self.progressCircleViewWidthConstraint.constant * homeHeightScale;
    self.progressCircleViewHeightConstraint.constant = self.progressCircleViewHeightConstraint.constant * homeHeightScale;
    
    self.annualRateTopConstraint.constant = self.annualRateTopConstraint.constant * homeHeightScale;
    self.annualRateWidthConstraint.constant = self.annualRateWidthConstraint.constant * homeHeightScale;
    self.annualRateHeightConstraint.constant = self.annualRateHeightConstraint.constant * homeHeightScale;
    
    self.lineViewTopConstraint.constant = self.lineViewTopConstraint.constant * homeHeightScale;
    self.lineViewWidthConstraint.constant = self.lineViewWidthConstraint.constant * homeHeightScale;
    
    self.nameLabelTopConstraint.constant = self.nameLabelTopConstraint.constant * homeHeightScale;
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f * homeHeightScale];
    self.annualRateLabel.font = [UIFont boldSystemFontOfSize:22.0 * homeHeightScale];
    self.addRateLabel.font = [UIFont systemFontOfSize:18 * homeHeightScale];
    self.investmentHorizonLabel.font = [UIFont systemFontOfSize:14 * homeHeightScale];
    
    self.tip1Label.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    self.tip2Label.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    self.tip3Label.font = [UIFont systemFontOfSize:10 * homeHeightScale];
    
    self.tip1LabelHeightConstraint.constant = self.tip1LabelHeightConstraint.constant * homeHeightScale;
    self.tip2LabelHeightConstraint.constant = self.tip2LabelHeightConstraint.constant * homeHeightScale;
    self.tip3LabelHeightConstraint.constant = self.tip3LabelHeightConstraint.constant * homeHeightScale;
    
    self.tagsViewBottomConstraint.constant = self.tagsViewBottomConstraint.constant * homeHeightScale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(TenderItemModel *)model {
    self.nameLabel.text = model.name;
    self.annualRateLabel.text = model.annualRate;
    self.addRateLabel.text = [NSString stringWithFormat:@"%%%@", (model.increaseApr && model.increaseApr.floatValue > 0) ? [NSString stringWithFormat:@"+%@%%", model.increaseApr] : @""];
    self.investmentHorizonLabel.text = model.investmentHorizon;
    NSString *tenderSchedule = [model.tenderSchedule stringByReplacingOccurrencesOfString:@"" withString:@"%"];
    
    self.progressCircleView.percent = tenderSchedule.floatValue;
    [self.progressCircleView setNeedsDisplay];
    
    self.tip1Label.text = @"";
    self.tip2Label.text = @"";
    self.tip3Label.text = @"";
    self.tip1Label.hidden = YES;
    self.tip2Label.hidden = YES;
    self.tip3Label.hidden = YES;
    
    UIColor *tipColor = RGB_COLOR(255, 92, 92);
    
    switch (model.tenderTipsList.count) {
        case 0: {
        }
            
            break;
        case 1: {
            self.tip1Label.hidden = NO;
            self.tip1Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:0]];
            [self.tip1Label setBorder:tipColor width:1];
            self.tip1Label.layer.cornerRadius = 4;
            self.tip1LabelRightContraint.constant = 0;
        }
            
            break;
        case 2: {
            self.tip1Label.hidden = NO;
            self.tip1Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:0]];
            [self.tip1Label setBorder:tipColor width:1];
            self.tip1Label.layer.cornerRadius = 4;
            self.tip1LabelRightContraint.constant = 5;
            
            self.tip2Label.hidden = NO;
            self.tip2Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:1]];
            [self.tip2Label setBorder:tipColor width:1];
            self.tip2Label.layer.cornerRadius = 4;
            self.tip2LabelRightConstraint.constant = 0;
        }
            
            break;
            
        default: {
            self.tip1Label.hidden = NO;
            self.tip1Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:0]];
            [self.tip1Label setBorder:tipColor width:1];
            self.tip1Label.layer.cornerRadius = 4;
            self.tip1LabelRightContraint.constant = 5;
            
            self.tip2Label.hidden = NO;
            self.tip2Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:1]];
            [self.tip2Label setBorder:tipColor width:1];
            self.tip2Label.layer.cornerRadius = 4;
            self.tip2LabelRightConstraint.constant = 5;
            
            self.tip3Label.hidden = NO;
            self.tip3Label.text = [NSString stringWithFormat:@" %@ ", [model.tenderTipsList objectAtIndex:2]];
            [self.tip3Label setBorder:tipColor width:1];
            self.tip3Label.layer.cornerRadius = 4;
        }
            break;
    }
}

@end
