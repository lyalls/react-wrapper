//
//  BCHomeNoticeTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCHomeNoticeTableViewCell : UITableViewCell

- (void)reloadData:(NSMutableArray *)strings closeNotice:(void (^)())closeNotice;

@end
