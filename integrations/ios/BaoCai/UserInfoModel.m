//
//  UserInfoModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (UserInfoModel *)sharedModel {
    static UserInfoModel *sharedUserInfoModelInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserInfoModelInstance = [[self alloc] init];
    });
    return sharedUserInfoModelInstance;
}

- (NSString *)userId {
    return [[UserDefaultsHelper sharedManager].userInfo stringForKey:@"userId"];
}

- (NSString *)userName {
    return [[UserDefaultsHelper sharedManager].userInfo objectForKey:@"userName"];
}

- (NSString *)phone {
    return [[UserDefaultsHelper sharedManager].userInfo objectForKey:@"phone"];
}

- (NSString *)email {
    return [[UserDefaultsHelper sharedManager].userInfo objectForKey:@"email"];
}

- (NSString *)token {
    return [[[UserDefaultsHelper sharedManager].userInfo stringForKey:@"token"] aes256_decrypt];
}

- (BOOL)realNameAuth {
    return [[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 1 || [[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2;
}

- (NSString *)expiredTime {
    return [[UserDefaultsHelper sharedManager].userInfo objectForKey:@"expiredTime"];
}

- (NSString *)cardID {
    return [[UserDefaultsHelper sharedManager].userInfo objectForKey:@"cardID"];
}

- (BOOL)isSetPayPassword {
    return [[UserDefaultsHelper sharedManager].userInfo boolForKey:@"isSetPayPassword"];
}

- (NSMutableArray *)rewardMsg {
    return [[UserDefaultsHelper sharedManager].userInfo mutableArrayValueForKey:@"rewardMsg"];
}

@end
