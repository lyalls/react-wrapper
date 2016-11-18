//
//  TenderRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderRequest.h"

@implementation TenderRequest

+ (void)getHomeTenderListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@top/borrow/manage/list", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getTenderListWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general", kServerAddress] args:args success:success failure:failure];
}

+ (void)getTenderDetailWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general/%@", kServerAddress, tenderId] args:nil success:success failure:failure];
}

+ (void)getTenderRecordListWithTenderId:(NSString *)tenderId pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general/%@/records", kServerAddress, tenderId] args:args success:success failure:failure];
}

+ (void)getTenderAvailableAmountAndBalanceWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general/%@/tender", kServerAddress, tenderId] args:nil success:success failure:failure];
}

+ (void)getTenderCalculatorWithTenderId:(NSString *)tenderId borrowAmount:(NSString *)borrowAmount bonusId:(NSNumber*)bonusId increaseId:(NSNumber*)increaseId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:borrowAmount forKey:@"borrowAmount"];
    [args setObject:bonusId forKey:@"bonusTicketId"];
    [args setObject:increaseId forKey:@"increaseTicketId"];
    [args setObject:@"hand" forKey:@"tenderUseTicketStyle"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@tools/interests/%@", kServerAddress, tenderId] args:args success:success failure:failure];
}

//获取红包列表
+(void) getBonusList:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure
{
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/bonus/ticket/list", kServerAddress] args:nil success:success failure:failure];
}
//获取加息列表
+(void) getIncreaseList:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure
{
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/increase/ticket/list", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getTenderUserStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/precheck", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getTenderProtocolWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:tenderId forKey:@"borrowId"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/protocol", kServerAddress] args:args success:success failure:failure];
}

+ (void)payTenderWithTenderId:(NSString *)tenderId borrowAmount:(NSString *)borrowAmount bonusId:(NSNumber*)bonusId increaseId:(NSNumber*)increaseId payPassword:(NSString *)payPassword paySecond:(BOOL)paySecond activityCode:(NSString *)activityCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:borrowAmount forKey:@"bidAmount"];
    [args setObject:bonusId forKey:@"bonusTicketId"];
    [args setObject:increaseId forKey:@"increaseTicketId"];
    [args setObject:@"hand" forKey:@"tenderUseTicketStyle"];
    [args setObject:[payPassword md5Encrypt] forKey:@"payPassword"];
    [args setObject:@"3" forKey:@"from"];
    [args setObject:@(paySecond) forKey:@"tenderStatus"];
    [args setObject:activityCode ? activityCode : @"" forKey:@"activeZXCode"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general/%@/tender", kServerAddress, tenderId] args:args success:success failure:failure];
}

+ (void)getUserIsNoviceWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/user/type", kServerAddress] args:nil success:success failure:failure];
}

+ (void)checkTenderActivityCodeWithTenderId:(NSString *)tenderId withActiveCode:(NSString *)activeCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:activeCode forKey:@"activeCode"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@invests/general/tender/activity/%@/code", kServerAddress, tenderId] args:args success:success failure:failure];
}

@end
