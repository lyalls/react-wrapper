//
//  HTTPRequest.h
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/3/12.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BCError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

typedef void (^HTTPRequestCompletionBlock)(NSDictionary *dic, BCError *error);
typedef void (^HTTPRequestErrorBlock)(NSError *error);

@interface HTTPRequest : NSObject

+ (void)send:(NSString *)url args:(NSDictionary *)args success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;

+(void) updateWebSite:(NSString*)path version:(NSString*)version success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure;
@end
