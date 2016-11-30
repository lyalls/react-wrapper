//
//  UIChatViewController.m
//  BaoCai
//
//  Created by baocai on 16/8/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIChatViewController.h"

@interface UIChatViewController ()

@end

@implementation UIChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BackViewColor;
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.title = @"在线客服";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTargetHandler:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.showRefreshHeader = YES;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView removeItematIndex:1];
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
