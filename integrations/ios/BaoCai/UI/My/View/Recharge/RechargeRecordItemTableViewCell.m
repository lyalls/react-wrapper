//
//  RechargeRecordItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/9.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "RechargeRecordItemTableViewCell.h"

@interface RechargeRecordItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *cashAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;

@end

@implementation RechargeRecordItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)reloadData:(NSDictionary *)dic {
    self.cashAccountLabel.text = [dic objectForKey:@"cashAccount"];
    self.stateLabel.text = [dic objectForKey:@"statusMsg"];
    self.addTimeLabel.text = [dic objectForKey:@"addtime"];
}

@end
