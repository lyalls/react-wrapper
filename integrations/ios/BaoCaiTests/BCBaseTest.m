//
//  BCBaseTest.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/15.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBaseTest.h"

#import "UserDefaultsHelper.h"

#import "LoginRegisterRequest.h"

@implementation BCBaseTest

- (void)loginTest:(void (^)(BOOL isSuccess))block {
    [LoginRegisterRequest loginRequestWithUsername:@"sx186" password:@"123456a" success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            [[UserDefaultsHelper sharedManager] setUserInfo:dic];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block(NO);
    }];
}

@end
