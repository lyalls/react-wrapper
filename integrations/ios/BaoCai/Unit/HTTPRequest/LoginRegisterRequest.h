//
//  LoginRegisterRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/11.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"

@interface LoginRegisterRequest : NSObject

#pragma mark - Login Request Method

/**
 *  登录接口
 *
 *  @param username 用户名
 *  @param password 密码
 *  @param success  成功回调方法
 *  @param failure  失败回调方法
 */
+ (void)loginRequestWithUsername:(NSString *)username password:(NSString *)password success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)logoutRequestWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Register Request Method

/**
 *  注册第一次发送短信方法
 *
 *  @param phoneNum 手机号码
 *  @param success  成功回调方法
 *  @param failure  失败回调方法
 */
+ (void)registerSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

/**
 *  注册第二次发送短信方法
 *
 *  @param phoneNum 手机号码
 *  @param sign     回调验签
 *  @param success  成功回调方法
 *  @param failure  失败回调方法
 */
+ (void)registerSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)registerCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

/**
 *  注册设置密码
 *
 *  @param password 密码
 *  @param success  成功回调方法
 *  @param failure  失败回调方法
 */
+ (void)registerSetPasswordWithPhone:(NSString *)phoneNum password:(NSString *)password invitationCode:(NSString *)invitationCode verfiyCode:(NSString *)verfiyCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getRegisterProtocolWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Retrieve Password Request Method

/**
 *  找回密码第一次发送短信方法
 *
 *  @param phoneNum 手机号码
 *  @param success  成功回调方法
 *  @param failure  失败回调方法
 */
+ (void)retrievePasswordSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrievePasswordSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrievePasswordCheckVerfiyCodeWithPhoneNum:(NSString *)phoneNum codeStr:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)retrieveSetPasswordWithPhone:(NSString *)phoneNum password:(NSString *)password vcode:(NSString *)vcode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)refreshTokenWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

@end
