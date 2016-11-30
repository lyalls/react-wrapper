//
//  UIWebViewController.h
//  BaoCai
//
//  Created by meng on 16/9/1.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WebEventHandller)(id param,NSString* callbackId);

@interface UIWebViewController : UIViewController
//左导航按钮
@property (nonatomic,strong)UIButton *leftBt;
@property (nonatomic, readonly) UIWebView* webView;
@property (nonatomic,copy) NSURLRequest* req;
@property (nonatomic,assign) BOOL openInNewWindow;
@property (nonatomic,assign) BOOL canScroll;
@property (nonatomic,assign) BOOL showLoading;
@property (nonatomic,assign) BOOL staticTitle;
//回调js页面
-(void) JSCallback:(NSString*)callId param:(id)param;
//打开登录页面
-(void) openLoginPage:(id)parmas callId:(NSString*)callId;
//重新加载页面
-(void) reLoad:(id)parmas callId:(NSString*)callId;
//显示提示信息
-(void) showMsg:(id)parmas callId:(NSString*)callId;
//分享
-(void) openShare:(id)parmas callId:(NSString*)callId;
//显示对话框
-(void) showDialog:(id)parmas callId:(NSString*)callId;

//添加事件处理
-(void) addEventHandler:(NSString*)eventName WebEventHandller:(WebEventHandller)handller;

#pragma mark - Source files
+(NSString*) documentsPath;
+(BOOL) checkLocalUpdate;
+(NSString *)componentBasePath;
+(NSString *)componentIndex: (NSString *)componentName;
+(BOOL) copySrcToDoc ;

@end