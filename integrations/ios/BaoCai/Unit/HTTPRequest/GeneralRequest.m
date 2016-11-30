//
//  GeneralRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "GeneralRequest.h"

@implementation GeneralRequest

+ (void)getBankAreaListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:[UserDefaultsHelper sharedManager].bankAreaVersion ? [UserDefaultsHelper sharedManager].bankAreaVersion : @"" forKey:@"bankAreaVersion"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@system/bank/area", kServerAddress] args:args success:success failure:failure];
}

+ (void)getActivityWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@event/activity/pages", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getUnReadMessageWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/messages/unread/num", kServerAddress] args:nil success:success failure:failure];
}

+ (void)checkVersionWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:SHORTVERSION forKey:@"curVersionName"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@system/update/ios", kServerAddress] args:args success:success failure:failure];
}

+ (void)sendIDFA {
    [HTTPRequest send:[NSString stringWithFormat:@"%@analysis/activation/circular/%@", kServerAddress, IDFA] args:nil success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            [UserDefaultsHelper sharedManager].isFirstEnter = YES;
        } else {
            [UserDefaultsHelper sharedManager].isFirstEnter = NO;
        }
    } failure:^(NSError *error) {
        [UserDefaultsHelper sharedManager].isFirstEnter = NO;
    }];
}

+(void)getSloganRequestWithVersion:(NSString*)sloganVersion success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure
{
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:sloganVersion ? sloganVersion : @"" forKey:@"version"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@top/slogan", kServerAddress] args:args success:success failure:failure];
}

@end
