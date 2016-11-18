//
//  ViewController.m
//  PlayYoukuVideo
//
//  Created by yumlive0909 on 15/9/10.
//  Copyright (c) 2015年 yumlive0909. All rights reserved.
//

#import "UIPlayViewController.h"
 #import <MediaPlayer/MediaPlayer.h>

#define XPosition  0.0f
#define YPosition  ([UIScreen mainScreen].bounds.size.height/4 - 32)
#define VideoThumbnailWidth  [UIScreen mainScreen].bounds.size.width-20
#define VideoThumbnailHeight [UIScreen mainScreen].bounds.size.height/2-64


@interface UIPlayViewController ()<UIWebViewDelegate>

@property (nonatomic,copy)NSString *jsString;
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@end



@implementation UIPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setWebviewAttribute];
    
    NSString *encodedURL=[_videoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *youkuId = [self getYoukuVideoIdByUrl:encodedURL];
    
    NSString *js1 = @"<div id=\"youkuplayer\" style=\"border:solid 1px #00;padding:1px;position:relative;left:%fpx;top:%fpx;width:%fpx;height:%fpx\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\"></script><script type=\"text/javascript\">player = new YKU.Player('youkuplayer',{styleid: '0',client_id: '4895c55cc6766e84',vid: '%@',autoplay: true,newPlayer: true,events:{onPlayerReady: function(){location.href=\"ios:onPlayerReady\";},onPlayStart: function(){ location.href=\"ios:onPlayerStart\"; },onPlayEnd: function(){window.location.href=\"ios:onPlayerEnd\"; }}});function playVideo(){player.playVideo();}function pauseVideo(){player.pauseVideo();}</script>";

    
    self.jsString = [NSString stringWithFormat:js1,XPosition, YPosition,VideoThumbnailWidth,VideoThumbnailHeight,youkuId];
    
    [self.videoWebView loadHTMLString:self.jsString baseURL:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setVideoWebView:nil];
    [self.videoWebView loadHTMLString:@"" baseURL: nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)setWebviewAttribute
{
    self.videoWebView.delegate = self;
    self.videoWebView.opaque = NO; //不设置这个值 页面背景始终是白色
    self.videoWebView.backgroundColor = [UIColor blackColor];
    [self.videoWebView setScalesPageToFit:NO];
}

/** 截取出优酷视频的id*/
-(NSString *)getYoukuVideoIdByUrl:(NSString *)videourl
{
    if (videourl != nil && ![videourl isEqualToString:@""]) {
        NSString *youkuId;
        NSArray *firSep = [videourl componentsSeparatedByString:@"id_"];
        if ([firSep count] > 0 && firSep != nil)
        {
            NSArray *secSep = [[firSep lastObject] componentsSeparatedByString:@"."];
            if ([secSep count] >0 && secSep != nil)
            {
                youkuId = [secSep firstObject];
            }
        }
        return youkuId;
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"视频连接异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
        [alert show];
        
        return @"";
    }
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#0E0E0E'"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    if ([request.URL.absoluteString isEqualToString:@"ios:onPlayerReady"]) {
        if(![[NSString getNetWorkStates] isEqualToString:@"wifi"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您当前非WiFi环境是否使用流量继续播放?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"继续播放", nil];
            [alert show];
            [alert clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [webView stringByEvaluatingJavaScriptFromString:@"playVideo();"];
                }
            }];
        }
        else
        {
            [webView stringByEvaluatingJavaScriptFromString:@"playVideo();"];
        }
        
        return NO;
    }
    else if([request.URL.absoluteString isEqualToString:@"ios:onPlayerEnd"])
    {
        NSLog(@"ios:onPlayerEnd");
    }
    
    return YES;
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    if (self.navigationController.navigationBar.frame.origin.y == 0) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);//在播放器横屏后，会出现导航条上移，和状态栏叠加，+20,状态栏就能显示了
      
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        
    }
    return NO;
}
@end


