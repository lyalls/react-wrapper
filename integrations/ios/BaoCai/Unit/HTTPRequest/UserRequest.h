//
//  UserRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/13.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPRequest.h"

@interface UserRequest : NSObject

+ (void)userCheckAuthenticationStatus:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userRealNameAuthenticationWithRealName:(NSString *)realName idCard:(NSString *)idCard success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userBindPhoneNumOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userBindPhoneNumTwoWithPhoneNum:(NSString *)phoneNum sign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userBindPhoneNumCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userModifyPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password rePassword:(NSString *)rePassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userModifyTraderPasswordWithOldPassword:(NSString *)oldPassword password:(NSString *)password rePassword:(NSString *)rePassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)userCheckIdCardWithIdCard:(NSString *)idCard success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrieveTraderPasswordOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrieveTraderPasswordTwoWithPhoneNum:(NSString *)phoneNum sign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrieveTraderPasswordCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrieveTraderPasswordSetPasswordWithPhoneNum:(NSString *)phoneNum withPasswrod:(NSString *)password vcode:(NSString *)vcode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

@end
