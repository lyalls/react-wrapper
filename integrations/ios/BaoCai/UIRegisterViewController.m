//
//  UIRegisterViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIRegisterViewController.h"

#import "UIRegisterNextViewController.h"

#import "LoginRegisterRequest.h"

#import "TTTAttributedLabel.h"

@interface UIRegisterViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verfiyTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *getVerfiyBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *protocolLabel;

@end

@implementation UIRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    
    self.nextBtn.layer.cornerRadius = 4;
    
    [self.getVerfiyBtn setBorder:RGB_COLOR(255, 108, 0) width:0.5];
    self.getVerfiyBtn.layer.cornerRadius = 4;
    
    self.protocolLabel.delegate = self;
    self.protocolLabel.textColor = RGB_COLOR(153, 153, 153);
    self.protocolLabel.font = [UIFont systemFontOfSize:14.0f];
    self.protocolLabel.linkAttributes =[NSDictionary dictionaryWithObjectsAndKeys:RGB_COLOR(0, 122, 255), (__bridge NSString *)kCTForegroundColorAttributeName, nil];
    self.protocolLabel.text = [NSString stringWithFormat:@"同意《抱财注册协议》"];
    NSRange range = [self.protocolLabel.text rangeOfString:@"《抱财注册协议》"];
    [self.protocolLabel addLinkToURL:[@"asdf" toURL] withRange:range];
    [self.protocolLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getVerfiyBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *phoneNum = self.phoneNumTextField.text;
    
    if (phoneNum.length == 0) {
        SHOWTOAST(@"请输入手机号码");
        [self.phoneNumTextField becomeFirstResponder];
        return;
    }
    
    if (![phoneNum onValiMobile]) {
        SHOWTOAST(@"请输入正确手机号码");
        [self.phoneNumTextField becomeFirstResponder];
        return;
    }
    
    SHOWPROGRESSHUD;
    
    [LoginRegisterRequest registerSendMessageOneWithPhoneNum:phoneNum success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            NSString *sign = [dic objectForKey:@"sign"];
            sign = [[NSString stringWithFormat:@"%@%@", sign, phoneNum] sha1];
            [LoginRegisterRequest registerSendMessageTwoWithPhoneNum:phoneNum withSign:sign success:^(NSDictionary *dic, BCError *error) {
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

- (IBAction)checkBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *verfiyStr = self.verfiyTextField.text;
    
    if (verfiyStr.length == 0) {
        SHOWTOAST(@"请输入验证码");
        return;
    }
    
    if (!self.checkBtn.selected) {
        SHOWTOAST(@"请同意注册协议");
        return;
    }
    
    SHOWPROGRESSHUD;
    [LoginRegisterRequest registerCheckVerfiyCodeWithPhoneNum:self.phoneNumTextField.text codeStr:verfiyStr success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            UIStoryboard *loginRegisterStoryboard = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
            
            UIRegisterNextViewController *view = [loginRegisterStoryboard instantiateViewControllerWithIdentifier:@"UIRegisterNextViewController"];
            view.phoneNum = self.phoneNumTextField.text;
            view.verfiyCodeStr = [dic objectForKey:@"vcode"];
            [self.navigationController pushViewController:view animated:YES];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneNumTextField) {
        [self getVerfiyBtnClick:nil];
    }
    if (textField == self.verfiyTextField) {
        [self nextBtnClick:nil];
    }
    return YES;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (url) {
        SHOWPROGRESSHUD;
		[LoginRegisterRequest getRegisterProtocolWithSuccess:^(NSDictionary *dic, BCError *error) {
            HIDDENPROGRESSHUD;
            if (error.code == 0) {
                [self openWebBrowserWithUrl:[dic objectForKey:@"protocolUrl"]];
            } else {
                SHOWTOAST([dic objectForKey:@"message"]);
            }
        } failure:^(NSError *error) {
            HIDDENPROGRESSHUD;
            SHOWTOAST(@"注册协议获取失败，请稍后再试");
        }];
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
