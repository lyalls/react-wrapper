//
//  MyTransferListItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTransferListItemModel : NSObject

/**
 *
 */
@property (nonatomic, strong) NSString *myTransferListItemId;
/**
 *
 */
@property (nonatomic, strong) NSString *tenderId;
/**
 *  
 */
@property (nonatomic, strong) NSString *name;
/**
 *  投资本金
 */
@property (nonatomic, strong) NSString *investmentAmount;
/**
 *  手续费
 */
@property (nonatomic, strong) NSString *counterFee;
/**
 *  转让价格（转出）
 *  购入金额（转入）
 */
@property (nonatomic, strong) NSString *transferAmount;
/**
 *  转让操作日期（转让中）
 *  转让成功日期（已转出）
 */
@property (nonatomic, strong) NSString *transferTime;
/**
 *  待收本息
 */
@property (nonatomic, strong) NSString *stayPrincipalInterest;
/**
 *  已收本息
 */
@property (nonatomic, strong) NSString *receivingPrincipalInterest;
/**
 *  最新还款日期
 */
@property (nonatomic, strong) NSString *recoverTime;
/**
 *  已还期数
 */
@property (nonatomic, strong) NSString *recoverNum;
/**
 *  共多少期
 */
@property (nonatomic, strong) NSString *borrowPeriod;
/**
 *  结清日期
 */
@property (nonatomic, strong) NSString *repayLastTime;


/**
 *  年利率
 */
@property (nonatomic, strong) NSString *annualRate;
/**
 *  状态
 */
@property (nonatomic, strong) NSString *statusMsg;
/**
 *  借款时间
 */
@property (nonatomic, strong) NSString *borrowDate;
/**
 *  还款方式
 */
@property (nonatomic, strong) NSString *paymentMethod;
/**
 *  应收利息
 */
@property (nonatomic, strong) NSString *tenderInterest;

/**
 *  剩余期数（转让中）
 *  转让时剩余期数（已转出）
 *  购入时剩余期数（转入）
 */
@property (nonatomic, strong) NSString *changePeriod;
/**
 *  交易盈亏
 */
@property (nonatomic, strong) NSString *tradingProfit;
/**
 *  实际到账金额
 */
@property (nonatomic, strong) NSString *arrivalAmount;
/**
 *  债权价格
 */
@property (nonatomic, strong) NSString *creditValue;
/**
 *  购入时待收本金
 */
@property (nonatomic, strong) NSString *changeCapitalWait;
/**
 *  购入时待收利息
 */
@property (nonatomic, strong) NSString *changeInterestWait;
/**
 *  到期时间
 */
@property (nonatomic, strong) NSString *borrowEndTime;

@property (nonatomic, strong) NSMutableArray *paymentDetail;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)reloadData:(NSDictionary *)dic;

@end
