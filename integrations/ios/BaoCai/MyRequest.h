//
//  MyRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/18.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPRequest.h"

typedef NS_ENUM(NSInteger, MessageListType) {
    MessageListTypeUnRead,
    MessageListTypeRead,
    MessageListTypeAll
};

typedef NS_ENUM(NSInteger, TicketListType) {
    TicketListTypeUnused,
    TicketListTypeUsed,
    TicketListTypeExpire
};

typedef NS_ENUM(NSInteger, MyTenderItemTableViewCellType) {
    MyTenderItemTableViewCellTypeRecovery,
    MyTenderItemTableViewCellTypeTender,
    MyTenderItemTableViewCellTypeAlreadyRecovery
};

typedef NS_ENUM(NSInteger, MyTransferItemTableViewCellType) {
    MyTransferItemTableViewCellTypeTransfer,
    MyTransferItemTableViewCellTypeTurnOut,
    MyTransferItemTableViewCellTypeRecovery,
    MyTransferItemTableViewCellTypeAlreadyRecovery
};
typedef NS_ENUM(NSInteger, CouponType) {
    RaiseInterestRatesCoupon,//加息券
    RedPacketCoupon //红包券
};


@interface MyRequest : NSObject

+ (void)getMyPageDataWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - withdrawals method

+ (void)getWithdrawalsStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getWithdrawalsBankCardWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getWithdrawalsSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getWithdrawalsSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)withdrawalsCheckPasswordWithVerfiyCode:(NSString *)code cashMoney:(NSString *)cashMoney payPassword:(NSString *)payPassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)withdrawalsBindBankCardWithCardNum:(NSString *)cardNum bankId:(NSString *)bankId address:(NSString *)address provinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)withdrawalsSupplyBankCardWithAddress:(NSString *)address provinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getWithdrawalsRecodeWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getWithdrawalsRealNameWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getCompletBankCardInfoWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Recharge method

+ (void)getRechargeStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getRechargeBankListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)checkRechargeBankCardNumWithCardNum:(NSString *)cardNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)rechargeWithAmount:(NSString *)amount withCardNum:(NSString *)cardNum withNoAgree:(NSString *)noAgree success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)rechargeSyncWithLianLianDic:(NSDictionary *)dic success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getRechargeRecodeWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Message method

+ (void)getMessageListWithMessageListType:(MessageListType)type pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
+(void)setMessageListTypeAllReadWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
+ (void)getMessageDetailWithMessageId:(NSString *)messageId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Ticket method

+ (void)getTicketListWithTicketType:(TicketListType)type pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)exchangeTicketWithCode:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Invite friends method

+ (void)getInviteFriendsDataWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getInviteFriendsListDataWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Tender method

+ (void)getMyTenderListWithTenderType:(MyTenderItemTableViewCellType)tenderItemType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getMyTenderDetailWithTenderId:(NSString *)tenderId withBorrowId:(NSString *)borrowId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

#pragma mark - Transfer turn out method

+ (void)getMyTransferListWithTenderType:(MyTransferItemTableViewCellType)transferItemType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getMyTransferDetailWithTenderId:(NSString *)transferId borrowId:(NSString *)borrowId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getMySettingShareWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+(void)getCouponListWithType:(CouponType)couponType andTicketListType:(TicketListType)ticketListType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
@end
