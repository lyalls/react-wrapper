//
//  TicketItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "TicketItemModel.h"

@implementation TicketItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.ticketId = [dic stringForKey:@"ticketId"];
        self.money = [dic stringForKey:@"money"];
        self.ticketDesc = [dic stringForKey:@"ticketDesc"];
        self.ticketDurationDesc = [dic stringForKey:@"ticketDurationDesc"];
        self.expiredTime = [dic stringForKey:@"expiredTime"];
    }
    return self;
}

@end
