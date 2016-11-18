//
//  InvestmentRecordModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "InvestmentRecordModel.h"

@implementation InvestmentRecordModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.tenderer = [dic stringForKey:@"tenderer"];
        self.investmentAmount = [dic stringForKey:@"investmentAmount"];
        self.investmentTime = [dic stringForKey:@"investmentTime"];
    }
    return self;
}

@end
