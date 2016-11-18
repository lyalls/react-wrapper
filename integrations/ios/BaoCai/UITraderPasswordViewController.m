//
//  UITraderPasswordViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITraderPasswordViewController.h"

#import "TenderRequest.h"

@interface UITraderPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewBottomConstraint;

@end

@implementation UITraderPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.inputBackView setBorder:RGB_COLOR(242, 242, 242) width:0.6];
    self.inputBackView.layer.cornerRadius = 4;
    self.doneBtn.layer.cornerRadius = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.passwordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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

- (IBAction)doneBtnClick:(id)sender {
    NSString *password = self.passwordTextField.text;
    if (password.length == 0) {
        SHOWTOAST(@"请输入交易密码");
        return;
    }
    
    SHOWPROGRESSHUD;
    [TenderRequest payTenderWithTenderId:self.itemModel.tenderId borrowAmount:self.borrowAmount bonusId:self.bonusId increaseId:self.increaseId payPassword:self.passwordTextField.text paySecond:NO activityCode:self.activityCode success:^(NSDictionary *dic, BCError *error) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [MobClick event:@"investment_genre1_ui_invest_ui_result_for_success" label:@"散标投资页_投资按钮_结果_投资成功"];
            if (self.paySuccess)
                self.paySuccess(dic);
        } else if (error.code == 4001 || error.code == 4003) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    if (self.cancelRecharge) {
                        self.cancelRecharge();
                    }
                } else if (buttonIndex == 1) {
                    if (self.toRecharge) {
                        self.toRecharge();
                    }
                }
            }];
        } else if (error.code == 5001) {
            [MobClick event:@"investment_genre1_ui_invest_ui_result_for_failure" label:@"散标投资页_投资按钮_结果_投资失败"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    if (self.backTenderList) {
                        self.backTenderList();
                    }
                }
            }];
        } else if (error.code == 4004) {
            [MobClick event:@"investment_genre1_ui_invest_ui_result_for_donotmatch" label:@"散标投资页_投资按钮_结果_优惠券不匹配"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    if (self.backTenderDetail) {
                        self.backTenderDetail();
                    }
                }
            }];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"验证交易密码失败，请稍后再试");
    }];
}

- (IBAction)fotgetPasswordBtnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
}

#pragma mark - NSNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.topViewBottomConstraint.constant = endFrame.size.height;
    [self.view setNeedsUpdateConstraints];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
