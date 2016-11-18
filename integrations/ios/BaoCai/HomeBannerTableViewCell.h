//
//  HomeBannerTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BannerItemClickBlock)(NSDictionary *dic);

@interface HomeBannerTableViewCell : UITableViewCell

- (void)setupView:(NSMutableArray *)dataArray bannerItemClickBlock:(BannerItemClickBlock)bannerItemClickBlock;

@end
