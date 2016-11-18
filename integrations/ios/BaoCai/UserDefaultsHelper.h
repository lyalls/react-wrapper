//
//  UserDefaultsHelper.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsHelper : NSObject

+ (UserDefaultsHelper *)sharedManager;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSString *bannerVersion;

@property (nonatomic, strong) NSDictionary *bannerInfo;

@property (nonatomic, strong) NSString *bankAreaVersion;

@property (nonatomic, strong) NSMutableArray *areaList;

@property (nonatomic, strong) NSMutableArray *bankList;

@property (nonatomic, strong) NSMutableArray *bankSupportList;

@property (nonatomic, strong) NSString *gesturePwd;

@property (nonatomic, assign) BOOL isNewVersion;

@property (nonatomic, strong) NSString *temporaryToken;

@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, assign) BOOL isShow401Alert;

@property (nonatomic, strong) NSMutableDictionary *activityCodeDic;

@property (nonatomic, strong) NSString *version;

@property (nonatomic, assign) BOOL isShareExit;

@property (nonatomic, assign) BOOL isFirstEnter;

@property (nonatomic, assign) BOOL isShowMoney;

@property (nonatomic,strong) NSDictionary *slogan;
@property (nonatomic,strong,readonly)NSString *sloganVersion;
@property (nonatomic,strong,readonly)NSString *strSlogan;
@end
