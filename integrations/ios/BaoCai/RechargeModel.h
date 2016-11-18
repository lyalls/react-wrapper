//
//  RechargeModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeModel : NSObject

/**
 *  是否实名认证
 */
@property (nonatomic, assign) BOOL approveRealName;
/**
 *  是否设置交易密码
 */
@property (nonatomic, assign) BOOL isTrue;
/**
 *  是否第一次充值
 */
@property (nonatomic, assign) BOOL isNotFirstRecharge;
/**
 *  银行编号
 */
@property (nonatomic, strong) NSString *bankCode;
/**
 *  银行名称
 */
@property (nonatomic, strong) NSString *bankName;
/**
 *  银行卡号后4位
 */
@property (nonatomic, strong) NSString *cardNo;
/**
 *  协议编号
 */
@property (nonatomic, strong) NSString *noAgree;
/**
 *  真实姓名
 */
@property (nonatomic, strong) NSString *realname;
/**
 *  身份证号
 */
@property (nonatomic, strong) NSString *cardId;
/**
 *  第一次充值说明URL
 */
@property (nonatomic, strong) NSString *payHelp;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
