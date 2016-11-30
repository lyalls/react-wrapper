//
//  InvestmentRecordModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestmentRecordModel : NSObject

/**
 *  投资人
 */
@property (nonatomic, strong) NSString *tenderer;
/**
 *  投资金额
 */
@property (nonatomic, strong) NSString *investmentAmount;
/**
 *  投资时间
 */
@property (nonatomic, strong) NSString *investmentTime;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
