//
//  TicketItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketItemModel : NSObject

/**
 *  红包ID
 */
@property (nonatomic, strong) NSString *ticketId;
/**
 *  红包金额
 */
@property (nonatomic, strong) NSString *money;
/**
 *  红包描述
 */
@property (nonatomic, strong) NSString *ticketDesc;
/**
 *  红包二级描述
 */
@property (nonatomic, strong) NSString *ticketDurationDesc;
/**
 *  过期时间
 */
@property (nonatomic, strong) NSString *expiredTime;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
