//
//  BCMessageDetailContentTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMessageDetailContentTableViewCell.h"

@interface BCMessageDetailContentTableViewCell ()

@property (nonatomic, strong) UILabel *messageContentLabel;

@end

@implementation BCMessageDetailContentTableViewCell

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
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    
    self.messageContentLabel = [[UILabel alloc] init];
    self.messageContentLabel.font = [UIFont systemFontOfSize:16.0];
    self.messageContentLabel.textColor = Color666666;
    self.messageContentLabel.numberOfLines = 0;
    [topView addSubview:self.messageContentLabel];
    
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MessageItemModel *)model {
    self.messageContentLabel.text = model.messageContent;
}

@end
