//
//  BCRefreshGifHeader.h
//  BaoCai
//
//  Created by lishuo on 16/11/23.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
typedef NS_ENUM(NSInteger, FromType) {
    FROM_HOME,
    FROM_MY,
};


@interface BCRefreshGifHeader : MJRefreshGifHeader
-(void)setRefreshGifHeaderType:(NSInteger)fromType;
@end
