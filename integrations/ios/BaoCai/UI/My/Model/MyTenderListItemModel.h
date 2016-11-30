//
//  MyTenderListItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTenderListItemModel : NSObject

/**
 *  散标ID
 */
@property (nonatomic, strong) NSString *myTenderListItemId;
/**
 *  标的ID
 */
@property (nonatomic, strong) NSString *tenderId;
/**
 *  散标名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  投资金额
 */
@property (nonatomic, strong) NSString *investmentAmount;
/**
 *  年利率
 */
@property (nonatomic, strong) NSString *annualRate;
/**
 *  投标日期
 */
@property (nonatomic, strong) NSString *tenderTime;
/**
 *  收款日期
 */
@property (nonatomic, strong) NSString *recoverTime;
/**
 *  总期数
 */
@property (nonatomic, strong) NSString *borrowPeriod;
/**
 *  当前期数
 */
@property (nonatomic, strong) NSString *recoverNum;
/**
 *  应收本息
 */
@property (nonatomic, strong) NSString *principalInterest;
/**
 *  已收本息
 */
@property (nonatomic, strong) NSString *receivingPrincipalInterest;
/**
 *  待收本息
 */
@property (nonatomic, strong) NSString *stayPrincipalInterest;
/**
 *  借款时间
 */
@property (nonatomic, strong) NSString *borrowDate;
/**
 *  还款方式
 */
@property (nonatomic, strong) NSString *paymentMethod;
/**
 *  收款详情
 */
@property (nonatomic, strong) NSMutableArray *paymentDetail;
/**
 *  状态
 */
@property (nonatomic, strong) NSString *statusMsg;
/**
 *  结清日期
 */
@property (nonatomic, strong) NSString *repayLastTime;
/**
 *  应收利息
 */
@property (nonatomic, strong) NSString *tenderInterest;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)reloadData:(NSDictionary *)dic;

@end
