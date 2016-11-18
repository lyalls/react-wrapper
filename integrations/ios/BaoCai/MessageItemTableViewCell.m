//
//  MessageItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MessageItemTableViewCell.h"

@interface MessageItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;

@end

@implementation MessageItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Custom method

- (void)reloadData:(MessageItemModel *)model {
    self.messageTitleLabel.text = model.messageTitle;
    self.messageDateLabel.text = [[model.messageDate componentsSeparatedByString:@" "] objectAtIndex:0];
    if([model.messageStatus isEqualToString:@"0"])
    {
        self.messageTitleLabel.textColor = RGB_COLOR(102, 102, 102);
        self.messageDateLabel.textColor = RGB_COLOR(102, 102, 102);
    }
    else
    {
        self.messageTitleLabel.textColor = RGB_COLOR(204, 204, 204);
        self.messageDateLabel.textColor = RGB_COLOR(204, 204, 204);

    }
}

@end
