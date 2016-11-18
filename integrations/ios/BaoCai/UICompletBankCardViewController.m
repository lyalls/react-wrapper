//
//  UICompletBankCardViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UICompletBankCardViewController.h"

#import "UIWithdrawalsViewController.h"
#import "UIPickerViewController.h"

#import "MyRequest.h"

#import "NSString+Valid.h"

@interface UICompletBankCardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankLocationLabel;
@property (nonatomic, strong) NSDictionary *bankProvinceDic;
@property (nonatomic, strong) NSDictionary *bankCityDic;
@property (weak, nonatomic) IBOutlet UITextField *bankAccountTextField;

@end

@implementation UICompletBankCardViewController

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
    
    SHOWPROGRESSHUD;
    [MyRequest getCompletBankCardInfoWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            self.bankNameLabel.text = [dic objectForKey:@"bankName"];
            self.bankCardIdLabel.text = [dic objectForKey:@"cardNumber"];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"获取银行卡数据异常，请稍后再试");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *addressStr = self.bankAccountTextField.text;
    
    if (!self.bankProvinceDic) {
        SHOWTOAST(@"请选择开户行所在地");
        return;
    }
    if (!self.bankProvinceDic) {
        SHOWTOAST(@"请选择开户行所在地");
        return;
    }
    if (addressStr.length == 0) {
        SHOWTOAST(@"请输入开户行地址");
        return;
    }
    
    if (![addressStr isChinese]) {
        SHOWTOAST(@"开户行地址只能为中文");
        return;
    }
    
    SHOWPROGRESSHUD;
    [MyRequest withdrawalsSupplyBankCardWithAddress:addressStr provinceId:[self.bankProvinceDic objectForKey:@"provinceId"] cityId:[self.bankCityDic objectForKey:@"cityId"] success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            SHOWTOAST(@"绑定银行卡成功");
            UIWithdrawalsViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIWithdrawalsViewController"];
            view.isAddCard = YES;
            [self.navigationController pushViewController:view animated:YES];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"绑定银行卡失败，请稍后再试");
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.bankAccountTextField) {
        [self doneBtnClick:nil];
    }
    return YES;
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
    
    if (indexPath.row == 5) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        UIPickerViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIPickerViewController"];
        viewController.displayType = PickerDisplayTypeAreaList;
        viewController.doneBlock = ^(NSMutableArray *selectArray) {
            self.bankLocationLabel.text = [NSString stringWithFormat:@"%@  %@", [[selectArray objectAtIndex:0] objectForKey:@"provinceName"], [[selectArray objectAtIndex:1] objectForKey:@"cityName"]];
            
            self.bankProvinceDic = [selectArray objectAtIndex:0];
            self.bankCityDic = [selectArray objectAtIndex:1];
        };
        [self presentTranslucentViewController:viewController animated:YES];
    }
}

@end
