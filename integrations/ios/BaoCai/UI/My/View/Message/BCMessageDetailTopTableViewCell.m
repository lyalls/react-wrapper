//
//  BCMessageDetailTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMessageDetailTopTableViewCell.h"

@interface BCMessageDetailTopTableViewCell ()

@property (nonatomic, strong) UILabel *messageTitleLable;
@property (nonatomic, strong) UILabel *messageDateLabel;

@end

@implementation BCMessageDetailTopTableViewCell

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
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 0.5, 10));
    }];
    
    self.messageTitleLable = [[UILabel alloc] init];
    self.messageTitleLable.font = [UIFont systemFontOfSize:16.0f];
    self.messageTitleLable.textColor = Color666666;
    self.messageTitleLable.numberOfLines = 2;
    [topView addSubview:self.messageTitleLable];
    
    [self.messageTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(3);
        make.height.equalTo(50);
    }];
	
    self.messageDateLabel = [[UILabel alloc] init];
    self.messageDateLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageDateLabel.textColor = Color999999;
    [topView addSubview:self.messageDateLabel];
    
    [self.messageDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(self.messageTitleLable.mas_bottom);
        make.bottom.equalTo(0);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MessageItemModel *)model {
    self.messageTitleLable.text = model.messageTitle;
    self.messageDateLabel.text = model.messageDate;
}

@end
