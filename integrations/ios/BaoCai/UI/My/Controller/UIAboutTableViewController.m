//
//  UIAboutTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/8/2.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIAboutTableViewController.h"

@interface UIAboutTableViewController ()

@end

@implementation UIAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要拨打电话400-616-7070" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alertView show];
        [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[@"tel://4006167070" toURL]];
            }
        }];
    }
    if (indexPath.row == 3) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"vbaocai";
        SHOWTOAST(@"已复制到剪切板");
    }
    if (indexPath.row == 5) {
        [[UIApplication sharedApplication] openURL:[@"https://m.baocai.com" toURL]];
    }
}

@end
