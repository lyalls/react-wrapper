//
//  UserInfoModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

+ (UserInfoModel *)sharedModel;
/**
 *  用户ID
 */
@property (nonatomic, strong) NSString *userId;
/**
 *  用户名
 */
@property (nonatomic, strong) NSString *userName;
/**
 *  用户电话号码
 */
@property (nonatomic, strong) NSString *phone;
/**
 *  用户电子邮箱
 */
@property (nonatomic, strong) NSString *email;
/**
 *  用户登录状态token
 */
@property (nonatomic, strong) NSString *token;
/**
 *  用户是否实名认证
 */
@property (nonatomic, assign) BOOL realNameAuth;
/**
 *  过期时间
 */
@property (nonatomic, strong) NSString *expiredTime;
/**
 *  用户身份证号
 */
@property (nonatomic, strong) NSString *cardID;

/**
 *  是否设置交易密码
 */
@property (nonatomic, assign) BOOL isSetPayPassword;
/**
 *  注册成功提示
 */
@property (nonatomic, strong) NSMutableArray *rewardMsg;

@end
