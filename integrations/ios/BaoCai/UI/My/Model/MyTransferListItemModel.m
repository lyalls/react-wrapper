//
//  MyTransferListItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MyTransferListItemModel.h"
#import "MyPaymentDetailItemModel.h"

@implementation MyTransferListItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.myTransferListItemId = [dic stringForKey:@"id"];
        self.tenderId = [dic stringForKey:@"tenderId"];
        self.name = [dic stringForKey:@"name"];
        self.investmentAmount = [dic stringForKey:@"investmentAmount"];
        self.counterFee = [dic stringForKey:@"counterFee"];
        self.transferAmount = [dic stringForKey:@"transferAmount"];
        self.transferTime = [dic stringForKey:@"transferTime"];
        self.stayPrincipalInterest = [dic stringForKey:@"stayPrincipalInterest"];
        self.receivingPrincipalInterest = [dic stringForKey:@"receivingPrincipalInterest"];
        self.recoverTime = [dic stringForKey:@"recoverTime"];
        self.recoverNum = [dic stringForKey:@"recoverNum"];
        self.borrowPeriod = [dic stringForKey:@"borrow_period"];
        self.repayLastTime = [dic stringForKey:@"repayLastTime"];
    }
    return self;
}

- (void)reloadData:(NSDictionary *)dic {
    self.annualRate = [dic stringForKey:@"annualRate"];
    self.statusMsg = [dic stringForKey:@"statusMsg"];
    self.borrowDate = [dic stringForKey:@"borrowDate"];
    self.paymentMethod = [dic stringForKey:@"paymentMethod"];
    self.tenderInterest = [dic stringForKey:@"tenderInterest"];
    
    self.changePeriod = [dic stringForKey:@"changePeriod"];
    self.tradingProfit = [dic stringForKey:@"tradingProfit"];
    self.arrivalAmount = [dic stringForKey:@"arrivalAmount"];
    self.creditValue = [dic stringForKey:@"creditValue"];
    self.changeCapitalWait = [dic stringForKey:@"changeCapitalWait"];
    self.changeInterestWait = [dic stringForKey:@"changeInterestWait"];
    self.borrowEndTime = [dic stringForKey:@"borrowEndTime"];
    
    if ([dic objectForKey:@"paymentDetail"] && [[dic objectForKey:@"paymentDetail"] isKindOfClass:[NSArray class]]) {
        self.paymentDetail = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *item in [dic mutableArrayValueForKey:@"paymentDetail"]) {
            MyPaymentDetailItemModel *detail = [[MyPaymentDetailItemModel alloc] initWithDic:item];
            [self.paymentDetail addObject:detail];
        }
    }
}

@end
