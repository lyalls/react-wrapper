//
//  BCHomeBannerTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/26.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BannerItemClickBlock)(NSDictionary *dic);

@interface BCHomeBannerTableViewCell : UITableViewCell

- (void)reloadBannerData:(NSMutableArray *)imageArray bannerItemClickBlock:(BannerItemClickBlock)bannerItemClickBlock;

@end
