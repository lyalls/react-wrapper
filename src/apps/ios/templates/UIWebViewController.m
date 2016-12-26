//
//  UIWebViewController.m
//  BaoCai
//
//  Created by meng on 16/9/1.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIWebViewController.h"
#import "NSString+Category.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIViewController+WebView.h"
#import "UIAlertView+Category.h"
#import "UIPlayViewController.h"
#import "HTTPRequest.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "UIShareViewController.h"
#import "UITenderDetailViewController.h"
#import "UserRequest.h"
#import "MyRequest.h"
#import "UIRechargeViewController.h"
#import "UIFirstRechargeViewController.h"
#import "UIRealNameViewController.h"
#import "UIMyTenderListViewController.h"
#import "UINewTicketListViewController.h"
#import "UIInviteFriendsViewController.h"
#import "UIChatViewController.h"

@interface UIWebViewController() <UIWebViewDelegate, NJKWebViewProgressDelegate> {
    dispatch_queue_t _queue;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSMutableDictionary *_eventDict;
    NSString *_logPath;
    NSTimer *timer;
    BOOL isViewLoaded;
    NSURLRequest *_req;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UIWebViewController

// MARK: - View Controller Lifecycle
- (void)loadView{
    isViewLoaded = false;
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackViewColor;
    
    CGRect webViewBounds = self.view.bounds;
    
    webViewBounds.origin = self.view.bounds.origin;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.webView = [[UIWebView alloc] initWithFrame:webViewBounds];
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _webView.scrollView.scrollEnabled = self.canScroll;
    _webView.delegate = _progressProxy;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    _queue = dispatch_queue_create("com.baocai.jscall",0);
    
    if (self.req) {
        [_webView loadRequest:self.req];
        //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    }
    
    self.leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBt.frame = CGRectMake(0, 0, 16, 16);
    self.leftBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftBt setBackgroundImage:[UIImage imageNamed:@"backImage.png"] forState:normal];
    [self.leftBt addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBt];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbsLoginSuccess) name:BBSLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbsLogoutSuccess) name:BBSLogoutSuccessNotification object:nil];
    
    isViewLoaded = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showLoading) {
        [self.navigationController.navigationBar addSubview:_progressView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

// MARK: - 设置Web请求、响应Web请求
- (void)setReq:(NSURLRequest *)req {
    if (req == nil) {
        _req = nil;
    } else if (_req == nil || ![req.URL.absoluteString isEqualToString: _req.URL.absoluteString]|| ![req.allHTTPHeaderFields isEqual:_req.allHTTPHeaderFields]) {
        NSLog(@"req.URL.absoluteString = %@\n\r_req.URL.absoluteString = %@\n\rreq.allHTTPHeaderFields = %@\n\r_req.allHTTPHeaderFields = %@", req.URL.absoluteString, _req.URL.absoluteString, req.allHTTPHeaderFields, _req.allHTTPHeaderFields);
        _req = req;
        if (isViewLoaded) {
            NSError *error = nil;
            NSString *content = [NSString stringWithContentsOfURL:req.URL encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"%@ is Loading HTML file [%@], content: { %@ }, error: %@",[self class], req.URL.absoluteString, content, error);
            [_webView loadRequest:req];
            
            if (![self.view.subviews containsObject:_webView]) {
                [self.view addSubview:_webView];
            }
            [self.view bringSubviewToFront:_webView];
        }
    }
}

-(void)setTitleFromDocument{
    if(!self.staticTitle){
        NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSRange range = [title rangeOfString:@":"];
        NSLog(@"Document title: %@, range of ':' location: %ld, length: %ld", title, range.location, range.length);
        if(range.length > 0 && range.location < title.length - 1){
            NSString *tabTitle = [title substringWithRange:NSMakeRange(0, range.location)];
            NSString *navTitle = [title substringWithRange:NSMakeRange(range.location+1, title.length - range.location - 1)];
            self.navigationController.navigationBar.topItem.title = navTitle;
            self.navigationController.title = tabTitle;
        }else{
            self.title = title;
        }
    }
}

#pragma mark - Web view delegate

//页面加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self setTitleFromDocument];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

//UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked && self.openInNewWindow) {
        NSString *webUrl = request.URL.absoluteString;
        [self openWebWithUrl:webUrl];
        
        return NO;
    }
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"jscall"]) {
        //获取调用内容
        NSString *jsstr = [_webView stringByEvaluatingJavaScriptFromString:@"App.platform.fetchMessage()"];
        [self exec:[jsstr toJSONObject]];
        
        return NO;
    } else {
        return [self handelWebBrowserJsonMethod:url.absoluteString inviteFriendsModel:self.inviteFirends];
    }
}

#pragma mark - Web view js call

