//
//  UIRechargeViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIRechargeViewController.h"

#import "UIRechargeResultViewController.h"

#import "MyRequest.h"

#import "UIRechargeRecordViewController.h"

@interface UIRechargeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *rechargeTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end

@implementation UIRechargeViewController

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
    
    self.bankNameLabel.text = self.model.bankName;
    self.cardNumLabel.text = [NSString stringWithFormat:@"尾号%@", self.model.cardNo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordBtnClick:(id)sender {
    UIRechargeRecordViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIRechargeRecordViewController"];
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

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *rechargeStr = self.rechargeTextField.text;
    
    if (rechargeStr.length == 0) {
        SHOWTOAST(@"请输入充值金额");
        return;
    }
    SHOWPROGRESSHUD;
    [MyRequest rechargeWithAmount:rechargeStr withCardNum:self.model.cardNo withNoAgree:self.model.noAgree success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            UIRechargeResultViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIRechargeResultViewController"];
            viewController.rechargeAmount = rechargeStr;
            viewController.orderDic = dic;
            viewController.cardNum = nil;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"充值失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.rechargeTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.rechargeTextField) {
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
    
    if (indexPath.row == 3) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

@end
