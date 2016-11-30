//
//  InviteFriendsTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "InviteFriendsTableViewCell.h"

@interface InviteFriendsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *regTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitTotalRewardLabel;

@end

@implementation InviteFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(InviteFriendsListItemModel *)model {
    self.friendNameLabel.text = model.phone;
    self.regTimeLabel.text = model.regTime;
    self.waitTotalRewardLabel.text = model.waitTotalReward;
}

@end
