//
//  MessageItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MessageItemModel.h"

@implementation MessageItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.messageId = [dic objectForKey:@"messageId"];
        self.messageTitle = [dic objectForKey:@"messageTitle"];
        self.messageDate = [dic objectForKey:@"messageDate"];
        self.messageStatus = [dic stringForKey:@"status"];
    }
    return self;
}

- (void)reloadData:(NSDictionary *)dic {
    self.messageContent = [dic objectForKey:@"messageContent"];
}

@end
