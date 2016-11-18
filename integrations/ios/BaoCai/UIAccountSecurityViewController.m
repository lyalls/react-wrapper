//
//  UIAccountSecurityViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIAccountSecurityViewController.h"

#import "MyRequest.h"
#import "LoginRegisterRequest.h"

@interface UIAccountSecurityViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *bindCardIdTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *bindPhoneTableViewCell;

@property (weak, nonatomic) IBOutlet UILabel *cardIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tarderStatusLabel;

@end

@implementation UIAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if ([UserInfoModel sharedModel].realNameAuth) {
        self.bindCardIdTableViewCell.accessoryType = UITableViewCellAccessoryNone;
        self.bindCardIdTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.bindCardIdTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.bindCardIdTableViewCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    self.cardIdLabel.text = [UserInfoModel sharedModel].cardID;
    if ([[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2) {
        self.cardIdLabel.textColor = RGB_COLOR(153, 153, 153);
    } else {
        self.cardIdLabel.textColor = OrangeColor;
    }
    
    self.bindPhoneTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    self.bindPhoneTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *phoneStr = [UserInfoModel sharedModel].phone;
    phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneNumLabel.text = phoneStr;
    
    if ([UserInfoModel sharedModel].isSetPayPassword) {
        self.tarderStatusLabel.text = @"修改";
        self.tarderStatusLabel.textColor = RGB_COLOR(153, 153, 153);
    } else {
        self.tarderStatusLabel.text = @"未设置";
        self.tarderStatusLabel.textColor = OrangeColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LoginRegisterRequest refreshTokenWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if ([UserInfoModel sharedModel].realNameAuth) {
                self.bindCardIdTableViewCell.accessoryType = UITableViewCellAccessoryNone;
                self.bindCardIdTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                self.bindCardIdTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.bindCardIdTableViewCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            self.cardIdLabel.text = [UserInfoModel sharedModel].cardID;
            if ([[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2) {
                self.cardIdLabel.textColor = RGB_COLOR(153, 153, 153);
            } else {
                self.cardIdLabel.textColor = OrangeColor;
            }
            
            self.bindPhoneTableViewCell.accessoryType = UITableViewCellAccessoryNone;
            self.bindPhoneTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *phoneStr = [UserInfoModel sharedModel].phone;
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.phoneNumLabel.text = phoneStr;
            
            if ([UserInfoModel sharedModel].isSetPayPassword) {
                self.tarderStatusLabel.text = @"修改";
                self.tarderStatusLabel.textColor = RGB_COLOR(153, 153, 153);
            } else {
                self.tarderStatusLabel.text = @"未设置";
                self.tarderStatusLabel.textColor = OrangeColor;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"toRealNameViewController"]) {
        if ([UserInfoModel sharedModel].realNameAuth) {
            return NO;
        }
    }
    return YES;
}

@end
