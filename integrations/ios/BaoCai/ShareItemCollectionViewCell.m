//
//  ShareItemCollectionViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "ShareItemCollectionViewCell.h"

@interface ShareItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ShareItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reloadData:(NSDictionary *)dic {
    self.iconImageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    self.titleLabel.text = [dic objectForKey:@"title"];
}

@end
