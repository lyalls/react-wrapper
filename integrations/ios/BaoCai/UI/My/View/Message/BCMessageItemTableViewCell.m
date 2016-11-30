//
//  BCMessageItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMessageItemTableViewCell.h"

@interface BCMessageItemTableViewCell ()

@property (nonatomic, strong) UILabel *messageTitleLabel;
@property (nonatomic, strong) UILabel *messageDateLabel;

@end

@implementation BCMessageItemTableViewCell

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
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(-0.5);
    }];
    
    self.messageTitleLabel = [[UILabel alloc] init];
    self.messageTitleLabel.textColor = Color666666;
    self.messageTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    [topView addSubview:self.messageTitleLabel];
    
    [self.messageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(10);
    }];
    
    self.messageDateLabel = [[UILabel alloc] init];
    self.messageDateLabel.textColor = RGB_COLOR(204, 204, 204);
    self.messageDateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.messageDateLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:self.messageDateLabel];
    
    [self.messageDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(-10);
        make.width.equalTo(80);
        make.left.equalTo(self.messageTitleLabel.mas_right).mas_offset(15);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MessageItemModel *)model {
    self.messageTitleLabel.text = model.messageTitle;
    self.messageDateLabel.text = [[model.messageDate componentsSeparatedByString:@" "] objectAtIndex:0];
    if([model.messageStatus isEqualToString:@"0"]) {
        self.messageTitleLabel.textColor = Color666666;
        self.messageDateLabel.textColor = Color666666;
    } else {
        self.messageTitleLabel.textColor = RGB_COLOR(204, 204, 204);
        self.messageDateLabel.textColor = RGB_COLOR(204, 204, 204);
    }
}

@end
