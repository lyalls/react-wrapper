//
//  MJRefreshGifHeader-UIImage.h
//  BaoCai
//
//  Created by lishuo on 16/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>
typedef NS_ENUM(NSInteger, FromType) {
    FROM_HOME,
    FROM_MY,
};
@interface MJRefreshGifHeader (UIImage)


- (void)setRefreshGifHeader:(NSInteger)fromType;

+(void)randSlogan;
@end
