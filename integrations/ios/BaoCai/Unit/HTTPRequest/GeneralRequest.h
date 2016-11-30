//
//  GeneralRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPRequest.h"

@interface GeneralRequest : NSObject

+ (void)getBankAreaListWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getActivityWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getUnReadMessageWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)checkVersionWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)sendIDFA;

+(void)getSloganRequestWithVersion:(NSString*)sloganVersion success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
@end
