//
//  UITicketExchangeViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/24.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITicketExchangeViewController.h"

#import "MyRequest.h"

@interface UITicketExchangeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation UITicketExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    
    self.doneBtn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *codeStr = self.codeTextField.text;
    
    if (codeStr.length == 0) {
        SHOWTOAST(@"请输入兑换码");
        return;
    }
    
    SHOWPROGRESSHUD;
    [MyRequest exchangeTicketWithCode:codeStr success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            SHOWTOAST(@"兑换成功");
            [self backBtnClick:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTicketNotification object:nil];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"实名认证失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.codeTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
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
    
    if (indexPath.row == 2) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

@end
