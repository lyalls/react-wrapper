//
//  UIWebViewController.m
//  BaoCai
//
//  Created by meng on 16/9/1.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIWebViewController.h"
#import "NSString+Category.h"
#import "UILoginViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIViewController+WebView.h"
#import "UIAlertView+Category.h"
#import "UIPlayViewController.h"
#import "HTTPRequest.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "UIShareViewController.h"


@interface UIWebViewController()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    dispatch_queue_t _queue;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSMutableDictionary* _eventDict;
    NSString* _logPath;
    NSTimer * timer;
    BOOL isViewLoaded;
    NSURLRequest *_req;
}
@property (nonatomic, strong) UIWebView* webView;
@end

@implementation UIWebViewController

// MARK: View Controller Lifecycle
-(void)loadView{
    isViewLoaded = false;
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self.view addSubview: _webView];
    _queue = dispatch_queue_create("com.baocai.jscall",0);
    
    if(self.req)
    {
        [_webView loadRequest:self.req];
    }
    
    self.leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBt.frame = CGRectMake(0, 0, 16, 16);
    self.leftBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftBt setBackgroundImage:[UIImage imageNamed:@"backImage.png"] forState:normal];
    [self.leftBt addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:LogoutNotification object:nil];

    [self setLeftButtonHidden:YES];
    isViewLoaded = YES;
}

//
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.showLoading)
    {
        [self.navigationController.navigationBar addSubview:_progressView];
    }
}

//
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

// MARK: 设置Web请求、响应Web请求
-(void)setReq:(NSURLRequest *)req {
    if(req == nil){
        _req = nil;
    }else if(_req == nil || ![req.URL.absoluteString isEqualToString: _req.URL.absoluteString]){
        NSLog(@"req.URL=%@, _req.URL=%@, isEqual: %d", req.URL.absoluteString, _req.URL.absoluteString, [req.URL.absoluteString isEqualToString:_req.URL.absoluteString]);
        _req = req;
        if( isViewLoaded ){
            NSError *error = nil;
            NSString *content = [NSString stringWithContentsOfURL:req.URL encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"%@ is Loading HTML file [%@], content: { %@ }, error: %@",[self class], req.URL.absoluteString, content, error);
            [_webView loadRequest:req];
            
            if (![self.view.subviews containsObject:_webView]){
                [self.view addSubview:_webView];
            }
            [self.view bringSubviewToFront:_webView];
        }
    }
}

-(void)setTitleFromDocument{
    if(!self.staticTitle){
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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

//页面加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setTitleFromDocument];   
}

//UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked && self.openInNewWindow) {
        UIWebViewController* view = [[UIWebViewController alloc] init];
        view.canScroll = YES;
        view.req = [self getWebBrowserRequestWithUrl:request.URL.absoluteString];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
        return NO;
    }
    NSURL* url = [request URL];
    if ([[url scheme] isEqualToString:@"jscall"]) {
        //获取调用内容
        NSString* jsstr = [_webView stringByEvaluatingJavaScriptFromString:@"App.platform.fetchMessage()"];
        [self exec:[jsstr toJSONObject]];
        
        return NO;
    }
    else
    {
        return [self handelWebBrowserJsonMethod:url.absoluteString];
    }
}

//添加事件处理
-(void) addEventHandler:(NSString*)eventName WebEventHandller:(WebEventHandller)handller
{
    if(!_eventDict)
    {
        _eventDict = [[NSMutableDictionary alloc] init];
    }
    
    _eventDict[eventName] = handller;
}


// MARK: WebView Controller 全局动作
//初始化
-(void) AppInit:(id)parmas callId:(NSString*)callId
{
    if(callId)
    {
        [self JSCallback:callId param:@""];
    }
}

//打开登录页面
-(void) openLoginPage:(id)parmas callId:(NSString*)callId
{
    _logPath = parmas;
    UIStoryboard *loginRegisterStoryboard = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
    UINavigationController* nav = [loginRegisterStoryboard instantiateViewControllerWithIdentifier:@"LoginViewNav"];
    
    UILoginViewController *view = (UILoginViewController*)nav.topViewController;
    
    [view show:self callback:nil];
}

