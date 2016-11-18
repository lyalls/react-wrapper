//
//  MyPaymentDetailItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPaymentDetailItemModel : NSObject

/**
 *  还款时间
 */
@property (nonatomic, strong) NSString *paymentDate;
/**
 *  应收金额
 */
@property (nonatomic, strong) NSString *paymentAmout;
/**
 *  状态
 */
@property (nonatomic, strong) NSString *state;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
