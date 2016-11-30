//
//  NSURLRequest+Category.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/24.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "NSURLRequest+Category.h"

@implementation NSURLRequest (Category)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

@end