//显示或隐藏返回按钮
-(void)setLeftButtonHidden:(BOOL)hidden{
    if(hidden){
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBt];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

//默认左边导航栏按钮动作
-(void)leftButtonPress:(id)sender
{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//显示图片
-(void) showImage:(id)parmas callId:(NSString*)callId
{
    NSNumber* currentIndex = [parmas valueForKey:@"index"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (NSString* url in [parmas valueForKey:@"list"]) {
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
-(void) openShare:(id)parmas callId:(NSString*)callId
{
    UIShareViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIShareViewController"];
    view.shareTitle = [parmas valueForKey:@"title"];
    view.shareDesc = [parmas valueForKey:@"desc"];
    view.shareUrl = [parmas valueForKey:@"url"];
    view.shareImageUrl = [parmas valueForKey:@"image"];
    view.block = ^(BOOL res)
    {
        if(callId)
        {
            [self JSCallback:callId param:[NSNumber numberWithBool:res]];
        }
    };
    [self presentTranslucentViewController:view animated:YES];
}

//显示提示信息
-(void) showMsg:(id)parmas callId:(NSString*)callId
{
    SHOWTOAST(parmas);
}

//显示对话框
-(void) showDialog:(id)parmas callId:(NSString*)callId
{
    NSString* title = [parmas valueForKey:@"title"];
    NSString* message = [parmas valueForKey:@"message"];
    NSArray* list = [parmas valueForKey:@"buttons"];
    UIAlertView* alert = [[UIAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    for (NSString* btn in list) {
        [alert addButtonWithTitle:btn];
    }
    
    [alert clickedButtonEvent:^(NSInteger buttonIndex) {
        if(callId)
        {
            [self JSCallback:callId param:[NSString stringWithFormat:@"%ld",(long)buttonIndex]];
        }
    }];
    
    [alert show];
    
}

//重新加载页面
-(void) reLoad:(id)parmas callId:(NSString*)callId
{
    
    if(parmas)
    {
        self.req = [self getWebBrowserRequestWithUrl:parmas];
    }
    
    [_webView loadRequest:self.req];
}

//播放视频
-(void) showVideo:(id)parmas callId:(NSString*)callId
{
    UIPlayViewController *play = [self getControllerByStoryBoardType:StoryBoardTypeTender identifier:@"UIPlayViewController"];
    play.videoURL = [parmas objectForKey:@"url"];;
    [self.navigationController pushViewController:play animated:YES];
    if(callId)
    {
        [self JSCallback:callId param:@""];
    }
}

//页面跳转
-(void) pop:(id)parmas callId:(NSString*)callId
{
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: WebView消息 及 NSNotificationCenter相关业务消息
//title改变
-(void) titleChanged:(id)parmas callId:(NSString*)callId
{
    [self setTitleFromDocument];
    if(callId)
    {
        [self JSCallback:callId param:@""];
    }
}

- (void)loginSuccess {
    //刷新
    // NSString* url = _webView.request.URL.absoluteString;
    NSString *url = self.req.URL.absoluteString;
    if(_logPath)
    {
        url = _logPath;
        _logPath = nil;
    }
    
    self.req = [self getWebBrowserRequestWithUrl:url];
    NSLog(@"%@ is going to reload when login success to url: %@", [self class], url);
    [self reLoad:nil callId:nil];
}

- (void)logoutSuccess {
    //刷新
    // NSString* url = _webView.request.URL.absoluteString;
    NSString *url = self.req.URL.absoluteString;
    self.req = [self getWebBrowserRequestWithUrl:url];
    [self reLoad:nil callId:nil];
}

// MARK: 本地数据 与 API 请求
// 获取本地数据版本
-(void) getLocalDataVersion:(id)dataName callId:(NSString*)callId{
    NSString *dataVersion = @"";
    if([dataName isEqualToString:@"banner"]){
        dataVersion = [UserDefaultsHelper sharedManager].bannerVersion;
    }
    [self JSCallback:callId param:dataVersion];
}

// 设置本地数据版本
-(void) setLocalDataVersion:(id)params callId:(NSString*)callId{
    NSString *success = @"0";
    NSString *dataName = [params objectForKey:@"name"];
    NSString *dataVersion = [params objectForKey:@"version"];
    if([dataName isEqualToString:@"banner"]){
        [UserDefaultsHelper sharedManager].bannerVersion = dataVersion;
        success = @"1";
    }
    [self JSCallback:callId param:success];
}

// 获取本地数据
-(void) getLocalData:(id)dataName callId:(NSString *)callId{
    id data = nil;
    if([dataName isEqualToString:@"banner"]){
        data = [UserDefaultsHelper sharedManager].bannerInfo;
    }
    [self JSCallback:callId param:data];
}

// 设置本地数据
-(void) setLocalData:(id)params callId:(NSString *)callId{
    NSString *success = @"0";
    NSString *name = [params objectForKey:@"name"];
    id data = [params objectForKey:@"data"];
    if([name isEqualToString:@"banner"] && [data isMemberOfClass:[NSDictionary class]]){
        [UserDefaultsHelper sharedManager].bannerInfo = data;
        success = @"1";
    }
    [self JSCallback:callId param:success];
}


//执行 NativeAPI 请求
-(void)requestAPI:(id)params callId:(NSString*)callId{
    if(params == nil || params == NULL) return;
    NSMutableDictionary *args = [(NSDictionary *)params mutableCopy];
    NSString *url = [args objectForKey:@"_api_"];
    [args removeObjectForKey:@"_api_"];
    if(!url || url.length == 0) {
        if(callId && callId.length > 0){
            [self JSCallback:callId param:@{@"error": @"URL is empty"}];
        }
    }else{
        NSLog(@"%@ is requesting API from webview, url: %@, params: %@", [self class], url, args);
        [HTTPRequest send:url args:args success:^(NSDictionary *data, BCError *error) {
            if(callId && callId.length > 0){
                if(error && error.code != 0){
                    [self JSCallback:callId param:@{@"error": error}];
                }else{
                    [self JSCallback:callId param:@{@"data": data}];
                }
            }
        } failure:^(NSError *error) {
            if(callId && callId.length > 0){
                [self JSCallback:callId param:@{@"error": error}];
            }
        }];
    }
}

// MARK: 与WebView交互方法
-(NSString*) strTrans:(NSString*)param{
    //处理特殊字符
    NSMutableString* str = [[NSMutableString alloc] init];
    for(int i =0;param && i<param.length;i++)
    {
        if([param characterAtIndex:i] == '\"')
        {
            [str appendString:@"\\\""];
        }
        else if([param characterAtIndex:i] == '\\')
        {
            [str appendString:@"\\\\"];
        }
        else if([param characterAtIndex:i] == '\r')
        {
            [str appendString:@"\\r"];
        }
        else if([param characterAtIndex:i] == '\n')
        {
            [str appendString:@"\\n"];
        }
        else
        {
            
            [str appendFormat:@"%c",[param characterAtIndex:i]];
        }
        
    }

    return [NSString stringWithFormat:@"\"%@\"",str];
}

// 执行 JS 回调方法
-(void) JSCallback:(NSString*)callId param:(id)param
{
    NSString* str = @"''";
    if([param isKindOfClass:[NSString class]])
    {
        str = [self strTrans:param];
    }
    else if([param isKindOfClass:[NSArray class]] || [param isKindOfClass:[NSDictionary class]])
    {
        str = [param toString];
    }
    else if([param isKindOfClass:[NSNumber class]])
    {
        str = [param stringValue];
    }
    
    str = [NSString stringWithFormat:@"App.platform.callback('%@',%@)",callId,str];
    NSLog(@"callback:%@",str);
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}

//private method
-(void) exec:(NSArray*)jsArray
{
    dispatch_async(_queue, ^{
         for (NSArray* params in jsArray) {
             NSLog(@"%@ is going to execute native method from H5 invocation, params: %@", [self class], params);
             NSString *selName = [NSString stringWithFormat:@"%@:callId:",params[0]];
             SEL sel = NSSelectorFromString(selName);
             NSString* callId = nil;
             if([params[2] isKindOfClass:[NSString class]])
             {
                 callId = params[2];
             }
             if([self respondsToSelector:sel])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self performSelector:sel withObject:params[1] withObject:callId];
                    #pragma clang diagnostic pop
                 });
             }
             else
             {
                 //从消息列表查询
                 if(_eventDict[params[0]])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                        WebEventHandller handller = _eventDict[params[0]];
                         handller(params[1],callId);
                    });
                 }
                 else{
                     NSLog(@"ERROR: [%@] Native method: %@ (%@ in native) not found, which was invoked by H5 request",
                           [self class], params[0], selName);
                 }
             }
         }
    });
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - 拷贝 H5 代码到 documents 文件夹
+(NSString*) documentsPath{
    NSString *g_docPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count) {
        g_docPath = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
    }
    else{
        g_docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    }
    return g_docPath;
}
+(BOOL) checkLocalUpdate{
    NSString* oldver = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Components/version.txt",[[self class] documentsPath]]
                                                 encoding:NSUTF8StringEncoding error:nil];
    NSString* newver = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"/Components/version"] ofType:@"txt"]
                                                 encoding:NSUTF8StringEncoding error:nil];
    if(!oldver || !newver) return YES;
    return (NSOrderedDescending == [newver compare:oldver]);
}
+(NSString *)componentBasePath{
    return [NSString stringWithFormat:@"%@Components",[[self class] documentsPath]];
}
+(NSString *)componentIndex: (NSString *)componentName{
    return [NSString stringWithFormat:@"file://%@Components/%@.html",[[self class] documentsPath], componentName];
}
+(BOOL) copySrcToDoc {
    //copy component source files to doc
    NSString * path = [[self class]componentBasePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:path] || [[self class] checkLocalUpdate]){
        [fm removeItemAtPath:path error:nil];
        NSString* source = [[NSBundle mainBundle] pathForResource:@"/Components" ofType:@""];
        NSLog(@"Copy source files from [%@] to [%@]",source, path);
        NSError* error;
        BOOL res = [fm copyItemAtPath:source toPath:path error:&error];
        if(!res){
            NSLog(@"ERROR when copying source files from [%@] to [%@]: %@",source, path, error);
            return NO;
        }else{
            // Remove all caches
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }
    return YES;
}
@end
