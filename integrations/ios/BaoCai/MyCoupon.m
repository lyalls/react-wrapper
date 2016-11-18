//
//  MyCoupon.m
//  BaoCai
//
//  Created by lishuo on 16/9/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyCoupon.h"

@implementation RaiseRatesCoupon

-(id)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.strId = dic[@"id"];
        self.expiredTime = dic[@"expiredTime"];
        self.startTime = dic[@"starttime"];
        self.useMoney = dic[@"useMoney"];
        self.apr = dic[@"apr"];
        self.AppExpiredTime = dic[@"AppExpiredTime"];
    }
    
    return self;
}


@end


@implementation RedBagCoupon

-(id)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.strId = dic[@"id"];
        self.money = dic[@"money"];
        self.ticketDesc = dic[@"ticketDesc"];
        self.ticketDurationDesc = dic[@"ticketDurationDesc"];
        self.expiredTime = dic[@"expiredTime"];
        self.ticketType = dic[@"ticketType"];
        self.AppExpiredTime = dic[@"AppExpiredTime"];
    }
    
    return self;
}

@end