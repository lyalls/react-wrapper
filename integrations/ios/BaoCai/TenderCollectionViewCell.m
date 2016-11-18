//
//  TenderCollectionViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderCollectionViewCell.h"

@interface TenderCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation TenderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reloadData:(NSDictionary *)dic {
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.valueLabel.text = [dic objectForKey:@"value"];
}

@end
