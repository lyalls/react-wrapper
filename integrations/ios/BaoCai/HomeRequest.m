//
//  HomeRequest.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/12.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest

+ (void)getBannerRequestWithBannerVersion:(NSString *)bannerVersion success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:0];
    [args setObject:bannerVersion ? bannerVersion : @"" forKey:@"bannerVersion"];
    
    [HTTPRequest send:[NSString stringWithFormat:@"%@top/banners", kServerAddress] args:args success:success failure:failure];
}

+ (void)getSystemNoticeWithSuccess:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@system/notice", kServerAddress] args:nil success:success failure:failure];
}

+ (void)getFloatAdvert:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    [HTTPRequest send:[NSString stringWithFormat:@"%@top/float/advert", kServerAddress] args:nil success:success failure:failure];
}

@end
