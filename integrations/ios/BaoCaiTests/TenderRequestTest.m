//
//  TenderRequestTest.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/14.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBaseTest.h"

#import "UserInfoModel.h"
#import "UserDefaultsHelper.h"

#import "LoginRegisterRequest.h"
#import "TenderRequest.h"

#import "TenderItemModel.h"

@interface TenderRequestTest : BCBaseTest

@end

@implementation TenderRequestTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetHomeTenderList {
    [TenderRequest getHomeTenderListWithSuccess:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NOTIFY;
    } failure:^(NSError *error) {
        XCTFail();
        NOTIFY
    }];
    WAIT;
}

- (void)testGetTenderList {
    [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NSArray *array = [dic objectForKey:@"tenderList"];
        assertNotNil(array);
        assertTrue(array.count > 0);
        
        NOTIFY;
    } failure:^(NSError *error) {
        XCTFail();
        
        NOTIFY;
    }];
    WAIT;
}

- (void)testGetTenderDetail {
    [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NSArray *array = [dic objectForKey:@"tenderList"];
        assertNotNil(array);
        assertTrue(array.count > 0);
        
        TenderItemModel *model = [[TenderItemModel alloc] initWithDic:[array objectAtIndex:0]];
        
        [TenderRequest getTenderDetailWithTenderId:model.tenderId success:^(NSDictionary *dic, BCError *error) {
            assertNotNil(dic);
            assertEqual(error.code, 0);
            
            NOTIFY;
        } failure:^(NSError *error) {
            XCTFail();
            
            NOTIFY;
        }];
    } failure:^(NSError *error) {
        XCTFail();
        
        NOTIFY;
    }];
    WAIT;
}

- (void)testGetTenderRecord {
    [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
        assertNotNil(dic);
        assertEqual(error.code, 0);
        
        NSArray *array = [dic objectForKey:@"tenderList"];
        assertNotNil(array);
        assertTrue(array.count > 0);
        
        TenderItemModel *model = [[TenderItemModel alloc] initWithDic:[array objectAtIndex:0]];
        
        [TenderRequest getTenderRecordListWithTenderId:model.tenderId pageIndex:1 success:^(NSDictionary *dic, BCError *error) {
            assertNotNil(dic);
            assertEqual(error.code, 0);
            
            NOTIFY;
        } failure:^(NSError *error) {
            XCTFail();
            
            NOTIFY;
        }];
    } failure:^(NSError *error) {
        XCTFail();
        
        NOTIFY;
    }];
    WAIT;
}

- (void)testGetTenderAvailableAmountAndBalance {
    [self loginTest:^(BOOL isSuccess) {
        if (isSuccess) {
            [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
                assertNotNil(dic);
                assertEqual(error.code, 0);
                
                NSArray *array = [dic objectForKey:@"tenderList"];
                assertNotNil(array);
                assertTrue(array.count > 1);
                
                TenderItemModel *model = [[TenderItemModel alloc] initWithDic:[array objectAtIndex:1]];
                
                [TenderRequest getTenderAvailableAmountAndBalanceWithTenderId:model.tenderId success:^(NSDictionary *dic, BCError *error) {
                    assertNotNil(dic);
                    assertEqual(error.code, 0);
                    
                    NOTIFY;
                } failure:^(NSError *error) {
                    XCTFail();
                    
                    NOTIFY;
                }];
            } failure:^(NSError *error) {
                XCTFail();
                
                NOTIFY;
            }];
        } else {
            XCTFail();
            
            NOTIFY;
        }
    }];
    WAIT;
}

- (void)testGetTenderCalculator {
    [self loginTest:^(BOOL isSuccess) {
        if (isSuccess) {
            [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
                assertNotNil(dic);
                assertEqual(error.code, 0);
                
                NSArray *array = [dic objectForKey:@"tenderList"];
                assertNotNil(array);
                assertTrue(array.count > 1);
                
                TenderItemModel *model = [[TenderItemModel alloc] initWithDic:[array objectAtIndex:1]];
                
                [TenderRequest getTenderCalculatorWithTenderId:model.tenderId borrowAmount:@"99" bonusId:@(0) increaseId:@(0) success:^(NSDictionary *dic, BCError *error) {
                    assertNotNil(dic);
                    assertEqual(error.code, 0);
                    
                    NOTIFY;
                } failure:^(NSError *error) {
                    XCTFail();
                    
                    NOTIFY;
                }];
            } failure:^(NSError *error) {
                XCTFail();
                
                NOTIFY;
            }];
        } else {
            XCTFail(@"");
            
            NOTIFY;
        }
    }];
    WAIT;
}

- (void)testGetTenderUserStatus {
    [self loginTest:^(BOOL isSuccess) {
        if (isSuccess) {
            [TenderRequest getTenderUserStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
                assertNotNil(dic);
                assertEqual(error.code, 0);
                
                NOTIFY;
            } failure:^(NSError *error) {
                XCTFail();
                
                NOTIFY;
            }];
        } else {
            XCTFail(@"");
            
            NOTIFY;
        }
    }];
    WAIT;
}

- (void)testGetTenderProtocol {
    [self loginTest:^(BOOL isSuccess) {
        if (isSuccess) {
            [TenderRequest getTenderListWithPageIndex:1 success:^(NSDictionary *dic, BCError *error) {
                assertNotNil(dic);
                assertEqual(error.code, 0);
                
                NSArray *array = [dic objectForKey:@"tenderList"];
                assertNotNil(array);
                assertTrue(array.count > 1);
                
                TenderItemModel *model = [[TenderItemModel alloc] initWithDic:[array objectAtIndex:1]];
                
                [TenderRequest getTenderProtocolWithTenderId:model.tenderId success:^(NSDictionary *dic, BCError *error) {
                    assertNotNil(dic);
                    assertEqual(error.code, 0);
                    
                    NOTIFY;
                } failure:^(NSError *error) {
                    XCTFail();
                    
                    NOTIFY;
                }];
            } failure:^(NSError *error) {
                XCTFail();
                
                NOTIFY;
            }];
        } else {
            XCTFail(@"");
            
            NOTIFY;
        }
    }];
    WAIT;
}

@end
