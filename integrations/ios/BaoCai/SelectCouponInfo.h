//
//  SelectCouponInfo.h
//  BaoCai
//
//  Created by baocai on 16/10/26.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseData.h"

@interface SelectCouponInfo : BaseData

/**
 *  借款期限
 */
@property (nonatomic, assign) NSInteger investmentHorizon;
/**
 *  年利率
 */
@property (nonatomic, strong) NSString *annualRate;
/**
 *  加息利率
 */
@property (nonatomic, strong) NSString *increaseApr;
/**
 *  项目类型
 */
@property (nonatomic, strong) NSString *typeNid;
/**
 *  是否可以使用红包券
 */
@property (nonatomic, assign) BOOL isBonusticket;
/**
 *  是否可以使用加息券
 */
@property (nonatomic, assign) BOOL isAllowIncrease;
/**
 *  是否存在投资额奖励
 */
@property (nonatomic, assign) BOOL isReward;
/**
 *  投资额奖励利率
 */
@property (nonatomic, strong) NSString *rewardRatio;
/**
 *  是否回馈老用户
 */
@property (nonatomic, assign) BOOL isFeedback;
/**
 *  回馈老用户利率列表
 */
@property (nonatomic, strong) NSMutableArray *userFeedBack;

/**
 *  是否首投
 */
@property (nonatomic, assign) BOOL isFirstTender;
/**
 *  加息券列表
 */
@property (nonatomic, strong) NSMutableArray *increaseList;
/**
 *  红包券列表
 */
@property (nonatomic, strong) NSMutableArray *bounsList;
/**
 *  投资金额
 */
@property (nonatomic, assign) NSInteger investCount;
/**
 *  加息券ID
 */
@property (nonatomic, assign) NSInteger increaseId;
/**
 *  红包券ID
 */
@property (nonatomic, assign) NSInteger bonusId;

@end
