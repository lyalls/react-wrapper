//
//  UIRegisterNextViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIRegisterNextViewController.h"

#import "UIGesturePwdViewController.h"
#import "AppDelegate.h"
#import "LoginRegisterRequest.h"

@interface UIRegisterNextViewController () <UITextFieldDelegate, UIGesturePwdDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, assign) BOOL isShowPrompt;
@property (nonatomic, strong) NSDictionary *userInfoDic;

@end

@implementation UIRegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    
    self.nextBtn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showOrHideBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.passwordTextField.secureTextEntry = YES;
    } else {
        btn.selected = YES;
        self.passwordTextField.secureTextEntry = NO;
    }
}

- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *password = self.passwordTextField.text;
    
    if (password.length == 0) {
        SHOWTOAST(@"请输入登录密码");
        return;
    }
    
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,16}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![passwordTest evaluateWithObject:password]) {
        SHOWTOAST(@"长度在6-16位英文、数字或下划线组合");
        return;
    }
    
    SHOWPROGRESSHUD;
    [LoginRegisterRequest registerSetPasswordWithPhone:self.phoneNum password:password invitationCode:self.invitationCodeTextField.text verfiyCode:self.verfiyCodeStr success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [UserDefaultsHelper sharedManager].isShow401Alert = YES;
            [UserDefaultsHelper sharedManager].isShowMoney = YES;
            _userInfoDic = [[dic JSONString] mutableObjectFromJSONString];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate showSetPwd:self userinfo:_userInfoDic callback:^{
                [[UserDefaultsHelper sharedManager] setUserInfo:self.userInfoDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:RegisterSuccessNotification object:nil];
                [self dismissViewControllerAnimated:NO completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"注册失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self nextBtnClick:nil];
    }
    if (textField == self.invitationCodeTextField) {
        [self nextBtnClick:nil];
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
        if (self.isShowPrompt) {
            return 30;
        } else {
            return 10;
        }
    } else if (indexPath.row == 4) {
        return 76;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 4) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

#pragma mark - UIGesturePwdDelegate


@end
