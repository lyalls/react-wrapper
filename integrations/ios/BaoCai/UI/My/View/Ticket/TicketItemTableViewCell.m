//
//  TicketItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "TicketItemTableViewCell.h"

@interface TicketItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *secondPointView;
@property (weak, nonatomic) IBOutlet UILabel *secondDescLabel;

@end

@implementation TicketItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(TicketItemModel *)model ticketListType:(TicketListType)ticketListType {
    self.titleLabel.text = model.ticketDesc;
    [self.titleLabel sizeToFit];
    self.expiredTimeLabel.text = model.expiredTime;
    self.moneyLabel.text = model.money;
    
    self.secondDescLabel.text = model.ticketDurationDesc;
    if (model.ticketDurationDesc && model.ticketDurationDesc.length != 0) {
        self.secondPointView.hidden = NO;
    } else {
        self.secondPointView.hidden = YES;
    }
    
    if (ticketListType == TicketListTypeUnused) {
        self.backImageView.image = [UIImage imageNamed:@"ticketHeaderImage.png"];
    } else {
        self.backImageView.image = [UIImage imageNamed:@"ticketHeaderImage_expired@2x.png"];
    }
}

@end
