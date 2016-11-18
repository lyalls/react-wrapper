//
//  MessageDetailTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MessageDetailTopTableViewCell.h"

@interface MessageDetailTopTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;

@end

@implementation MessageDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(MessageItemModel *)model {
    self.messageTitleLable.text = model.messageTitle;
    self.messageDateLabel.text = model.messageDate;
}

@end
