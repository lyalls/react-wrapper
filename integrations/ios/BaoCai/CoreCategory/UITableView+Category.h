//
//  UITableView+Category.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Category)

typedef NS_ENUM(NSInteger, FromType) {
    FROM_HOME,
    FROM_MY,
};


- (void)registerCellNibWithClass:(Class)className;

- (void)setRefreshGifHeader:(NSInteger)fromType;
+(void)randSlogan;
@end
