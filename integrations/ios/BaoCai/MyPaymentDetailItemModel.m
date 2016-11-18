//
//  MyPaymentDetailItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyPaymentDetailItemModel.h"

@implementation MyPaymentDetailItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.paymentDate = [dic stringForKey:@"paymentDate"];
        self.paymentAmout = [dic stringForKey:@"paymentAmout"];
        self.state = [dic stringForKey:@"state"];
    }
    return self;
}

@end
