//
//  MyCoupon.h
//  BaoCai
//
//  Created by lishuo on 16/9/5.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaiseRatesCoupon : NSObject

@property (nonatomic,strong) NSString *strId;
@property (nonatomic,strong) NSString *expiredTime;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *useMoney;
@property (nonatomic,strong) NSString *AppExpiredTime;
@property (nonatomic,strong) NSString *apr;

-(id)initWithDic:(NSDictionary*)dic;
@end

@interface RedBagCoupon : NSObject

@property (nonatomic,strong) NSString *strId;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *ticketDesc;
@property (nonatomic,strong) NSString *ticketDurationDesc;
@property (nonatomic,strong) NSString *expiredTime;
@property (nonatomic,strong) NSString *ticketType;
@property (nonatomic,strong) NSString *AppExpiredTime;
-(id)initWithDic:(NSDictionary*)dic;
@end
