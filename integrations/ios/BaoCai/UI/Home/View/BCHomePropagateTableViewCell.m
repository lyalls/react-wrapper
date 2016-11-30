//
//  BCHomePropagateTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCHomePropagateTableViewCell.h"

@implementation HomePropagateItem

@end

@implementation BCHomePropagateTableViewCell

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
    NSMutableArray *displayArray = [NSMutableArray arrayWithCapacity:0];
    
    HomePropagateItem *item1 = [[HomePropagateItem alloc] init];
    item1.imageName = @"homePropagate1";
    item1.title = @"上市系";
    item1.detailTitle = @"A股上市公司战略投资";
    [displayArray addObject:item1];
    
    HomePropagateItem *item2 = [[HomePropagateItem alloc] init];
    item2.imageName = @"homePropagate2";
    item2.title = @"首批会员";
    item2.detailTitle = @"中国互联网金融协会";
    [displayArray addObject:item2];
    
    HomePropagateItem *item3 = [[HomePropagateItem alloc] init];
    item3.imageName = @"homePropagate3";
    item3.title = @"风险准备金";
    item3.detailTitle = @"浦发银行托管";
    [displayArray addObject:item3];
    
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < displayArray.count; i++) {
        HomePropagateItem *item = [displayArray objectAtIndex:i];
        
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentView.mas_height);
            if (i == 0) {
                make.leading.mas_equalTo(self.contentView.mas_leading);
            } else if (i == (displayArray.count - 1)) {
                make.leading.mas_equalTo(lastView.mas_trailing).offset(1);
                make.trailing.mas_equalTo(self.contentView.mas_trailing);
                make.width.mas_equalTo(lastView.mas_width);
            } else {
                make.leading.mas_equalTo(lastView.mas_trailing).offset(1);
                make.width.mas_equalTo(lastView.mas_width);
            }
        }];
        
        if (i != displayArray.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectNull];
            lineView.backgroundColor = BackViewColor;
            [self.contentView addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(itemView.mas_trailing);
                make.centerY.mas_equalTo(0);
                make.height.mas_equalTo(50 * homeHeightScale);
                make.width.mas_equalTo(1);
            }];
        }
        
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        itemImageView.image = [UIImage imageNamed:item.imageName];
        [itemView addSubview:itemImageView];
        
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(28 * homeHeightScale, 28 * homeHeightScale));
            make.top.mas_equalTo(6 * homeHeightScale);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *itemLabel1 = [[UILabel alloc] initWithFrame:CGRectNull];
        itemLabel1.text = item.title;
        itemLabel1.font = [UIFont systemFontOfSize:10.0f * homeHeightScale];
        itemLabel1.textColor = OrangeColor;
        [itemView addSubview:itemLabel1];
        
        [itemLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemImageView.mas_bottom).offset(5 * homeHeightScale);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *itemLabel2 = [[UILabel alloc] initWithFrame:CGRectNull];
        itemLabel2.text = item.detailTitle;
        itemLabel2.font = [UIFont systemFontOfSize:8.0f * homeHeightScale];
        itemLabel2.textColor = Color666666;
        [itemView addSubview:itemLabel2];
        
        [itemLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemLabel1.mas_bottom).offset(2 * homeHeightScale);
            make.centerX.mas_equalTo(0);
        }];
        
        lastView = itemView;
    }
}

@end
