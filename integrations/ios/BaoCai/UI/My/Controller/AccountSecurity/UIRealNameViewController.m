//
//  UIRealNameViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIRealNameViewController.h"

#import "UserRequest.h"
#import "LoginRegisterRequest.h"

@interface UIRealNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;

@end

@implementation UIRealNameViewController

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [LoginRegisterRequest refreshTokenWithSuccess:nil failure:nil];
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *realName = self.realNameTextField.text;
    NSString *idCard = self.idCardTextField.text;
    
    if (realName.length == 0) {
        SHOWTOAST(@"请输入您的姓名");
        return;
    }
    if (idCard.length == 0) {
        SHOWTOAST(@"请输入您的身份证号");
        return;
    }
    if (![idCard onValidateIDCardNumber]) {
        SHOWTOAST(@"您输入的身份证不正确");
        return;
    }
    
    SHOWPROGRESSHUD;
    [UserRequest userRealNameAuthenticationWithRealName:realName idCard:idCard success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            SHOWTOAST(@"已提交实名认证信息");
            [self backBtnClick:nil];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"实名认证失败，请稍后再试");
    }];
}

- (IBAction)telBtnClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要拨打\r\n400-616-7070" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alertView show];
    [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[@"tel://4006167070" toURL]];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.realNameTextField) {
        [self.idCardTextField becomeFirstResponder];
    }
    if (textField == self.idCardTextField) {
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
