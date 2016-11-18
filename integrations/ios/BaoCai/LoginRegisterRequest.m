//
//  LoginRegisterRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/11.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "LoginRegisterRequest.h"

@implementation LoginRegisterRequest

#pragma mark - Login Request Method

+ (void)loginRequestWithUsername:(NSString *)username password:(NSString *)password success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:username forKey:@"keywords"];
    [args setObject:[password md5Encrypt] forKey:@"password"];
    [args setObject:[UserDefaultsHelper sharedManager].deviceToken forKey:@"deviceToken"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/login", kServerAddress] args:args success:success failure:failure];
}

+ (void)logoutRequestWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/logout", kServerAddress] args:nil success:success failure:failure];
}

#pragma mark - Register Request Method

+ (void)registerSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/phone/sign", kServerAddress] args:args success:success failure:failure];
}

+ (void)registerSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:sign forKey:@"reg_sign"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/phone/code", kServerAddress] args:args success:success failure:failure];
}

+ (void)registerCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:code forKey:@"code"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/phone", kServerAddress] args:args success:success failure:failure];
}

+ (void)registerSetPasswordWithPhone:(NSString *)phoneNum password:(NSString *)password invitationCode:(NSString *)invitationCode verfiyCode:(NSString *)verfiyCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:[password md5Encrypt] forKey:@"password"];
    [args setObject:invitationCode forKey:@"invitationCode"];
    [args setObject:verfiyCode forKey:@"vcode"];
    [args setObject:@"5" forKey:@"from"];
    [args setObject:[UserDefaultsHelper sharedManager].deviceToken forKey:@"deviceToken"];
    [args setObject:IDFA forKey:@"ifa"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/user", kServerAddress] args:args success:success failure:failure];
}

+ (void)getRegisterProtocolWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/protocol", kServerAddress] args:nil success:success failure:failure];
}

#pragma mark - Retrieve Password Request Method

+ (void)retrievePasswordSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/reset/phone/sign", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrievePasswordSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:sign forKey:@"forget_sign"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/reset/phone/code", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrievePasswordCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:code forKey:@"code"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/reset/phone", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrieveSetPasswordWithPhone:(NSString *)phoneNum password:(NSString *)password vcode:(NSString *)vcode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:[password md5Encrypt] forKey:@"password"];
    [args setObject:vcode forKey:@"vcode"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/reset/password", kServerAddress] args:args success:success failure:failure];
}

+ (void)refreshTokenWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/refresh/token", kServerAddress] args:nil success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            [[UserDefaultsHelper sharedManager] setUserInfo:dic];
        }
        if (success)
            success(dic, error);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

@end
