//
//  HomeRequestTest.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/15.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBaseTest.h"

#import "HomeRequest.h"

@interface HomeRequestTest : BCBaseTest

@end

@implementation HomeRequestTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetBanner {
    [HomeRequest getBannerRequestWithBannerVersion:@"" success:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NOTIFY;
    } failure:^(NSError *error) {
        XCTFail(@"");
        
        NOTIFY;
    }];
    WAIT;
}

- (void)testGetSystemNotice {
    [HomeRequest getSystemNoticeWithSuccess:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NOTIFY;
    } failure:^(NSError *error) {
        XCTFail(@"");
        
        NOTIFY;
    }];
    WAIT;
}

- (void)testGetFloatAdvert {
    [HomeRequest getFloatAdvert:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NOTIFY;
    } failure:^(NSError *error) {
        XCTFail(@"");
        
        NOTIFY;
    }];
    WAIT;
}

@end
