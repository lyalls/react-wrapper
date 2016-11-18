//
//  MyPageDataModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/18.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyPageDataModel.h"

@implementation MyPageDataModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.netAssets = [dic objectForKey:@"netAssets"];
        self.availableBalance = [dic objectForKey:@"availableBalance"];
        self.futureRevenue = [dic objectForKey:@"futureRevenue"];
        self.tenderCount = [dic objectForKey:@"tenderCount"];
        self.transferAssetsCount = [dic objectForKey:@"transferAssetsCount"];
        self.inceaseTicketCount = [dic objectForKey:@"inceaseTicketCount"];
        self.ticketCount = [dic objectForKey:@"ticketCount"];
        self.invitationDesc = [dic objectForKey:@"invitationDesc"];
    }
    return self;
}

@end
