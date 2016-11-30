//
//  MyRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/18.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MyRequest.h"

@implementation MyRequest

+ (void)getMyPageDataWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getWithdrawalsStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getWithdrawalsBankCardWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/bank", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getWithdrawalsSendMessageOneWithPhoneNum:(NSString *)phoneNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/sign", kServerAddress] args:args success:success failure:failure];
}

+ (void)getWithdrawalsSendMessageTwoWithPhoneNum:(NSString *)phoneNum withSign:(NSString *)sign success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:phoneNum forKey:@"phone"];
    [args setObject:sign forKey:@"present_sign"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/code", kServerAddress] args:args success:success failure:failure];
}

+ (void)withdrawalsCheckPasswordWithVerfiyCode:(NSString *)code cashMoney:(NSString *)cashMoney payPassword:(NSString *)payPassword success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:code forKey:@"cashCode"];
    [args setObject:cashMoney forKey:@"cashMoney"];
    [args setObject:[payPassword md5Encrypt] forKey:@"paypassword"];
    [args setObject:@"3" forKey:@"from"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/order", kServerAddress] args:args success:success failure:failure];
}

+ (void)withdrawalsBindBankCardWithCardNum:(NSString *)cardNum bankId:(NSString *)bankId address:(NSString *)address provinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:cardNum forKey:@"account"];
    [args setObject:bankId forKey:@"bank"];
    [args setObject:address forKey:@"branch"];
    [args setObject:provinceId forKey:@"province"];
    [args setObject:cityId forKey:@"city"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/add", kServerAddress] args:args success:success failure:failure];
}

+ (void)withdrawalsSupplyBankCardWithAddress:(NSString *)address provinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:address forKey:@"branch"];
    [args setObject:provinceId forKey:@"province"];
    [args setObject:cityId forKey:@"city"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/update", kServerAddress] args:args success:success failure:failure];
}

+ (void)getWithdrawalsRecodeWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/logs", kServerAddress] args:args success:success failure:failure];
}

+ (void)getWithdrawalsRealNameWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/info", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getCompletBankCardInfoWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/present/account", kServerAddress] args:nil success:success failure:failure];
}

#pragma mark - Recharge method

+ (void)getRechargeStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@payment/lianlianpay/page", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getRechargeBankListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@payment/lianlianpay/banks", kServerAddress] args:nil success:success failure:failure];
}

+ (void)checkRechargeBankCardNumWithCardNum:(NSString *)cardNum success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:cardNum forKey:@"cardNumber"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@payment/lianlianpay/cardbin", kServerAddress] args:args success:success failure:failure];
}

+ (void)rechargeWithAmount:(NSString *)amount withCardNum:(NSString *)cardNum withNoAgree:(NSString *)noAgree success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:amount forKey:@"amount"];
    if (noAgree && noAgree.length != 0) {
        [args setObject:noAgree forKey:@"noAgree"];
    } else {
        [args setObject:cardNum forKey:@"bankAccount"];
    }
    [args setObject:@"3" forKey:@"from"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@payment/lianlianpay/order", kServerAddress] args:args success:success failure:failure];
}

+ (void)rechargeSyncWithLianLianDic:(NSDictionary *)dic success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@payment/lianlianpay/sync", [kServerAddress stringByReplacingOccurrencesOfString:@"v2/" withString:@""]] args:dic success:success failure:failure];
}

+ (void)getRechargeRecodeWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/payment/logs", kServerAddress] args:args success:success failure:failure];
}

#pragma mark - Message method

+ (void)getMessageListWithMessageListType:(MessageListType)type pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSString *typeStr = @"unread";
    if (type == MessageListTypeRead) {
        typeStr = @"read";
    }
    else if(type == MessageListTypeAll)
    {
        typeStr = @"list";
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/messages/%@", kServerAddress, typeStr] args:args success:success failure:failure];
}
+(void)setMessageListTypeAllReadWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/messages/readed/set", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getMessageDetailWithMessageId:(NSString *)messageId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/messages/%@", kServerAddress, messageId] args:nil success:success failure:failure];
}

