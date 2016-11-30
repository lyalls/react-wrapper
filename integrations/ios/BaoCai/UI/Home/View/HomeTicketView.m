//
//  HomeTicketView.m
//  BaoCai
//
//  Created by 刘国龙 on 16/8/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "HomeTicketView.h"

@interface HomeTicketView ()

@property (weak, nonatomic) IBOutlet UILabel *prompt1Label;
@property (weak, nonatomic) IBOutlet UILabel *prompt2Label;
@property (weak, nonatomic) IBOutlet UILabel *prompt3Label;
@property (weak, nonatomic) IBOutlet UIButton *toTicketViewBtn;

@end

@implementation HomeTicketView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.toTicketViewBtn.layer.cornerRadius = 4;
}

- (void)reloadData:(NSMutableArray *)array {
    self.prompt1Label.text = [array objectAtIndex:0];
    self.prompt2Label.text = [array objectAtIndex:1];
    self.prompt3Label.text = [array objectAtIndex:2];
}

- (IBAction)closeViewBtnClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)toTicketViewBtnClick:(id)sender {
    if (self.block)
        self.block();
}

@end
