//
//  HomeNoticeTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CloseNotice)();

@interface HomeNoticeTableViewCell : UITableViewCell

- (void)reloadData:(NSMutableArray *)strings closeNotice:(CloseNotice)closeNotice;

@end
