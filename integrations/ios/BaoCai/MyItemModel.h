//
//  MyItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyPageDataModel.h"

typedef NS_ENUM(NSUInteger, MyItemModelType) {
    MyItemModelTypeTitleDesc,
    MyItemModelTypeUnRead,
    MyItemModelTypeNewVersion
};

typedef NS_ENUM(NSUInteger, PageNameType) {
    PageNameTypeSBTZ,
    PageNameTypeZQZR,
    PageNameTypeSetting,
    PageNameTypeTicket,
    PageNameTypeInviteFriends,
    PageNameTypeCustomService
};

@interface MyItemModel : NSObject

@property (nonatomic, assign) PageNameType pageNameType;
@property (nonatomic, assign) MyItemModelType type;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL isHasUnRead;
@property (nonatomic, assign) BOOL isHasNewVersion;

+ (NSMutableArray *)getDataWithIsHasUnRead:(BOOL)isHasUnRead isHasNewVersion:(BOOL)isHasNewVersion withMyPageDataModel:(MyPageDataModel *)model;

@end
