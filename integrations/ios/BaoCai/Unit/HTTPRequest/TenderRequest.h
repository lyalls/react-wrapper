//
//  TenderRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPRequest.h"

@interface TenderRequest : NSObject

+ (void)getHomeTenderListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderListWithPageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderDetailWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderRecordListWithTenderId:(NSString *)tenderId pageIndex:(NSInteger)pageIndex success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderAvailableAmountAndBalanceWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderCalculatorWithTenderId:(NSString *)tenderId borrowAmount:(NSString *)borrowAmount bonusId:(NSNumber*)bonusId increaseId:(NSNumber*)increaseId
                                success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderUserStatusWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getTenderProtocolWithTenderId:(NSString *)tenderId success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)payTenderWithTenderId:(NSString *)tenderId borrowAmount:(NSString *)borrowAmount bonusId:(NSNumber*)bonusId increaseId:(NSNumber*)increaseId payPassword:(NSString *)payPassword paySecond:(BOOL)paySecond activityCode:(NSString *)activityCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getUserIsNoviceWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)checkTenderActivityCodeWithTenderId:(NSString *)tenderId withActiveCode:(NSString *)activeCode success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

//获取红包列表
+(void) getBonusList:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
//获取加息列表
+(void) getIncreaseList:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

@end
