//
//  MyTenderListItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MyTenderListItemModel.h"
#import "MyPaymentDetailItemModel.h"

@implementation MyTenderListItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.myTenderListItemId = [dic stringForKey:@"id"] ? [dic stringForKey:@"id"] : @"";
        self.tenderId = [dic stringForKey:@"tenderId"] ? [dic stringForKey:@"tenderId"] : @"";
        self.name = [dic stringForKey:@"name"] ? [dic stringForKey:@"name"] : @"";
        self.investmentAmount = [dic stringForKey:@"investmentAmount"] ? [dic stringForKey:@"investmentAmount"] : @"";
        self.annualRate = [dic stringForKey:@"annualRate"] ? [dic stringForKey:@"annualRate"] : @"";
        self.tenderTime = [dic stringForKey:@"tenderTime"] ? [dic stringForKey:@"tenderTime"] : @"";
        self.recoverTime = [dic stringForKey:@"recoverTime"] ? [dic stringForKey:@"recoverTime"] : @"";
        self.borrowPeriod = [dic stringForKey:@"borrowPeriod"] ? [dic stringForKey:@"borrowPeriod"] : @"";
        self.recoverNum = [dic stringForKey:@"recoverNum"] ? [dic stringForKey:@"recoverNum"] : @"";
        self.principalInterest = [dic stringForKey:@"principalInterest"] ? [dic stringForKey:@"principalInterest"] : @"";
        self.receivingPrincipalInterest = [dic stringForKey:@"receivingPrincipalInterest"] ? [dic stringForKey:@"receivingPrincipalInterest"] : @"";
        self.stayPrincipalInterest = [dic stringForKey:@"stayPrincipalInterest"] ? [dic stringForKey:@"stayPrincipalInterest"] : @"";
        self.repayLastTime = [dic stringForKey:@"repayLastTime"] ? [dic stringForKey:@"repayLastTime"] : @"";
    }
    return self;
}

- (void)reloadData:(NSDictionary *)dic {
    self.borrowDate = [dic stringForKey:@"borrowDate"] ? [dic stringForKey:@"borrowDate"] : @"";
    self.paymentMethod = [dic stringForKey:@"paymentMethod"] ? [dic stringForKey:@"paymentMethod"] : @"";
    self.statusMsg = [dic stringForKey:@"statusMsg"];
    self.tenderInterest = [dic stringForKey:@"tenderInterest"];
    
    if ([dic objectForKey:@"paymentDetail"] && [[dic objectForKey:@"paymentDetail"] isKindOfClass:[NSArray class]]) {
        self.paymentDetail = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *item in [dic mutableArrayValueForKey:@"paymentDetail"]) {
            MyPaymentDetailItemModel *detail = [[MyPaymentDetailItemModel alloc] initWithDic:item];
            [self.paymentDetail addObject:detail];
        }
    }
}

@end
