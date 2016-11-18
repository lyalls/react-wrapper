//
//  MyPageDataModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/18.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPageDataModel : NSObject

/**
 *  净资产
 */
@property (nonatomic, strong) NSString *netAssets;
/**
 *  可用金额
 */
@property (nonatomic, strong) NSString *availableBalance;
/**
 *  待收本息
 */
@property (nonatomic, strong) NSString *futureRevenue;
/**
 *  散标投资数量
 */
@property (nonatomic, strong) NSString *tenderCount;
/**
 *  债权转让数量
 */
@property (nonatomic, strong) NSString *transferAssetsCount;
/**
 *  加息券数量
 */
@property (nonatomic, strong) NSString *inceaseTicketCount;
/**
 *  红包券数量
 */
@property (nonatomic, strong) NSString *ticketCount;
/**
 *  邀请好友描述
 */
@property (nonatomic, strong) NSString *invitationDesc;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
