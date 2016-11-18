//
//  InviteFriendsModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendsModel : NSObject

/**
 *  已获总奖励
 */
@property (nonatomic, strong) NSString *receiveTotalReward;
/**
 *  待收邀请奖励
 */
@property (nonatomic, strong) NSString *waitTotalReward;
/**
 *  邀请码
 */
@property (nonatomic, strong) NSString *invitationCode;
/**
 *  分享标题
 */
@property (nonatomic, strong) NSString *invitationTitle;
/**
 *  邀请链接
 */
@property (nonatomic, strong) NSString *invitationUrl;
/**
 *  邀请描述
 */
@property (nonatomic, strong) NSString *invitationDesc;
/**
 *  邀请规则url
 */
@property (nonatomic, strong) NSString *invitationRuleUrl;
/**
 *  分享图片url
 */
@property (nonatomic, strong) NSString *invitationImageUrl;
/**
 *  邀请列表
 */
@property (nonatomic, strong) NSMutableArray *invitationRecordList;

- (void)reloadInviteFriendsData:(NSDictionary *)dic;

- (void)reloadInviteFriendsList:(NSMutableArray *)array;

@end

@interface InviteFriendsListItemModel : NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *regTime;
@property (nonatomic, strong) NSString *waitTotalReward;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