#pragma mark - Ticket method

+ (void)getTicketListWithTicketType:(TicketListType)type pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSString *typeStr = @"";
    switch (type) {
        case TicketListTypeUnused: {
            typeStr = @"nouse";
            break;
        }
        case TicketListTypeUsed: {
            typeStr = @"use";
            break;
        }
        case TicketListTypeExpire: {
            typeStr = @"expired";
            break;
        }
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    [args setObject:typeStr forKey:@"type"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/bonus/ticket", kServerAddress] args:args success:success failure:failure];
}

+ (void)exchangeTicketWithCode:(NSString *)code success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:code forKey:@"exchangeCode"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/bonus/ticket/exchange", kServerAddress] args:args success:success failure:failure];
}

#pragma mark - Invite friends method

+ (void)getInviteFriendsDataWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@activity/invite/info", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getInviteFriendsListDataWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/invite/log", kServerAddress] args:args success:success failure:failure];
}

#pragma mark - Tender method

+ (void)getMyTenderListWithTenderType:(MyTenderItemTableViewCellType)tenderItemType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSString *typeStr = @"";
    switch (tenderItemType) {
        case MyTenderItemTableViewCellTypeRecovery: {
            typeStr = @"roamNo";
            break;
        }
        case MyTenderItemTableViewCellTypeTender: {
            typeStr = @"loan";
            break;
        }
        case MyTenderItemTableViewCellTypeAlreadyRecovery: {
            typeStr = @"roamYes";
            break;
        }
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/invests/%@", kServerAddress, typeStr] args:args success:success failure:failure];
}

+ (void)getMyTenderDetailWithTenderId:(NSString *)tenderId withBorrowId:(NSString *)borrowId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure{
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/borrow/%@/%@", kServerAddress, borrowId, tenderId] args:nil success:success failure:failure];
}

#pragma mark - Transfer turn out method

+ (void)getMyTransferListWithTenderType:(MyTransferItemTableViewCellType)transferItemType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSString *typeStr = @"";
    switch (transferItemType) {
        case MyTransferItemTableViewCellTypeTransfer: {
            typeStr = @"changing";
            break;
        }
        case MyTransferItemTableViewCellTypeTurnOut: {
            typeStr = @"changYes";
            break;
        }
        case MyTransferItemTableViewCellTypeRecovery: {
            typeStr = @"changRecoverWait";
            break;
        }
        case MyTransferItemTableViewCellTypeAlreadyRecovery: {
            typeStr = @"changRecoverYes";
            break;
        }
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/transfer/%@", kServerAddress, typeStr] args:args success:success failure:failure];
}

+ (void)getMyTransferDetailWithTenderId:(NSString *)transferId borrowId:(NSString *)borrowId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@users/transfer/%@/%@", kServerAddress, borrowId, transferId] args:nil success:success failure:failure];
}

+ (void)getMySettingShareWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@activity/invite/share", kServerAddress] args:nil success:success failure:failure];
}
+(void)getCouponListWithType:(CouponType)couponType andTicketListType:(TicketListType)ticketListType pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure
{
    NSString *urlStr = @"users/increase/ticket";
    
    switch (couponType) {
        case RaiseInterestRatesCoupon:
            urlStr = @"users/increase/ticket";
            break;
        case RedPacketCoupon:
            urlStr = @"users/bonus/ticket";
            break;
        default:
            break;
    }
    
    NSString *typeStr = @"";
    switch (ticketListType) {
        case TicketListTypeUnused: {
            typeStr = @"nouse";
            break;
        }
        case TicketListTypeUsed: {
            typeStr = @"use";
            break;
        }
        case TicketListTypeExpire: {
            typeStr = @"expired";
            break;
        }
    }
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:@(PageMaxCount) forKey:@"pageSize"];
    [args setObject:@(pageIndex) forKey:@"pageIndex"];
    [args setObject:typeStr forKey:@"type"];
    [HTTPRequest send:[NSString stringWithFormat:@"%@%@", kServerAddress,urlStr] args:args success:success failure:failure];
}
@end
