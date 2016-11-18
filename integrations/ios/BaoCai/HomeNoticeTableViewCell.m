//
//  HomeNoticeTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "HomeNoticeTableViewCell.h"

#import "MarqueeLabel.h"

@interface HomeNoticeTableViewCell ()

@property (weak, nonatomic) IBOutlet MarqueeLabel *scrollLabel;

@property (nonatomic, strong) CloseNotice block;

@end

@implementation HomeNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.scrollLabel.marqueeType = MLContinuous;
    self.scrollLabel.scrollDuration = 20;
    self.scrollLabel.animationDelay = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(NSMutableArray *)strings closeNotice:(CloseNotice)closeNotice {
    self.block = closeNotice;
    
    NSMutableString *displayStr = [NSMutableString stringWithCapacity:0];
    
    for (NSString *str in strings) {
        [displayStr appendFormat:@"%@  ", str];
    }
    
    self.scrollLabel.font = [UIFont systemFontOfSize:10 * autoSizeScaleHeight];
    self.scrollLabel.text = displayStr;
    [self.scrollLabel restartLabel];
}

- (IBAction)closeBtnClick:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
