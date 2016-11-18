//
//  FullRecordTableViewCell.m
//  BaoCai
//
//  Created by baocai on 16/10/10.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "FullRecordTableViewCell.h"

@interface FullRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@end

@implementation FullRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(NSString *)string {
    self.rewardLabel.text = string;
    
    CGFloat width = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.rewardLabel.font, NSFontAttributeName, nil] context:nil].size.width;
    self.leadingConstraint.constant = (Screen_width - 33 - 5 - width) / 2;
    self.trailingConstraint.constant = (Screen_width - 33 - 5 - width) / 2;
}

@end
