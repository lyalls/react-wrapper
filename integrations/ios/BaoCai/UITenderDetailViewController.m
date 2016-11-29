//
//  UITenderDetailViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITenderDetailViewController.h"

#import "UITenderProjectDetailViewController.h"
#import "UIInvestmentViewController.h"

#import "TenderDetailItemTableViewCell.h"
#import "EmptyTableViewCell.h"

#import "TenderDetailMenuModel.h"

#import "TenderRequest.h"

NSString *TenderDetailTopCell = @"TenderDetailTopCell";
NSString *TenderDetailEmptyCell = @"TenderDetailEmptyCell";

@interface UITenderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, strong) NSString *activityCode;

@property (nonatomic, assign) BOOL isLoadFinish;

@end

@implementation UITenderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellNibWithClass:[TenderDetailTableViewCell class]];
    [self.tableView registerCellNibWithClass:[TenderDetailItemTableViewCell class]];
    [self.tableView registerCellNibWithClass:[EmptyTableViewCell class]];
    
    self.doneBtn.userInteractionEnabled = NO;
    
    [self reloadTableView];
    
    SHOWPROGRESSHUD;
    [TenderRequest getTenderDetailWithTenderId:self.itemModel ? self.itemModel.tenderId : self.tenderId success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            if (!self.itemModel) {
                _itemModel = [[TenderItemModel alloc] initWithDic:dic];
            }
            [_itemModel reloadData:dic];
            
            self.isLoadFinish = YES;
            
            if (self.itemModel.tenderSchedule.integerValue == 100) {
                self.availableAmountLabel.hidden = NO;
                self.availableAmountLabel.text = [NSString stringWithFormat:@"剩余可投金额%@元", self.itemModel.availableAmount];
                [self.doneBtn setTitle:self.itemModel.statusMessage forState:UIControlStateNormal];
                self.doneBtn.backgroundColor = RGB_COLOR(204, 204, 204);
                self.doneBtn.userInteractionEnabled = NO;
            } else {
                NSInteger currentTimeInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
                //现在开标剩余时间 = 请求开标剩余时间 - (现在时间 - 请求时间)
                NSInteger limitTime = self.itemModel.limitTime.integerValue - (currentTimeInterval - self.itemModel.limitTimeInterval);
                if (self.itemModel.isLimit && limitTime > 0) {
                    self.availableAmountLabel.hidden = YES;
                    [self.doneBtn setTitle:@"即将发售" forState:UIControlStateNormal];
                    self.doneBtn.backgroundColor = RGB_COLOR(204, 204, 204);
                    self.doneBtn.userInteractionEnabled = NO;
                } else {
                    self.availableAmountLabel.hidden = NO;
                    if (self.itemModel.isFull && self.itemModel.isFullThreshold) {
                        self.availableAmountLabel.text = [NSString stringWithFormat:@"剩余可投金额%@元，最后一位投资可得奖励", self.itemModel.availableAmount];
                    } else {
                        self.availableAmountLabel.text = [NSString stringWithFormat:@"剩余可投金额%@元", self.itemModel.availableAmount];
                    }
                    if (self.itemModel.availableAmountCal.integerValue < self.itemModel.tenderMin.integerValue) {
                        NSString *string = [NSString stringWithFormat:@"投资%ld元", self.itemModel.availableAmountCal.integerValue];
                        [self.doneBtn setTitle:string forState:UIControlStateNormal];
                    } else if (self.itemModel.isFull && self.itemModel.isFullThreshold) {
                        [self.doneBtn setTitle:@"抢满标" forState:UIControlStateNormal];
                    } else if (self.itemModel.borrowType && [self.itemModel.borrowType isEqualToString:@"1"]) {
                        [self.doneBtn setTitle:@"新手投资" forState:UIControlStateNormal];
                    } else {
                        [self.doneBtn setTitle:@"立即投资" forState:UIControlStateNormal];
                    }
                    self.doneBtn.backgroundColor = [UIColor getColorWithRGBStr:self.itemModel.tenderTypeBorderColor];
                    self.doneBtn.userInteractionEnabled = YES;
                }
            }
            [self reloadTableView];
            
            if (self.itemModel.borrowType && [self.itemModel.borrowType isEqualToString:@"2"]) {
                if ([[UserDefaultsHelper sharedManager].activityCodeDic objectForKey:self.itemModel.tenderId]) {
                    self.activityCode = [[UserDefaultsHelper sharedManager].activityCodeDic objectForKey:self.itemModel.tenderId];
                    [self checkActivityCode];
                } else {
                    [self showActivityAlert];
                }
            }
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick event:@"detail_genre1_ui" label:@"散标详情页"];
    
    if (!self.isLoadFinish) return;
    if (self.itemModel.borrowType && [self.itemModel.borrowType isEqualToString:@"2"]) {
        if ([[UserDefaultsHelper sharedManager].activityCodeDic objectForKey:self.itemModel.tenderId]) {
            self.activityCode = [[UserDefaultsHelper sharedManager].activityCodeDic objectForKey:self.itemModel.tenderId];
            [self checkActivityCode];
        } else {
            [self showActivityAlert];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"detail_genre1_ui" label:@"散标详情页"];
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTableView {
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    if (self.itemModel) {
        [self.displayArray addObject:TenderDetailTopCell];
        
        NSMutableArray *array = [TenderDetailMenuModel getDataWithPurchaseNumber:self.itemModel.investPersonNum];
        
        for (NSUInteger i = 0; i < array.count; i++) {
            [self.displayArray addObject:[array objectAtIndex:i]];
            
            if (i != array.count - 1) {
                [self.displayArray addObject:TenderDetailEmptyCell];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (IBAction)immediateInvestmentBtnClick:(id)sender {
    [MobClick event:@"detail_genre1_ui_invest" label:@"散标详情页_投资按钮"];
    if ([UserInfoModel sharedModel].token) {
        if (self.itemModel.borrowType && [self.itemModel.borrowType isEqualToString:@"1"]) {
            SHOWPROGRESSHUD;
            [TenderRequest getUserIsNoviceWithSuccess:^(NSDictionary *dic, BCError *error) {
                HIDDENPROGRESSHUD;
                if (error.code == 0) {
                    if ([[dic objectForKey:@"userType"] isEqualToString:@"new"]) {
                        UIInvestmentViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIInvestmentViewController"];
                        view.itemModel = self.itemModel;
                        view.activityCode = self.activityCode;
                        [self.navigationController pushViewController:view animated:YES];
                    } else {
                        [MobClick event:@"detail_genre1_ui_invest_result_for_novice" label:@"散标详情页_投资按钮_仅限新手"];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"仅限新手用户投资" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                } else {
                    SHOWTOAST(error.message);
                }
            } failure:^(NSError *error) {
                HIDDENPROGRESSHUD;
            }];
        } else {
            UIInvestmentViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIInvestmentViewController"];
            view.itemModel = self.itemModel;
            view.activityCode = self.activityCode;
            [self.navigationController pushViewController:view animated:YES];
        }
    } else {
        [self toLoginViewController];
    }
}

- (void)showActivityAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"本投资项目为 “活动专享项目”" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *passwordField = [alertView textFieldAtIndex:0];
    passwordField.placeholder = @"请输入活动专享码";
    
    [alertView show];
    [alertView clickedButtonEventWithAlertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self.view endEditing:YES];
            [self backBtnClick:nil];
        } else {
            UITextField *pwdTextField = [alertView textFieldAtIndex:0];
            self.activityCode = pwdTextField.text;
            [self checkActivityCode];
        }
    }];
}

- (void)checkActivityCode {
    SHOWPROGRESSHUD;
    [TenderRequest checkTenderActivityCodeWithTenderId:self.itemModel.tenderId withActiveCode:self.activityCode success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            if (![dic boolForKey:@"result"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"专享码不匹配，请核对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                    [self showActivityAlert];
                }];
                NSMutableDictionary *dic = [[UserDefaultsHelper sharedManager].activityCodeDic mutableCopy];
                [dic removeObjectForKey:self.itemModel.tenderId];
                [[UserDefaultsHelper sharedManager] setActivityCodeDic:dic];
            } else {
                NSMutableDictionary *dic = [[UserDefaultsHelper sharedManager].activityCodeDic mutableCopy];
                [dic setObject:self.activityCode forKey:self.itemModel.tenderId];
                [UserDefaultsHelper sharedManager].activityCodeDic = dic;
            }
        } else {
            SHOWTOAST(error.message);
            [self showActivityAlert];
            self.activityCode = @"";
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"专享码验证失败，请稍后再试");
        [self showActivityAlert];
        self.activityCode = @"";
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        
        if ([cellName isEqualToString:TenderDetailTopCell]) {
            TenderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TenderDetailTableViewCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            
            [cell reloadData:self.itemModel];
            
            return cell;
        } else if ([cellName isEqualToString:TenderDetailEmptyCell]) {
            EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        TenderDetailItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TenderDetailItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:(TenderDetailMenuModel *)cellType];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        
        if ([cellName isEqualToString:TenderDetailTopCell]) {
            return 420;
        } else if ([cellName isEqualToString:TenderDetailEmptyCell]) {
            return 8;
        }
    } else {
        return 50;
    }
    return tableView.rowHeight;
}

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
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if (![cellType isKindOfClass:[NSString class]]) {
        TenderDetailMenuModel *model = (TenderDetailMenuModel *)cellType;
        
        UITenderProjectDetailViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITenderProjectDetailViewController"];
        view.itemModel = self.itemModel;
        if (model.pageNameType == PageNameTypeTZJL) {
            view.isTenderRecord = YES;
            [MobClick event:@"detail_genre1_ui_investment_record" label:@"散标详情页_投资记录"];
        } else {
            [MobClick event:@"detail_genre1_ui_project_details" label:@"散标详情页_项目详情"];
        }
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - Tender detail table view cell delegate

- (void)timerStopWithTableViewCell:(TenderDetailTableViewCell *)tableViewCell {
    self.availableAmountLabel.hidden = NO;
    self.availableAmountLabel.text = [NSString stringWithFormat:@"剩余可投金额%@元", self.itemModel.availableAmount];
    [self.doneBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    self.doneBtn.backgroundColor = [UIColor getColorWithRGBStr:self.itemModel.tenderTypeBorderColor];
    self.doneBtn.userInteractionEnabled = YES;
}

@end
