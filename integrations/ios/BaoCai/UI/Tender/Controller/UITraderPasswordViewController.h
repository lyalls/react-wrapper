//
//  UITraderPasswordViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TenderItemModel.h"

typedef void (^PaySuccess)(NSDictionary *);
typedef void (^CancelRecharge)();
typedef void (^ToRecharge)();
typedef void (^BackTenderList)();
typedef void (^BackTenderDetail)();
typedef void (^ForgetPassword)();

@interface UITraderPasswordViewController : UIViewController

@property (nonatomic, strong) TenderItemModel *itemModel;

@property (nonatomic, strong) NSString *borrowAmount;
@property (nonatomic, strong) NSString *activityCode;

//红包卷，加息卷
@property (nonatomic, copy) NSNumber *bonusId;
@property (nonatomic, copy) NSNumber *increaseId;

@property (nonatomic, strong) PaySuccess paySuccess;
@property (nonatomic, strong) CancelRecharge cancelRecharge;
@property (nonatomic, strong) ToRecharge toRecharge;
@property (nonatomic, strong) BackTenderList backTenderList;
@property (nonatomic, strong) BackTenderDetail backTenderDetail;
@property (nonatomic, strong) ForgetPassword forgetPasswordBlock;

@end
