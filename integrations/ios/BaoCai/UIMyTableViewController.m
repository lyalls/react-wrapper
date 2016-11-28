//
//  UIMyTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIMyTableViewController.h"

#import "UIMyTenderListViewController.h"
#import "UITransferListViewController.h"
#import "UINewTicketListViewController.h"
#import "UIInviteFriendsViewController.h"
#import "UIChatViewController.h"
#import "UISettingViewController.h"
#import "UIFirstRechargeViewController.h"
#import "UIRechargeViewController.h"
#import "UIWithdrawalsViewController.h"
#import "UIAddBankCardViewController.h"
#import "UICompletBankCardViewController.h"
#import "UIRealNameViewController.h"
#import "UISetTraderPasswordViewController.h"

#import "MyTopTableViewCell.h"
#import "MyFunctionTableViewCell.h"
#import "MyItemTableViewCell.h"
#import "EmptyTableViewCell.h"
#import "BottomTableViewCell.h"

#import "MyItemModel.h"
#import "MyPageDataModel.h"
#import "RechargeModel.h"

#import "UserRequest.h"
#import "MyRequest.h"
#import "LoginRegisterRequest.h"

#import <MJRefresh/MJRefresh.h>
#import "BCRefreshGifHeader.h"

NSString *MyTopCell = @"MyTopCell";
NSString *MyFunctionCell = @"MyFunctionCell";
NSString *MyEmptyCell = @"MyEmptyCell";
NSString *MyBottomCell = @"MyBottomCell";
// 文字颜色
@interface UIMyTableViewController ()

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, strong) MyPageDataModel *myPageDataModel;
@property (weak, nonatomic) IBOutlet UIButton *securityBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation UIMyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;		
    [self setNavigationBarWithColor:RGB_COLOR(248, 164, 62)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellNibWithClass:[MyTopTableViewCell class]];
    [self.tableView registerCellNibWithClass:[MyFunctionTableViewCell class]];
    [self.tableView registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView registerCellNibWithClass:[MyItemTableViewCell class]];
    [self.tableView registerCellNibWithClass:[BottomTableViewCell class]];
    
    self.tableView.mj_header = [BCRefreshGifHeader headerWithRefreshingBlock:^{
        [self getData];
    }];

    [(BCRefreshGifHeader*)self.tableView.mj_header setRefreshGifHeaderType:FROM_MY];
    //背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.view.bounds.size.width, 300)];
    view.backgroundColor = RGB_COLOR(248, 164, 62);
    [self.tableView insertSubview:view atIndex:0];
    //文字
    MJRefreshGifHeader *refreshStateHeader = (MJRefreshGifHeader*)self.tableView.mj_header;
    [refreshStateHeader lastUpdatedTimeLabel].textColor = RGB_COLOR(255, 255, 255);
    refreshStateHeader.stateLabel.textColor = RGB_COLOR(255, 255, 255);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:RefreshTicketNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLogoutMethod) name:LogoutNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSlogan) name:RefreshSloganNotification object:nil];
    NSString *phoneStr = [UserInfoModel sharedModel].phone;
    phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [self.securityBtn setTitle:phoneStr forState:UIControlStateNormal];
    if ([[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2) {
        [self.securityBtn setImage:[UIImage imageNamed:@"myToAccountIcon.png"] forState:UIControlStateNormal];
        [self.securityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        [self.securityBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 94, 4, 0)];
        [self.securityBtn setWidth:110];
    } else {
        [self.securityBtn setImage:[UIImage imageNamed:@"myUnauthorized.png"] forState:UIControlStateNormal];
        [self.securityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
        [self.securityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, 0)];
        [self.securityBtn setWidth:160];
    }
    
    [self reloadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self getData];
}

- (IBAction)messageBtnClick:(id)sender {
    [MobClick event:@"my_ui_message" label:@"我的_消息"];
}

- (IBAction)accountSecurityBtnClick:(id)sender {
    [MobClick event:@"my_ui_safe" label:@"我的_账户安全"];
}


#pragma mark - Custom Method

- (void)getData {
    [MyRequest getMyPageDataWithSuccess:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error.code == 0) {
            self.myPageDataModel = [[MyPageDataModel alloc] initWithDic:dic];
            
            [self reloadTableView];
            
            if ([dic integerForKey:@"unReadMessageNum"] > 0) {
                [self.messageBtn setImage:[UIImage imageNamed:@"myMessage_new.png"] forState:UIControlStateNormal];
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            } else {
                [self.messageBtn setImage:[UIImage imageNamed:@"myMessage.png"] forState:UIControlStateNormal];
                EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:CustomServiceSessionID type:EMConversationTypeChat createIfNotExist:YES];
                if (conversation.unreadMessagesCount) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                }
                else {
                    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
                }
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    [LoginRegisterRequest refreshTokenWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            NSString *phoneStr = [UserInfoModel sharedModel].phone;
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [self.securityBtn setTitle:phoneStr forState:UIControlStateNormal];
            if ([[UserDefaultsHelper sharedManager].userInfo integerForKey:@"realNameAuth"] == 2) {
                [self.securityBtn setImage:[UIImage imageNamed:@"myToAccountIcon.png"] forState:UIControlStateNormal];
                [self.securityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
                [self.securityBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 94, 4, 0)];
                [self.securityBtn setWidth:110];
            } else {
                [self.securityBtn setImage:[UIImage imageNamed:@"myUnauthorized.png"] forState:UIControlStateNormal];
                [self.securityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
                [self.securityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, 0)];
                [self.securityBtn setWidth:160];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadTableView {
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.displayArray addObject:MyTopCell];
    [self.displayArray addObject:MyFunctionCell];
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:CustomServiceSessionID type:EMConversationTypeChat createIfNotExist:YES];
    NSMutableArray *myItemList = [MyItemModel getDataWithIsHasUnRead:conversation.unreadMessagesCount > 0 isHasNewVersion:[UserDefaultsHelper sharedManager].isNewVersion withMyPageDataModel:self.myPageDataModel];
    
    for (NSArray *array in myItemList) {
        [self.displayArray addObject:MyEmptyCell];
        for (MyItemModel *item in array) {
            [self.displayArray addObject:item];
        }
    }
    
    [self.displayArray addObject:MyBottomCell];
    
    [self.tableView reloadData];
}

#pragma mark - NSNotificationCenter

- (void)myLogoutMethod {
    [self.displayArray removeAllObjects];
    
    [self.tableView reloadData];
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
        
        if ([cellName isEqualToString:MyTopCell]) {
            MyTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTopTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.myPageDataModel];
            
            return cell;
        } else if ([cellName isEqualToString:MyFunctionCell]) {
            MyFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyFunctionTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:^(FunctionType type) {
                switch (type) {
                    case FunctionTypeRecharge: {
                        [MobClick event:@"my_ui_upload_funds" label:@"我的_充值"];
                        SHOWPROGRESSHUD;
                        [UserRequest userCheckAuthenticationStatus:^(NSDictionary *dic, BCError *error) {
                            if (error.code == 0 || error.code == 2003) {
                                [MyRequest getRechargeStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
                                    HIDDENPROGRESSHUD;
                                    if (error.code == 0) {
                                        RechargeModel *model = [[RechargeModel alloc] initWithDic:dic];
                                        if (model.isNotFirstRecharge) {
                                            UIRechargeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRechargeViewController"];
                                            view.model = model;
                                            [self.navigationController pushViewController:view animated:YES];
                                        } else {
                                            UIFirstRechargeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIFirstRechargeViewController"];
                                            view.model = model;
                                            [self.navigationController pushViewController:view animated:YES];
                                        }
                                    } else {
                                        SHOWTOAST(error.message);
                                    }
                                } failure:^(NSError *error) {
                                    HIDDENPROGRESSHUD;
                                }];
                            } else if (error.code == 2001) {
                                HIDDENPROGRESSHUD;
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
                                [alertView show];
                                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        UIRealNameViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRealNameViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    }
                                }];
                            } else if (error.code == 2002) {
                                HIDDENPROGRESSHUD;
                                SHOWTOAST(@"实名认证审核中");
                            } else {
                                HIDDENPROGRESSHUD;
                            }
                        } failure:^(NSError *error) {
                            HIDDENPROGRESSHUD;
                        }];
                        break;
                    }
                    case FunctionTypeWithdrawals: {
                        [MobClick event:@"my_ui_withdraw_cash" label:@"我的_提现"];
                        SHOWPROGRESSHUD;
                        [UserRequest userCheckAuthenticationStatus:^(NSDictionary *dic, BCError *error) {
                            if (error.code == 0) {
                                [MyRequest getWithdrawalsStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
                                    HIDDENPROGRESSHUD;
                                    if (error.code == 0) {
                                        UIWithdrawalsViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIWithdrawalsViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    } else if (error.code == 3001) {
                                        UIAddBankCardViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIAddBankCardViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    } else if (error.code == 3002) {
                                        UICompletBankCardViewController *view = [self getControllerByMainStoryWithIdentifier:@"UICompletBankCardViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    } else {
                                        SHOWTOAST(error.message);
                                    }
                                } failure:^(NSError *error) {
                                    HIDDENPROGRESSHUD;
                                }];
                            } else if (error.code == 2001) {
                                HIDDENPROGRESSHUD;
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
                                [alertView show];
                                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        UIRealNameViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRealNameViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    }
                                }];
                            } else if (error.code == 2002) {
                                HIDDENPROGRESSHUD;
                                SHOWTOAST(@"实名认证审核中");
                            } else if (error.code == 2003) {
                                HIDDENPROGRESSHUD;
                                UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即设置", nil];
                                [alertView show];
                                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        UISetTraderPasswordViewController *view = [self getControllerByMainStoryWithIdentifier:@"UISetTraderPasswordViewController"];
                                        [self.navigationController pushViewController:view animated:YES];
                                    }
                                }];
                            } else {
                                HIDDENPROGRESSHUD;
                            }
                        } failure:^(NSError *error) {
                            HIDDENPROGRESSHUD;
                        }];
                        break;
                    }
                }
            }];
            
            return cell;
        } else if ([cellName isEqualToString:MyEmptyCell]) {
            EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:MyBottomCell]) {
            BottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottomTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
        return nil;
    } else {
        MyItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:(MyItemModel *)cellType];
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        
        if ([cellName isEqualToString:MyTopCell]) {
            return 136;
        } else if ([cellName isEqualToString:MyFunctionCell]) {
            return 44;
        } else if ([cellName isEqualToString:MyEmptyCell]) {
            return 10;
        } else if ([cellName isEqualToString:MyBottomCell]) {
            return 30;
        }
        return tableView.rowHeight;
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
    if (indexPath.row == self.displayArray.count - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if (![cellType isKindOfClass:[NSString class]]) {
        MyItemModel *model = (MyItemModel *)cellType;
        switch (model.pageNameType) {
            case PageNameTypeSBTZ: {
                [MobClick event:@"my_ui_genre_invest" label:@"我的_散标投资"];
                UIMyTenderListViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIMyTenderListViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case PageNameTypeZQZR: {
                [MobClick event:@"my_ui_genre_assignment" label:@"我的_债权转让"];
                UITransferListViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UITransferListViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case PageNameTypeTicket: {
                [MobClick event:@"my_ui_coupon" label:@"我的_优惠券"];
                UINewTicketListViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UINewTicketListViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case PageNameTypeInviteFriends: {
                [MobClick event:@"my_ui_invite" label:@"我的_邀请好友"];
                UIInviteFriendsViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIInviteFriendsViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case PageNameTypeCustomService: {
                [MobClick event:@"my_ui_service" label:@"我的_在线客服"];
                UIChatViewController *chatController = [[UIChatViewController alloc] initWithConversationChatter:CustomServiceSessionID conversationType:EMConversationTypeChat];
                chatController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatController animated:YES];
                break;
            }
            case PageNameTypeSetting: {
                [MobClick event:@"my_ui_set" label:@"我的_设置"];
                UISettingViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UISettingViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
        }
    }
}

@end
