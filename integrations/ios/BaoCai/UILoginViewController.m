//
//  UILoginViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UILoginViewController.h"

#import "UIGesturePwdViewController.h"
#import "UIBindPhoneViewController.h"
#import "AppDelegate.h"

#import "LoginRegisterRequest.h"

#import "UserInfoModel.h"

@interface UILoginViewController () <UITextFieldDelegate, UIGesturePwdDelegate>
{
    loginCallback _logincall;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) NSMutableDictionary *userInfoDic;

@end

@implementation UILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.loginBtn.layer.cornerRadius = 4;
    
    [self setupForDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}

//打开登录
-(void) show:(UIViewController*)parent callback:(loginCallback)callback
{
    _logincall = callback;
    [parent presentViewController:self.navigationController animated:YES completion:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.scrollViewHeightConstraint.constant = Screen_height - 64;
}

#pragma mark - Custom method

- (IBAction)closeBtnClick:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] removeObserver:appDelegate name:LoginSuccessNotification object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(_logincall)
        {
            _logincall(NO);
        }
    }];
    
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

- (IBAction)loginBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (username.length == 0) {
        SHOWTOAST(@"请输入手机号或用户名");
        return;
    }
    if (password.length == 0) {
        SHOWTOAST(@"请输入登录密码");
        return;
    }
    
    SHOWPROGRESSHUD;
    [LoginRegisterRequest loginRequestWithUsername:username password:password success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [UserDefaultsHelper sharedManager].isShow401Alert = YES;
            [UserDefaultsHelper sharedManager].isShowMoney = YES;
            _userInfoDic = [[dic JSONString] mutableObjectFromJSONString];
            
            if ([_userInfoDic stringForKey:@"phone"].length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未绑定手机号，请先绑定手机号" delegate:nil cancelButtonTitle:@"立即绑定" otherButtonTitles:nil, nil];
                [alert show];
                [alert clickedButtonEvent:^(NSInteger buttonIndex) {
                    [[UserDefaultsHelper sharedManager] setTemporaryToken:[_userInfoDic objectForKey:@"token"]];
                    UIBindPhoneViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIBindPhoneViewController"];
                    view.userInfoDic = dic;
                    view.block = ^(NSString *phoneNum) {
                        [[UserDefaultsHelper sharedManager] setTemporaryToken:nil];
                        [_userInfoDic setObject:phoneNum forKey:@"phone"];
                        
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [appDelegate showSetPwd:self userinfo:self.userInfoDic callback:^{
                            [[UserDefaultsHelper sharedManager] setUserInfo:self.userInfoDic];
                            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
                            [self dismissViewControllerAnimated:NO completion:^{
                                [self dismissViewControllerAnimated:YES completion:^{
                                    if(_logincall)
                                    {
                                        _logincall(YES);
                                    }
                                }];
                            }];
                        }];
                    };
                    [self.navigationController pushViewController:view animated:YES];
                }];
            } else {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate showSetPwd:self userinfo:self.userInfoDic callback:^{
                    [[UserDefaultsHelper sharedManager] setUserInfo:self.userInfoDic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            if(_logincall)
                            {
                                _logincall(YES);
                            }
                        }];
                    }];
                }];
            }
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"登录失败，请稍后再试");
    }];
}

#pragma mark - NSNotificationCenter

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0, 122) animated:YES];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    if (textField == self.passwordTextField) {
        [self loginBtnClick:nil];
    }
    return YES;
}

#pragma mark - UIGesturePwdDelegate

@end