//添加事件处理
- (void)addEventHandler:(NSString *)eventName WebEventHandller:(WebEventHandller)handller {
    if (!_eventDict) {
        _eventDict = [[NSMutableDictionary alloc] init];
    }
    
    _eventDict[eventName] = handller;
}


// MARK: - WebView Controller 全局动作
//初始化
- (void)AppInit:(id)parmas callId:(NSString *)callId {
    if(callId) {
        [self JSCallback:callId param:@""];
    }
}

//打开登录页面
- (void)openLoginPage:(id)parmas callId:(NSString *)callId {
    _logPath = parmas;
    [self toLoginViewController];
}

//默认左边导航栏按钮动作
- (void)leftButtonPress:(id)sender {
    if([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//显示图片
- (void)showImage:(id)parmas callId:(NSString *)callId {
    NSNumber *currentIndex = [parmas valueForKey:@"index"];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *url in [parmas valueForKey:@"list"]) {
        [list addObject:[MWPhoto photoWithURL:[url toURL]]];
    }
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:list];
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    [photoBrowser setCurrentPhotoIndex:[currentIndex integerValue]];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

//分享
- (void)openShare:(id)parmas callId:(NSString *)callId {
    UIShareViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIShareViewController"];
    view.shareTitle = [parmas valueForKey:@"title"];
    view.shareDesc = [parmas valueForKey:@"desc"];
    view.shareUrl = [parmas valueForKey:@"url"];
    view.shareImageUrl = [parmas valueForKey:@"image"];
    view.block = ^(BOOL res) {
        if(callId) {
            [self JSCallback:callId param:[NSNumber numberWithBool:res]];
        }
    };
    [self presentTranslucentViewController:view animated:YES];
}

//显示提示信息
- (void)showMsg:(id)parmas callId:(NSString *)callId {
    SHOWTOAST(parmas);
}

//显示对话框
- (void)showDialog:(id)parmas callId:(NSString *)callId {
    NSString *title = [parmas valueForKey:@"title"];
    NSString *message = [parmas valueForKey:@"message"];
    NSArray *list = [parmas valueForKey:@"buttons"];
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    for (NSString *btn in list) {
        [alert addButtonWithTitle:btn];
    }
    
    [alert clickedButtonEvent:^(NSInteger buttonIndex) {
        if (callId) {
            [self JSCallback:callId param:[NSString stringWithFormat:@"%ld",(long)buttonIndex]];
        }
    }];
    
    [alert show];
    
}

//重新加载页面
- (void)reLoad:(id)parmas callId:(NSString *)callId {
    
    if(parmas) {
        self.req = [self getWebBrowserRequestWithUrl:parmas];
    }
    
    [_webView loadRequest:self.req];
}

//播放视频
- (void)showVideo:(id)parmas callId:(NSString *)callId {
    UIPlayViewController *play = [self getControllerByStoryBoardType:StoryBoardTypeTender identifier:@"UIPlayViewController"];
    play.videoURL = [parmas objectForKey:@"url"];;
    [self.navigationController pushViewController:play animated:YES];
    if(callId) {
        [self JSCallback:callId param:@""];
    }
}

//页面跳转
- (void)pop:(id)parmas callId:(NSString *)callId {
    [self.navigationController popViewControllerAnimated:YES];
}

//打开列表页
- (void)openInvestListPage:(id)parmas callId:(NSString *)callId {
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//返回首页
- (void)openInvestHomePage:(id)parmas callId:(NSString *)callId {
    [self.navigationController popViewControllerAnimated:YES];
}

//打开散标详情页
- (void)openProdectDetail:(id)parmas callId:(NSString *)callId {
    UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
    viewController.tenderId = [parmas valueForKey:@"id"];
    [self.navigationController pushViewController:viewController animated:YES];
}

//打开我的页
- (void)openMyHome:(id)parmas callId:(NSString *)callId {
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//打开充值页
- (void)openMyHomeCharge:(id)parmas callId:(NSString *)callId {
    SHOWPROGRESSHUD;
    [UserRequest userCheckAuthenticationStatus:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0 || error.code == 2003) {
            [MyRequest getRechargeStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
                HIDDENPROGRESSHUD;
                if (error.code == 0) {
                    RechargeModel *model = [[RechargeModel alloc] initWithDic:dic];
                    if (model.isNotFirstRecharge) {
                        UIRechargeViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeRecharge identifier:@"UIRechargeViewController"];
                        view.model = model;
                        [self.navigationController pushViewController:view animated:YES];
                    } else {
                        UIFirstRechargeViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeRecharge identifier:@"UIFirstRechargeViewController"];
                        view.model = model;
                        [self.navigationController pushViewController:view animated:YES];
                    }
                } else {
                    SHOWTOAST(error.message);
                }
            } failure:^(NSError *error) {
                HIDDENPROGRESSHUD;
                SHOWTOAST(@"充值失败，请稍后再试");
            }];
        } else if (error.code == 2001) {
            HIDDENPROGRESSHUD;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UIRealNameViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UIRealNameViewController"];
                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        } else if (error.code == 2002) {
            HIDDENPROGRESSHUD;
            SHOWTOAST(@"实名认证审核中");
        } else {
            HIDDENPROGRESSHUD;
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"充值失败，请稍后再试");
    }];
}

