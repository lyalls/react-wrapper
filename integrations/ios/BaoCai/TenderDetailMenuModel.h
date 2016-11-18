//
//  TenderDetailMenuModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PageNameType) {
    PageNameTypeTZJL,
    PageNameTypeXMXQ
};

@interface TenderDetailMenuModel : NSObject

@property (nonatomic, assign) PageNameType pageNameType;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

+ (NSMutableArray *)getDataWithPurchaseNumber:(NSString *)purchaseNumber;

@end
