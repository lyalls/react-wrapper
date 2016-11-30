//
//  UIWebBrowserViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIWebBrowserViewController.h"

#import "UIShareViewController.h"

#import "UIViewController+WebView.h"

@interface UIWebBrowserViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation UIWebBrowserViewController

- (void)loadView {
    [super loadView];
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.webView addSubview:self.loadingView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadRequest:[self getWebBrowserRequestWithUrl:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    NSString *backStr = [self.webView stringByEvaluatingJavaScriptFromString:@"clientBack()"];
    if (![backStr isEqualToString:@"true"]) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *webUrl = request.mainDocumentURL.relativeString;
    return [self handelWebBrowserJsonMethod:webUrl inviteFriendsModel:self.inviteFirends];
}

@end
