//
//  UIResetTraderPasswordViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/13.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIResetTraderPasswordViewController.h"

#import "UserRequest.h"

@interface UIResetTraderPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, assign) BOOL isShowPrompt;

@end

@implementation UIResetTraderPasswordViewController

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
    
    NSString *password = self.passwordTextField.text;
    NSString *rePassword = self.rePasswordTextField.text;
    
    if (password.length == 0) {
        SHOWTOAST(@"请输入交易密码");
        return;
    }
    if (rePassword.length == 0) {
        SHOWTOAST(@"请再次输入交易密码");
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
    [UserRequest retrieveTraderPasswordSetPasswordWithPhoneNum:self.phoneNum withPasswrod:password vcode:self.vcode success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *view = [self.navigationController.viewControllers objectAtIndex:index - 3];
            [self.navigationController popToViewController:view animated:YES];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"设置交易密码失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
        if (self.isShowPrompt) {
            return 30;
        } else {
            return 0;
        }
    } else if (indexPath.row == 4) {
        return 104;
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

@end
