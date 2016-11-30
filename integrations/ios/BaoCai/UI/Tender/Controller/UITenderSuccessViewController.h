//
//  UITenderSuccessViewController.h
//  BaoCai
//
//  Created by meng on 16/9/20.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//0:继续投资，1:查看投资列表
typedef void(^TenderSuccessCallback)(int);
@interface UITenderSuccessViewController : UIViewController

//提示信息
@property (nonatomic, strong) NSString *successMessage;

//分享按钮是否显示
@property (nonatomic, assign) BOOL sharebtnIsShow;
//分享按钮图片地址
@property NSString* sharebtnImageUrl;

//分享标题
@property NSString* shareTitle;
//分享内容
@property NSString* shareDesc;
//分享url
@property NSString* shareUrl;
//分享图片地址
@property NSString* shareImageUrl;
//回调block
@property TenderSuccessCallback callback;
@end
