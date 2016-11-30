//
//  UIAccountSecurityViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIAccountSecurityViewController.h"

#import "UIRealNameViewController.h"
#import "UISetTraderPasswordViewController.h"
#import "UISetPasswordViewController.h"

#import "BCDefaultTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import "MyRequest.h"
#import "LoginRegisterRequest.h"

@interface UIAccountSecurityViewController ()

@end

@implementation UIAccountSecurityViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"账户安全";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellWithClass:[BCDefaultTableViewCell class]];
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LoginRegisterRequest refreshTokenWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        BCDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCDefaultTableViewCell class]) forIndexPath:indexPath];
        
        if (indexPath.row == 1) {
            [cell reloadCellWithIconUrl:nil title:@"实名认证" detail:[UserInfoModel sharedModel].cardID];
            
            if ([UserInfoModel sharedModel].realNameAuth) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
    		
            if ([[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2) {
                cell.detailLabel.textColor = Color999999;
            } else {
                cell.detailLabel.textColor = OrangeColor;
            }
        } else if (indexPath.row == 2) {
            NSString *phoneStr = [UserInfoModel sharedModel].phone;
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [cell reloadCellWithIconUrl:nil title:@"手机绑定" detail:phoneStr];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *detailStr = @"";
            if ([UserInfoModel sharedModel].isSetPayPassword) {
                detailStr = @"修改";
            } else {
                detailStr = @"未设置";
            }
            [cell reloadCellWithIconUrl:nil title:@"交易密码" detail:detailStr];
            
            if ([UserInfoModel sharedModel].isSetPayPassword) {
                cell.detailLabel.textColor = Color999999;
            } else {
                cell.detailLabel.textColor = OrangeColor;
            }
        } else if (indexPath.row == 6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell reloadCellWithIconUrl:nil title:@"登录密码" detail:@"修改"];
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        return 10;
    } else {
        return 50;
    }
}

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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        
    } else {
        if (indexPath.row == 1) {
            if (![UserInfoModel sharedModel].realNameAuth) {
                UIRealNameViewController *viewController = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UIRealNameViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        } else if (indexPath.row == 2) {
            //bind phone num
        } else if (indexPath.row == 4) {
            UISetTraderPasswordViewController *viewController = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UISetTraderPasswordViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (indexPath.row == 6) {
            UISetPasswordViewController *viewController = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UISetPasswordViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
