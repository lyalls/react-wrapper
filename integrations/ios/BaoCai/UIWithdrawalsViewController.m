//
//  UIWithdrawalsViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIWithdrawalsViewController.h"

#import "MyRequest.h"

#import "UIWithdrawalsRecordViewController.h"

@interface UIWithdrawalsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *getVerfiyBtn;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *verfiyTextField;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTextField;

@property (nonatomic, strong) NSString *phoneNum;

@end

@implementation UIWithdrawalsViewController

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
    
    [self.getVerfiyBtn setBorder:RGB_COLOR(255, 108, 0) width:0.5];
    self.getVerfiyBtn.layer.cornerRadius = 4;
    
    SHOWPROGRESSHUD;
    [MyRequest getWithdrawalsBankCardWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            _bankNameLabel.text = [dic objectForKey:@"bankName"];
            _bankCardLabel.text = [NSString stringWithFormat:@"尾号%@", [dic objectForKey:@"bankCard"]];
            _availableBalanceLabel.text = [dic objectForKey:@"availableBalance"];
            self.phoneNum = [dic objectForKey:@"phone"];
            _phoneNumLabel.text = [self.phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    if (self.isAddCard)
        [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordBtnClick:(id)sender {
    UIWithdrawalsRecordViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIWithdrawalsRecordViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)infoBtnClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"系统暂不支持解绑。如银行卡丢失，请拨打400-616-7070进行人工处理。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打客服电话", nil];
    [alertView show];
    [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[@"tel://4006167070" toURL]];
        }
    }];
}

- (IBAction)showOrHideBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        self.tradePasswordTextField.secureTextEntry = YES;
    } else {
        btn.selected = YES;
        self.tradePasswordTextField.secureTextEntry = NO;
    }
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *moneyStr = self.moneyTextField.text;
    NSString *verfiyStr = self.verfiyTextField.text;
    NSString *tardePasswordStr = self.tradePasswordTextField.text;
    
    if (moneyStr.length == 0) {
        SHOWTOAST(@"请输入提现金额");
        return;
    }
    if (moneyStr.intValue < 50) {
        SHOWTOAST(@"提现金额不能小于50元");
        return;
    }
    if (moneyStr.floatValue > self.availableBalanceLabel.text.floatValue) {
        SHOWTOAST(@"提现金额不足");
        return;
    }
    if (verfiyStr.length == 0) {
        SHOWTOAST(@"请输入验证码");
        return;
    }
    if (tardePasswordStr.length == 0) {
        SHOWTOAST(@"请输入交易密码");
        return;
    }
    
    SHOWPROGRESSHUD;
    [MyRequest withdrawalsCheckPasswordWithVerfiyCode:verfiyStr cashMoney:moneyStr payPassword:tardePasswordStr success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"申请提现成功，预计1-3工作日到账" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                [self backBtnClick:nil];
            }];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"提现失败，请稍后再试");
    }];
}

- (IBAction)getVerfiyBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *moneyStr = self.moneyTextField.text;
    
    if (moneyStr.length == 0) {
        SHOWTOAST(@"请输入提现金额");
        return;
    }
    if (moneyStr.intValue < 50) {
        SHOWTOAST(@"提现金额不能小于50元");
        return;
    }
    if (moneyStr.floatValue > self.availableBalanceLabel.text.floatValue) {
        SHOWTOAST(@"提现金额不足");
        return;
    }
    
    SHOWPROGRESSHUD;
    
    [MyRequest getWithdrawalsSendMessageOneWithPhoneNum:self.phoneNum success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            NSString *sign = [dic objectForKey:@"sign"];
            sign = [[NSString stringWithFormat:@"%@%@", sign, self.phoneNum] sha1];
            [MyRequest getWithdrawalsSendMessageTwoWithPhoneNum:self.phoneNum withSign:sign success:^(NSDictionary *dic, BCError *error) {
                HIDDENPROGRESSHUD;
                
                [_verfiyTextField becomeFirstResponder];
                if (error.code == 0) {
                    __block int timeout = 60; //倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
                    dispatch_source_set_event_handler(_timer, ^{
                        if(timeout <= 0){
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_getVerfiyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                                _getVerfiyBtn.userInteractionEnabled = YES;
                            });
                        } else {
                            int seconds = timeout % 60;
                            seconds = seconds == 0 ? 60 : seconds;
                            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_getVerfiyBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送", strTime] forState:UIControlStateNormal];
                                _getVerfiyBtn.userInteractionEnabled = NO;
                                
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_timer);
                } else {
                    HIDDENPROGRESSHUD;
                    
                    SHOWTOAST(error.message);
                }
            } failure:^(NSError *error) {
                HIDDENPROGRESSHUD;
                
                SHOWTOAST(@"验证码发送失败，请稍后再试");
            }];
        } else {
            HIDDENPROGRESSHUD;
            
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        
        SHOWTOAST(@"验证码发送失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.moneyTextField) {
        [self.verfiyTextField becomeFirstResponder];
    }
    if (textField == self.verfiyTextField) {
        [self.tradePasswordTextField becomeFirstResponder];
    }
    if (textField == self.tradePasswordTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.moneyTextField) {
        if ([textField.text length]) {
            textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
        }
    }
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 7) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

@end
