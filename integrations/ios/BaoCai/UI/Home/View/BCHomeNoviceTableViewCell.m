//
//  BCHomeNoviceTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCHomeNoviceTableViewCell.h"

#import "HomeProgressCircleView.h"

@interface BCHomeNoviceTableViewCell ()

@property (nonatomic, strong) UILabel *tenderNameLabel;
@property (nonatomic, strong) HomeProgressCircleView *progressCircleView;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *addRateLabel;
@property (nonatomic, strong) UILabel *investmentHorizonLabel;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation BCHomeNoviceTableViewCell

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
    UIImageView *noviceImageView = [[UIImageView alloc] init];
    noviceImageView.image = [UIImage imageNamed:@"homeNoviceIcon"];
    [self.contentView addSubview:noviceImageView];
    
    [noviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 76));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(25);
    }];
    
    self.tenderNameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.tenderNameLabel.font = [UIFont systemFontOfSize:14.0f * homeHeightScale];
    self.tenderNameLabel.textColor = Color666666;
    self.tenderNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tenderNameLabel];
    
    [self.tenderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(8 * homeHeightScale);
    }];
    
    self.progressCircleView = [[HomeProgressCircleView alloc] initWithFrame:CGRectNull];
    self.progressCircleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.progressCircleView];
    
    [self.progressCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(177 * homeHeightScale, 177 * homeHeightScale));
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    UIImageView *dottedCircleImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
    dottedCircleImageView.image = [UIImage imageNamed:@"homeNoviceBg"];
    [self.progressCircleView addSubview:dottedCircleImageView];
    
    [dottedCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    UIImageView *annualRateImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
    annualRateImageView.image = [UIImage imageNamed:@"homeAnnualRate"];
    [self.progressCircleView addSubview:annualRateImageView];
    
    [annualRateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47 * homeHeightScale, 17 * homeHeightScale));
        make.top.mas_equalTo(35 * homeHeightScale);
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectNull];
    lineView.backgroundColor = RGB_COLOR(239, 239, 239);
    [self.progressCircleView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60 * homeHeightScale);
        make.width.mas_equalTo(60 * homeHeightScale);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *rateView = [[UIView alloc] initWithFrame:CGRectNull];
    [self.progressCircleView addSubview:rateView];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.rateLabel.font = [UIFont boldSystemFontOfSize:22.0f * homeHeightScale];
    self.rateLabel.textColor = OrangeColor;
    self.rateLabel.text = @"10.00";
    [rateView addSubview:self.rateLabel];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    self.addRateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.addRateLabel.font = [UIFont systemFontOfSize:18.0f * homeHeightScale];
    self.addRateLabel.textColor = OrangeColor;
    self.addRateLabel.text = @"+2%";
    [rateView addSubview:self.addRateLabel];
    
    [self.addRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateLabel.mas_right);
        make.bottom.mas_equalTo(self.rateLabel.mas_bottom);
        make.right.mas_equalTo(0);
    }];
    
    [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    self.investmentHorizonLabel = [[UILabel alloc] initWithFrame:CGRectNull];
    self.investmentHorizonLabel.textColor = [UIColor whiteColor];
    self.investmentHorizonLabel.font = [UIFont systemFontOfSize:14 * homeHeightScale];
    [self.progressCircleView addSubview:self.investmentHorizonLabel];
    
    [self.investmentHorizonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(0);
    }];
    
    self.tipsView = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipsView];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-(5 * homeHeightScale));
    }];
}

- (void)reloadData:(TenderItemModel *)model {
    self.tenderNameLabel.text = model.name;
    self.rateLabel.text = model.annualRate;
    self.addRateLabel.text = [NSString stringWithFormat:@"%%%@", (model.increaseApr && model.increaseApr.floatValue > 0) ? [NSString stringWithFormat:@"+%@%%", model.increaseApr] : @""];
    self.investmentHorizonLabel.text = model.investmentHorizon;
    NSString *tenderSchedule = [model.tenderSchedule stringByReplacingOccurrencesOfString:@"" withString:@"%"];
    
    self.progressCircleView.percent = tenderSchedule.floatValue;
    [self.progressCircleView setNeedsDisplay];
    
    NSInteger tipsCount = model.tenderTipsList.count;
    tipsCount = tipsCount > 3 ? 3 : tipsCount;
    
    [self.tipsView removeChildViews];
    UIColor *tipColor = RGB_COLOR(255, 92, 92);
    UILabel *lastLabel = nil;
    
    for (NSInteger i = 0; i < tipsCount; i++) {
        NSString *tipString = [model.tenderTipsList objectAtIndex:i];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = [NSString stringWithFormat:@" %@ ", tipString];
        tipLabel.font = [UIFont systemFontOfSize:10.0f * homeHeightScale];
        tipLabel.textColor = tipColor;
        [tipLabel setBorder:tipColor width:1];
        tipLabel.layer.cornerRadius = 4;
        [self.tipsView addSubview:tipLabel];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18 * homeHeightScale);
            make.top.mas_equalTo(self.tipsView.mas_top);
            make.bottom.mas_equalTo(self.tipsView.mas_bottom);
            
            if (i == 0) {
                make.left.mas_equalTo(self.tipsView.mas_left);
                if (tipsCount == 1) {
                    make.right.mas_equalTo(self.tipsView.mas_right);
                }
            } else if (i == tipsCount - 1) {
                make.left.mas_equalTo(lastLabel.mas_right).offset(5 * homeHeightScale);
                make.right.mas_equalTo(self.tipsView.mas_right);
            } else {
                make.left.mas_equalTo(lastLabel.mas_right).offset(5 * homeHeightScale);
            }
        }];
        
        lastLabel = tipLabel;
    }
}

@end
