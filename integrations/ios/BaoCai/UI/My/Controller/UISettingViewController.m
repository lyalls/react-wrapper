//
//  UISettingViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UISettingViewController.h"

#import "UIGesturePwdViewController.h"
#import "UIAboutTableViewController.h"
#import "UIShareViewController.h"
#import "AppDelegate.h"
#import "MyRequest.h"

@interface UISettingViewController () <UIGesturePwdDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UISwitch *gesturePwdSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promptImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionConstraint;

@end

@implementation UISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.logoutBtn.layer.cornerRadius = 4;
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.gesturePwdSwitch setOn:[UserDefaultsHelper sharedManager].gesturePwd.length != 0 animated:YES];
    
    if ([UserDefaultsHelper sharedManager].isNewVersion == NO) {
        self.versionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.versionCell.accessoryType = UITableViewCellAccessoryNone;
        self.titleLabel.text = @"版本号";
        self.promptImageView.hidden = YES;
        self.versionLabel.text = [NSString stringWithFormat:@"V%@", SHORTVERSION];
        self.versionConstraint.constant = 15;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutBtnClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登录吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
            [self logoutMethod];
    }];
}

- (IBAction)gesturePwdSwitchChangeValue:(id)sender {
    if (self.gesturePwdSwitch.isOn) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showSetPwd:self userinfo:nil callback:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要关闭手势密码？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.gesturePwdSwitch setOn:NO animated:YES];
                [UserDefaultsHelper sharedManager].gesturePwd = nil;
            } else {
                [self.gesturePwdSwitch setOn:YES animated:YES];
            }
        }];
    }
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
    
    if (indexPath.row == 8) {
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
        [MobClick event:@"my_ui_set_ui_telephone" label:@"设置_客服热线"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要拨打\r\n400-616-7070" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alertView show];
        [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[@"tel://4006167070" toURL]];
            }
        }];
    }
    if (indexPath.row == 5) {
        [MobClick event:@"my_ui_set_ui_share" label:@"设置_分享好友"];
        SHOWPROGRESSHUD;
        [MyRequest getMySettingShareWithSuccess:^(NSDictionary *dic, BCError *error) {
            HIDDENPROGRESSHUD;
            if (error.code == 0) {
                UIShareViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIShareViewController"];
                view.shareDic = dic;
                [self presentTranslucentViewController:view animated:YES];
            } else {
                SHOWTOAST(error.message);
            }
        } failure:^(NSError *error) {
            HIDDENPROGRESSHUD;
        }];
    }
    if (indexPath.row == 6) {
        [MobClick event:@"my_ui_set_ui_about" label:@"设置_关于我们"];
        UIAboutTableViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIAboutTableViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.row == 7) {
        if ([UserDefaultsHelper sharedManager].isNewVersion) {
            [[UIApplication sharedApplication] openURL:[@"https://itunes.apple.com/cn/app/baocai/id979125472?mt=8?t=1476703509" toURL]];
        }
    }
}

#pragma mark - UMSocialUIDelegate

@end
