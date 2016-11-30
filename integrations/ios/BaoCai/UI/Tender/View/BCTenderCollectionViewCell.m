//
//  BCTenderCollectionViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/2.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCTenderCollectionViewCell.h"

@interface BCTenderCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation BCTenderCollectionViewCell

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
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = Color999999;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(14);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont systemFontOfSize:12.0f];
    self.valueLabel.textColor = Color666666;
    [self.contentView addSubview:self.valueLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(14);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(22);
    }];
}

- (void)reloadData:(NSDictionary *)dic {
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.valueLabel.text = [dic objectForKey:@"value"];
}

@end
