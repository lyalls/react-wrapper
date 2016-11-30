//
//  HomeRequest.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPRequest.h"

@interface HomeRequest : NSObject

+ (void)getBannerRequestWithBannerVersion:(NSString *)bannerVersion success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getSystemNoticeWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+ (void)getFloatAdvert:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

@end
