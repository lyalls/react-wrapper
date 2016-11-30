//
//  InviteFriendsModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "InviteFriendsModel.h"

@implementation InviteFriendsModel

- (void)reloadInviteFriendsData:(NSDictionary *)dic {
    self.receiveTotalReward = [dic objectForKey:@"receiveTotalReward"];
    self.waitTotalReward = [dic objectForKey:@"waitTotalReward"];
    self.invitationCode = [dic objectForKey:@"invitationCode"];
    self.invitationUrl = [dic objectForKey:@"invitationUrl"];
    self.invitationDesc = [dic objectForKey:@"invitationDesc"];
    self.invitationRuleUrl = [dic objectForKey:@"invitationRuleUrl"];
    self.invitationTitle = [dic objectForKey:@"invitationTitle"];
    self.invitationImageUrl = [dic objectForKey:@"invitationImageUrl"];
}

- (void)reloadInviteFriendsList:(NSMutableArray *)array {
    self.invitationRecordList = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in array) {
        InviteFriendsListItemModel *item = [[InviteFriendsListItemModel alloc] initWithDic:dic];
        [self.invitationRecordList addObject:item];
    }
}

@end

@implementation InviteFriendsListItemModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.phone = [dic objectForKey:@"phone"];
        self.regTime = [dic objectForKey:@"regTime"];
        self.waitTotalReward = [dic objectForKey:@"waitTotalReward"];
    }
    return self;
}

@end
