//
//  UserDefaultsHelper.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UserDefaultsHelper.h"

#import "UMMobClick/MobClick.h"

@implementation UserDefaultsHelper

+ (UserDefaultsHelper *)sharedManager {
    static UserDefaultsHelper *sharedUserDefaultsHelperInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserDefaultsHelperInstance = [[self alloc] init];
    });
    return sharedUserDefaultsHelperInstance;
}

+ (void)saveUserDefaultsBool:(BOOL)value key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveUserDefaultObject:(NSObject *)value key:(NSString *)key {
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *info = [[userInfo JSONString] mutableObjectFromJSONString];
    [info setObject:[[info objectForKey:@"token"] aes256Encrypt] forKey:@"token"];
    [UserDefaultsHelper saveUserDefaultObject:info key:@"userInfo"];
    [MobClick profileSignInWithPUID:[userInfo stringForKey:@"userId"]];
}

- (NSDictionary *)userInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
}

- (void)setBannerVersion:(NSString *)bannerVersion {
    [UserDefaultsHelper saveUserDefaultObject:bannerVersion key:@"bannerVersion"];
}

- (NSString *)bannerVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerVersion"];
}

- (void)setBannerInfo:(NSDictionary *)bannerInfo {
    [UserDefaultsHelper saveUserDefaultObject:bannerInfo key:@"bannerInfo"];
}

- (NSDictionary *)bannerInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerInfo"];
}

- (void)setBankAreaVersion:(NSString *)bankAreaVersion {
    [UserDefaultsHelper saveUserDefaultObject:bankAreaVersion key:@"bankAreaVersion"];
}

- (NSString *)bankAreaVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bankAreaVersion"];
}

- (void)setAreaList:(NSMutableArray *)areaList {
    [UserDefaultsHelper saveUserDefaultObject:areaList key:@"areaList"];
}

- (NSMutableArray *)areaList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"areaList"];
}

- (void)setBankList:(NSMutableArray *)bankList {
    [UserDefaultsHelper saveUserDefaultObject:bankList key:@"bankList"];
}

- (NSMutableArray *)bankList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bankList"];
}

- (void)setBankSupportList:(NSMutableArray *)bankSupportList {
    [UserDefaultsHelper saveUserDefaultObject:bankSupportList key:@"bankSupportList"];
}

- (NSMutableArray *)bankSupportList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bankSupportList"];
}

- (void)setGesturePwd:(NSString *)gesturePwd {
    [UserDefaultsHelper saveUserDefaultObject:gesturePwd key:@"gesturePwd"];
}

- (NSString *)gesturePwd {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePwd"];
}

- (void)setIsNewVersion:(BOOL)isNewVersion {
    [UserDefaultsHelper saveUserDefaultsBool:isNewVersion key:@"isNewVersion"];
}

- (BOOL)isNewVersion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isNewVersion"];
}

- (void)setTemporaryToken:(NSString *)temporaryToken {
    [UserDefaultsHelper saveUserDefaultObject:temporaryToken key:@"temporaryToken"];
}

- (NSString *)temporaryToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryToken"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [UserDefaultsHelper saveUserDefaultObject:deviceToken key:@"deviceToken"];
}

- (NSString *)deviceToken {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    return @"";
}

- (void)setIsShow401Alert:(BOOL)isShow401Alert {
    [UserDefaultsHelper saveUserDefaultsBool:isShow401Alert key:@"isShow401Alert"];
}

- (BOOL)isShow401Alert {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isShow401Alert"];
}

- (void)setActivityCodeDic:(NSMutableDictionary *)activityCodeDic {
    [UserDefaultsHelper saveUserDefaultObject:activityCodeDic key:@"activityCodeDic"];
}

- (NSMutableDictionary *)activityCodeDic {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activityCodeDic"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"activityCodeDic"];
    return [NSMutableDictionary dictionaryWithCapacity:0];
}

- (void)setVersion:(NSString *)version {
    [UserDefaultsHelper saveUserDefaultObject:version key:@"version"];
}

- (NSString *)version {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"version"])
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    return @"";
}

- (void)setIsShareExit:(BOOL)isShareExit {
    [UserDefaultsHelper saveUserDefaultsBool:isShareExit key:@"isShareExit"];
}

- (BOOL)isShareExit {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isShareExit"];
}

- (void)setIsFirstEnter:(BOOL)isFirstEnter {
    [UserDefaultsHelper saveUserDefaultsBool:isFirstEnter key:@"isFirstEnter"];
}

- (BOOL)isFirstEnter {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstEnter"];
}

- (void)setIsShowMoney:(BOOL)isShowMoney {
    [UserDefaultsHelper saveUserDefaultsBool:isShowMoney key:@"isShowMoney"];
}

- (BOOL)isShowMoney {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowMoney"];
}


//-(void)setSlogan:(NSDictionary *)slogan
//{
//    [UserDefaultsHelper saveUserDefaultObject:slogan key:@"slogan"];
//}
//-(NSDictionary*)slogan
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"slogan"];
//}
-(NSString *)sloganVersion
{
    if (![self.slogan objectForKey:@"sloganVersion"])
        return @"";
    return [NSString stringWithFormat:@"%@",[self.slogan objectForKey:@"sloganVersion"]];
}
//-(NSString *)strSlogan
//{
//
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"strSlogan"];
//}
@end
