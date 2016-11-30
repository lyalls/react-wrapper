//
//  TenderItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "TenderItemModel.h"

@implementation TenderItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.tenderId = [dic stringForKey:@"id"];
        self.name = [dic stringForKey:@"name"];
        self.investmentHorizon = [dic stringForKey:@"investmentHorizon"];
        self.annualRate = [dic stringForKey:@"annualRate"];
        self.increaseApr = [dic stringForKey:@"increaseApr"];
        self.tenderSchedule = [dic stringForKey:@"tenderSchedule"];
        self.typeNid = [dic stringForKey:@"typeNid"];
        self.statusMessage = [dic stringForKey:@"statusMessage"];
        self.tenderTypeImageUrl = [dic stringForKey:@"tenderTypeImageUrl"];
        self.tenderTypeBorderColor = [dic stringForKey:@"tenderTypeBorderColor"];
        self.tenderTipsList = [dic mutableArrayValueForKey:@"tenderTipsList"];
        
        self.isBonusticket = [dic boolForKey:@"isBonusticket"];
        self.isAllowIncrease = [dic boolForKey:@"isAllowIncrease"];
        self.isReward = [dic boolForKey:@"isReward"];
        self.promotionTitle = [dic stringForKey:@"promotionTitle"];
        self.isTag = [dic boolForKey:@"isTag"];
        self.tagTitle = [dic stringForKey:@"tagTitle"];
        self.isLimit = [dic boolForKey:@"isLimit"];
        self.limitTime = [dic stringForKey:@"limitTime"];
        self.limitTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
        self.isFull = [dic boolForKey:@"isFull"];
        self.isFullThreshold = [dic boolForKey:@"isFullThreshold"];
        
        self.borrowAmount = [dic stringForKey:@"borrowAmount"];
        self.investPersonNum = [dic stringForKey:@"investPersonNum"];
    }
    return self;
}

- (void)reloadData:(NSDictionary *)dic {
    self.safeguardWay = [dic stringForKey:@"safeguardWay"];
    self.paymentMethod = [dic stringForKey:@"paymentMethod"];
    self.remainTime = [dic stringForKey:@"remainTime"];
    self.remainTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
    self.availableAmount = [dic stringForKey:@"availableAmount"];
    self.tenderMin = [dic stringForKey:@"tenderAccountMin"];
    self.tenderMax = [dic stringForKey:@"tenderAccountMax"];
    self.tenderAccount = [dic stringForKey:@"tenderAccount"];
    self.anticipatedIncome = [dic stringForKey:@"anticipatedIncome"];
    self.borrowType = [dic stringForKey:@"borrowType"];
    
    self.detailList = [dic mutableArrayValueForKey:@"detailList"];
}

@end
