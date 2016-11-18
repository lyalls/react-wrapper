//
//  TenderItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenderItemModel : NSObject

/**
 *  标的ID
 */
@property (nonatomic, strong) NSString *tenderId;
/**
 *  标的名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  借款期限
 */
@property (nonatomic, strong) NSString *investmentHorizon;
/**
 *  年利率
 */
@property (nonatomic, strong) NSString *annualRate;
/**
 *  加息利率
 */
@property (nonatomic, strong) NSString *increaseApr;
/**
 *  投资进度
 */
@property (nonatomic, strong) NSString *tenderSchedule;
/**
 *  项目类型
 */
@property (nonatomic, strong) NSString *typeNid;
/**
 *  项目状态
 */
@property (nonatomic, strong) NSString *statusMessage;
/**
 *  标的类型图片
 */
@property (nonatomic, strong) NSString *tenderTypeImageUrl;
/**
 *  标的类型边框颜色RGB形式
 */
@property (nonatomic, strong) NSString *tenderTypeBorderColor;
/**
 *  标的Tip列表
 */
@property (nonatomic, strong) NSMutableArray *tenderTipsList;

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
 *  投资额奖励内容
 */
@property (nonatomic, strong) NSString *promotionTitle;
/**
 *  是否存在标签
 */
@property (nonatomic, assign) BOOL isTag;
/**
 *  标签内容
 */
@property (nonatomic, strong) NSString *tagTitle;
/**
 *  是否是限量标
 */
@property (nonatomic, assign) BOOL isLimit;
/**
 *  开标剩余时间
 */
@property (nonatomic, strong) NSString *limitTime;
/**
 *  开标剩余时间－请求时间
 */
@property (nonatomic, assign) NSInteger limitTimeInterval;
/**
 *  是否存在满标奖
 */
@property (nonatomic, assign) BOOL isFull;
/**
 *  是否达到满标奖阀值
 */
@property (nonatomic, assign) BOOL isFullThreshold;

/**
 *  借款金额
 */
@property (nonatomic, strong) NSString *borrowAmount;
/**
 *  投资人次
 */
@property (nonatomic, strong) NSString *investPersonNum;

/**
 *  保障方式
 */
@property (nonatomic, strong) NSString *safeguardWay;
/**
 *  还款方式
 */
@property (nonatomic, strong) NSString *paymentMethod;
/**
 *  投资剩余时间
 */
@property (nonatomic, strong) NSString *remainTime;
/**
 *  投资剩余时间－请求时间
 */
@property (nonatomic, assign) NSInteger remainTimeInterval;
/**
 *  可投金额
 */
@property (nonatomic, strong) NSString *availableAmount;
/**
 *  起投金额
 */
@property (nonatomic, strong) NSString *tenderMin;
/**
 *  最大限额
 */
@property (nonatomic, strong) NSString *tenderMax;
/**
 *  投资金额
 */
@property (nonatomic, strong) NSString *tenderAccount;
/**
 *  预计收益
 */
@property (nonatomic, strong) NSString *anticipatedIncome;
/**
 *  标的类型，0：普通1：新手 2：专享
 */
@property (nonatomic, strong) NSString *borrowType;
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
 *  项目详情，Title,URL
 */
@property (nonatomic, strong) NSMutableArray *detailList;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)reloadData:(NSDictionary *)dic;

@end
