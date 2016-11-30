//
//  RechargeModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "RechargeModel.h"

@implementation RechargeModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.approveRealName = [dic boolForKey:@"approveRealName"];
        self.isTrue = [dic boolForKey:@"isTrue"];
        self.isNotFirstRecharge = [dic boolForKey:@"type"];
        self.bankCode = [dic objectForKey:@"bankCode"];
        self.bankName = [dic objectForKey:@"bankName"];
        self.cardNo = [dic objectForKey:@"cardNo"];
        self.noAgree = [dic objectForKey:@"noAgree"];
        self.realname = [dic objectForKey:@"realname"];
        self.cardId = [dic objectForKey:@"cardId"];
        self.payHelp = [dic objectForKey:@"payHelp"];
    }
    return self;
}

@end
