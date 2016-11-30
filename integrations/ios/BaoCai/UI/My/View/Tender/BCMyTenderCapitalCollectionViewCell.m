//
//  BCMyTenderCapitalCollectionViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTenderCapitalCollectionViewCell.h"

@interface BCMyTenderCapitalCollectionViewCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BCMyTenderCapitalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = OrangeColor;
    self.valueLabel.font = [UIFont systemFontOfSize:12.0f * homeHeightScale];
    [self.contentView addSubview:self.valueLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-5);
        make.top.equalTo(11);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = RGB_COLOR(135, 135, 135);
    self.nameLabel.font = [UIFont systemFontOfSize:11.0f * homeHeightScale];
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-5);
        make.bottom.equalTo(-11);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = BackViewColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.bottom.equalTo(-5);
        make.right.equalTo(0);
        make.width.equalTo(1);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(NSMutableDictionary *)dic isEnd:(BOOL)isEnd isCenter:(BOOL)isCenter {
    self.valueLabel.text = [dic objectForKey:@"value"];
    self.valueLabel.textAlignment = isCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.nameLabel.textAlignment = isCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    
    self.lineView.hidden = isEnd;
}

@end
