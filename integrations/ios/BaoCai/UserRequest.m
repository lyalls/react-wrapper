//
//  UserRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/13.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

+ (void)userCheckAuthenticationStatus:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/approve/user/state", kServerAddress] args:nil success:success failure:failure];
}

+ (void)userRealNameAuthenticationWithRealName:(NSString *)realName idCard:(NSString *)idCard success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:realName forKey:@"realName"];
    [args setObject:idCard forKey:@"IDCard"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/register/id", kServerAddress] args:args success:success failure:failure];
}

+ (void)userBindPhoneNumOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/approve/phone/sign", kServerAddress] args:args success:success failure:failure];
}

+ (void)userBindPhoneNumTwoWithPhoneNum:(NSString *)phoneNum sign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:sign forKey:@"bind_sign"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/approve/phone/code", kServerAddress] args:args success:success failure:failure];
}

+ (void)userBindPhoneNumCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:code forKey:@"code"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@auth/approve/phone", kServerAddress] args:args success:success failure:failure];
}

+ (void)userModifyPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password rePassword:(NSString *)rePassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:[oldPassword md5Encrypt] forKey:@"password"];
    [args setObject:[password md5Encrypt] forKey:@"newPwd"];
    [args setObject:[rePassword md5Encrypt] forKey:@"repeatPwd"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/password/modify", kServerAddress] args:args success:success failure:failure];
}

+ (void)userModifyTraderPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password rePassword:(NSString *)rePassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:[oldPassword md5Encrypt] forKey:@"payPassword"];
    [args setObject:[password md5Encrypt] forKey:@"newPaypwd"];
    [args setObject:[rePassword md5Encrypt] forKey:@"repeatPaypwd"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/paypassword/modify", kServerAddress] args:args success:success failure:failure];
}

+ (void)userCheckIdCardWithIdCard:(NSString *)idCard success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:idCard forKey:@"cardID"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/reset/card", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrieveTraderPasswordOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/reset/phone/sign", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrieveTraderPasswordTwoWithPhoneNum:(NSString *)phoneNum sign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:sign forKey:@"reset_sign"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/reset/phone/code", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrieveTraderPasswordCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:code forKey:@"code"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/reset/phone", kServerAddress] args:args success:success failure:failure];
}

+ (void)retrieveTraderPasswordSetPasswordWithPhoneNum:(NSString *)phoneNum withPasswrod:(NSString *)password vcode:(NSString *)vcode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:[password md5Encrypt] forKey:@"paypassword"];
    [args setObject:vcode forKey:@"vcode"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/reset/paypassword", kServerAddress] args:args success:success failure:failure];
}

@end