//打开我的散标投资页
- (void)openMyHomeInvestListPage:(id)parmas callId:(NSString *)callId {
    UIMyTenderListViewController *viewController = [[UIMyTenderListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

//打开优惠券页
- (void)openMyHomeCoupons:(id)parmas callId:(NSString *)callId {
    UINewTicketListViewController *viewController = [[UINewTicketListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

//打开邀请好友页
- (void)openMyHomeInviteFriends:(id)parmas callId:(NSString *)callId {
    UIInviteFriendsViewController *viewController = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIInviteFriendsViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

//打开在线客服页
- (void)openMyHomeOnlineCustomerService:(id)parmas callId:(NSString *)callId {
    UIChatViewController *chatController = [[UIChatViewController alloc] initWithConversationChatter:CustomServiceSessionID conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}

// MARK: - WebView消息 及 NSNotificationCenter相关业务消息
//title改变
- (void)titleChanged:(id)parmas callId:(NSString *)callId {
    [self setTitleFromDocument];
    if (callId) {
        [self JSCallback:callId param:@""];
    }
}

- (void)loginSuccess {
    NSString *url = self.req.URL.absoluteString;
    if (![url hasPrefix:@"https://bbs.baocai.com"]) {
        if (_logPath) {
            url = _logPath;
            _logPath = nil;
        }
        self.req = [self getWebBrowserRequestWithUrl:url];
    }
}

- (void)bbsLoginSuccess {
    NSString *url = self.req.URL.absoluteString;
    if ([url hasPrefix:@"https://bbs.baocai.com"]) {
        if (_logPath) {
            url = _logPath;
            _logPath = nil;
        }
        self.req = [self getWebBrowserRequestWithUrl:url];
    }
}

- (void)logoutSuccess {
    NSString *url = self.req.URL.absoluteString;
    if (![url hasPrefix:@"https://bbs.baocai.com"]) {
        self.req = [self getWebBrowserRequestWithUrl:url];
    }
}

- (void)bbsLogoutSuccess {
    NSString *url = self.req.URL.absoluteString;
    if ([url hasPrefix:@"https://bbs.baocai.com"]) {
        self.req = [self getWebBrowserRequestWithUrl:url];
    }
}

// MARK: - 本地数据 与 API 请求
// 获取本地数据版本
- (void)getLocalDataVersion:(id)dataName callId:(NSString *)callId{
    NSString *dataVersion = @"";
    if ([dataName isEqualToString:@"banner"]) {
        dataVersion = [UserDefaultsHelper sharedManager].bannerVersion;
    }
    [self JSCallback:callId param:dataVersion];
}

// 设置本地数据版本
- (void)setLocalDataVersion:(id)params callId:(NSString *)callId{
    NSString *success = @"0";
    NSString *dataName = [params objectForKey:@"name"];
    NSString *dataVersion = [params objectForKey:@"version"];
    if ([dataName isEqualToString:@"banner"]) {
        [UserDefaultsHelper sharedManager].bannerVersion = dataVersion;
        success = @"1";
    }
    [self JSCallback:callId param:success];
}

// 获取本地数据
- (void)getLocalData:(id)dataName callId:(NSString *)callId{
    id data = nil;
    if ([dataName isEqualToString:@"banner"]) {
        data = [UserDefaultsHelper sharedManager].bannerInfo;
    }
    [self JSCallback:callId param:data];
}

// 设置本地数据
- (void)setLocalData:(id)params callId:(NSString *)callId {
    NSString *success = @"0";
    NSString *name = [params objectForKey:@"name"];
    id data = [params objectForKey:@"data"];
    if ([name isEqualToString:@"banner"] && [data isMemberOfClass:[NSDictionary class]]) {
        [UserDefaultsHelper sharedManager].bannerInfo = data;
        success = @"1";
    }
    [self JSCallback:callId param:success];
}


//执行 NativeAPI 请求
- (void)requestAPI:(id)params callId:(NSString *)callId{
    if (params == nil || params == NULL) return;
    NSMutableDictionary *args = [(NSDictionary *)params mutableCopy];
    NSString *url = [args objectForKey:@"_api_"];
    [args removeObjectForKey:@"_api_"];
    if (!url || url.length == 0) {
        if(callId && callId.length > 0){
            [self JSCallback:callId param:@{@"error": @"URL is empty"}];
        }
    } else {
        NSLog(@"%@ is requesting API from webview, url: %@, params: %@", [self class], url, args);
        [HTTPRequest send:url args:args success:^(NSDictionary *data, BCError *error) {
            if (callId && callId.length > 0) {
                if (error && error.code != 0) {
                    [self JSCallback:callId param:@{@"error": error}];
                } else {
                    [self JSCallback:callId param:@{@"data": data}];
                }
            }
        } failure:^(NSError *error) {
            if (callId && callId.length > 0) {
                [self JSCallback:callId param:@{@"error": error}];
            }
        }];
    }
}

// MARK: - 与WebView交互方法
- (NSString *)strTrans:(NSString *)param{
    //处理特殊字符
    NSMutableString *str = [[NSMutableString alloc] init];
    for(int i = 0; param && i < param.length; i++) {
        if ([param characterAtIndex:i] == '\"') {
            [str appendString:@"\\\""];
        } else if ([param characterAtIndex:i] == '\\') {
            [str appendString:@"\\\\"];
        } else if ([param characterAtIndex:i] == '\r') {
            [str appendString:@"\\r"];
        } else if([param characterAtIndex:i] == '\n') {
            [str appendString:@"\\n"];
        } else {
            [str appendFormat:@"%c",[param characterAtIndex:i]];
        }
    }
    
    return [NSString stringWithFormat:@"\"%@\"",str];
}

// 执行 JS 回调方法
- (void)JSCallback:(NSString *)callId param:(id)param {
    NSString* str = @"''";
    if ([param isKindOfClass:[NSString class]]) {
        str = [self strTrans:param];
    } else if ([param isKindOfClass:[NSArray class]] || [param isKindOfClass:[NSDictionary class]]) {
        str = [param toString];
    } else if ([param isKindOfClass:[NSNumber class]]) {
        str = [param stringValue];
    }
    
    str = [NSString stringWithFormat:@"App.platform.callback('%@',%@)",callId,str];
    NSLog(@"callback:%@",str);
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}

//private method
- (void)exec:(NSArray *)jsArray {
    dispatch_async(_queue, ^{
        for (NSArray *params in jsArray) {
            NSLog(@"%@ is going to execute native method from H5 invocation, params: %@", [self class], params);
            NSString *selName = [NSString stringWithFormat:@"%@:callId:",params[0]];
            SEL sel = NSSelectorFromString(selName);
            NSString* callId = nil;
            if ([params[2] isKindOfClass:[NSString class]]) {
                callId = params[2];
            }
            if ([self respondsToSelector:sel]) {
                dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self performSelector:sel withObject:params[1] withObject:callId];
#pragma clang diagnostic pop
                });
            } else {
                //从消息列表查询
                if(_eventDict[params[0]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        WebEventHandller handller = _eventDict[params[0]];
                        handller(params[1],callId);
                    });
                } else {
                    NSLog(@"ERROR: [%@] Native method: %@ (%@ in native) not found, which was invoked by H5 request",
                          [self class], params[0], selName);
                }
            }
        }
    });
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - 拷贝 H5 代码到 documents 文件夹
+ (NSString *)documentsPath {
    NSString *g_docPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count) {
        g_docPath = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
    } else {
        g_docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    }
    return g_docPath;
}

+ (BOOL)checkLocalUpdate {
    NSString *oldver = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Components/version.txt", [[self class] documentsPath]] encoding:NSUTF8StringEncoding error:nil];
    NSString *newver = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"/Components/version"] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    if (!oldver || !newver) return YES;
    return (NSOrderedDescending == [newver compare:oldver]);
}

+ (NSString *)componentBasePath {
    return [NSString stringWithFormat:@"%@Components",[[self class] documentsPath]];
}
+ (NSString *)componentIndex:(NSString *)componentName {
    return [NSString stringWithFormat:@"file://%@Components/%@.html",[[self class] documentsPath], componentName];
}
+ (BOOL)copySrcToDoc {
    //copy component source files to doc
    NSString *path = [[self class]componentBasePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path] || [[self class] checkLocalUpdate]) {
        [fm removeItemAtPath:path error:nil];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"/Components" ofType:@""];
        NSLog(@"Copy source files from [%@] to [%@]", source, path);
        NSError *error;
        BOOL res = [fm copyItemAtPath:source toPath:path error:&error];
        if (!res) {
            NSLog(@"ERROR when copying source files from [%@] to [%@]: %@",source, path, error);
            return NO;
        } else {
            // Remove all caches
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }
    return YES;
}

@end
