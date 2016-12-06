//
//  UIHomeTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIHomeTableViewController.h"

@interface UIHomeTableViewController ()

@end

@implementation UIHomeTableViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载 H5 页面
    if([[self class] copySrcToDoc]){
        [self setReq:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self class] componentIndex: @"home"]]]];
    }else{
        NSLog(@"Can't load component: [%@]", @"home");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick event:@"home_ui" label:@"首页"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"home_ui" label:@"首页"];
}

@end
