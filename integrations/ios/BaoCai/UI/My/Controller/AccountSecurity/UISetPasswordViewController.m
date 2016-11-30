//
//  UISetPasswordViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UISetPasswordViewController.h"

#import "UserRequest.h"

@interface UISetPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, assign) BOOL isShowPrompt;

@end

@implementation UISetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    
    self.doneBtn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *rePassword = self.rePasswordTextField.text;
    
    if (oldPassword.length == 0) {
        SHOWTOAST(@"请输入当前登录密码");
        return;
    }
    if (password.length == 0) {
        SHOWTOAST(@"请输入新登录密码");
        return;
    }
    if (rePassword.length == 0) {
        SHOWTOAST(@"请输入重复的新登录密码");
        return;
    }
    if (![password isEqualToString:rePassword]) {
        SHOWTOAST(@"两次密码输入不一致，请重新输入");
        return;
    }
    
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,16}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![passwordTest evaluateWithObject:password]) {
        SHOWTOAST(@"长度在6-16位英文、数字或下划线组合");
        return;
    }
    
    SHOWPROGRESSHUD;
    [UserRequest userModifyPasswordWithOldPassword:oldPassword password:password rePassword:rePassword success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            SHOWTOAST(@"修改登录密码成功");
            [self backBtnClick:nil];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"修改登录密码失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswordTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    if (textField == self.passwordTextField) {
        [self.rePasswordTextField becomeFirstResponder];
    }
    if (textField == self.rePasswordTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        self.isShowPrompt = YES;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        self.isShowPrompt = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 10;
    } else if (indexPath.row == 2) {
        return 10;
    } else if (indexPath.row == 4) {
        if (self.isShowPrompt) {
            return 30;
        } else {
            return 10;
        }
    } else if (indexPath.row == 6) {
        return 64;
    }
    return 50;
}

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
    
    if (indexPath.row == 6) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

@end
