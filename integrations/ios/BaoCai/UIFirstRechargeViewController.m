//
//  UIFirstRechargeViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIFirstRechargeViewController.h"

#import "UIRechargeResultViewController.h"

#import "MyRequest.h"

@interface UIFirstRechargeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *rechargeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UILabel *supportBankDescLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supportBankDescLabelHeightConstraint;

@end

@implementation UIFirstRechargeViewController

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
    
    self.realNameLabel.text = self.model.realname;
    self.idCardLabel.text = self.model.cardId;
    
    NSMutableArray *bankNameArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in [UserDefaultsHelper sharedManager].bankSupportList) {
        [bankNameArray addObject:[dic objectForKey:@"bankname"]];
    }
    
    self.supportBankDescLabel.text = [NSString stringWithFormat:@"目前支持绑卡的银行有%@。", [bankNameArray componentsJoinedByString:@"、"]];
    
    CGRect frame = [self.supportBankDescLabel.text boundingRectWithSize:CGSizeMake(Screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
    self.supportBankDescLabelHeightConstraint.constant = frame.size.height + 20;
    
    //    self.supportBankDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //    [self.supportBankDescLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)explainBtnClick:(id)sender {
    if (self.model.payHelp)
        [self openWebBrowserWithUrl:self.model.payHelp];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *rechargeStr = self.rechargeTextField.text;
    NSString *cardNumStr = self.cardNumTextField.text;
    
    if (rechargeStr.length == 0) {
        SHOWTOAST(@"请输入充值金额");
        return;
    }
    
    if (cardNumStr.length == 0) {
        SHOWTOAST(@"请输入银行卡号");
        return;
    }
    
    SHOWPROGRESSHUD;
    [MyRequest checkRechargeBankCardNumWithCardNum:cardNumStr success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if ([dic boolForKey:@"type"]) {
                NSDictionary *list = [dic objectForKey:@"list"];
                if ([list boolForKey:@"bankUse"]) {
                    [MyRequest rechargeWithAmount:rechargeStr withCardNum:cardNumStr withNoAgree:@"" success:^(NSDictionary *dic, BCError *error) {
                        HIDDENPROGRESSHUD;
                        if (error.code == 0) {
                            UIRechargeResultViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIRechargeResultViewController"];
                            viewController.rechargeAmount = rechargeStr;
                            viewController.orderDic = dic;
                            viewController.cardNum = cardNumStr;
                            [self.navigationController pushViewController:viewController animated:YES];
                        } else {
                            SHOWTOAST(error.message);
                        }
                    } failure:^(NSError *error) {
                        HIDDENPROGRESSHUD;
                        SHOWTOAST(@"充值失败，请稍后再试");
                    }];
                } else {
                    HIDDENPROGRESSHUD;
                    SHOWTOAST(@"手机暂不支持此银行，请更换其他银行");
                }
            } else {
                HIDDENPROGRESSHUD;
                SHOWTOAST(error.message);
            }
        } else {
            HIDDENPROGRESSHUD;
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
        [self.cardNumTextField becomeFirstResponder];
    }
    if (textField == self.cardNumTextField) {
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
