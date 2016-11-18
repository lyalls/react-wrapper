//
//  UIShareViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

typedef void(^shareResultBlock)(BOOL);

#import <UIKit/UIKit.h>

@interface UIShareViewController : UIViewController

@property (nonatomic, strong) NSDictionary *shareDic;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareUrl;

//分享结果
@property shareResultBlock block;

@end
