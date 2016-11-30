//
//  UIHomeTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIHomeTableViewController.h"
#import "UIWebBrowserViewController.h"
#import "UITenderDetailViewController.h"

#import "BCHomeBannerTableViewCell.h"
#import "BCEmptyTableViewCell.h"
#import "BCHomeNoticeTableViewCell.h"
#import "BCHomePropagateTableViewCell.h"
#import "BCHomeNoviceTableViewCell.h"
#import "BCTenderItemTableViewCell.h"
#import "BCBottomTableViewCell.h"

#import "TenderItemModel.h"
#import "UserInfoModel.h"
#import "BCRefreshGifHeader.h"
#import "HomeRequest.h"
#import "TenderRequest.h"
#import "GeneralRequest.h"

#import "DTouchButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "EMSDK.h"

NSString *HomeEmptyCell = @"HomeEmptyCell";
NSString *HomeBannerCell = @"HomeBannerCell";
NSString *HomeNoticeCell = @"HomeNoticeCell";
NSString *HomePropagateCell = @"HomePropagateCell";
NSString *HomeNoviceCell = @"HomeNoviceCell";
NSString *HomeBottomCell = @"HomeBottomCell";

@interface UIHomeTableViewController () <UITableViewDelegate, UITableViewDataSource, touchDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) DTouchButton *touchButton;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, strong) NSMutableArray *bannerImageArray;
@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) NSMutableArray *tenderArray;
@property (nonatomic, strong) NSString *introduceUrl;
@property (nonatomic, strong) NSString *floatViewUrl;

@property (nonatomic, assign) BOOL isShowNotice;

@property (nonatomic, assign) CGFloat height;

@end

@implementation UIHomeTableViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = BackViewColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackViewColor;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.loginBtn = [[UIButton alloc] init];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:Color666666 forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loginBtn];
    
    self.touchButton = [[DTouchButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (self.view.bounds.size.height - 75) / 2, 60, 75)];
    self.touchButton.delegate = self;
    self.touchButton.userInteractionEnabled_DT = YES;
    self.touchButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"抱财";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellWithClass:[BCHomeBannerTableViewCell class]];
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView registerCellWithClass:[BCHomeNoticeTableViewCell class]];
    [self.tableView registerCellWithClass:[BCHomePropagateTableViewCell class]];
    [self.tableView registerCellWithClass:[BCHomeNoviceTableViewCell class]];
    [self.tableView registerCellWithClass:[BCTenderItemTableViewCell class]];
    [self.tableView registerCellWithClass:[BCBottomTableViewCell class]];
    
    self.tableView.mj_header = [BCRefreshGifHeader headerWithRefreshingBlock:^{
        [self getData];
        
        if ([UserInfoModel sharedModel].token) {
            [self setLoginBtnHidden];
        }
    }];
   
    self.tenderArray = [NSMutableArray arrayWithCapacity:0];
    
    self.isShowNotice = NO;
    
    if ([UserDefaultsHelper sharedManager].bannerInfo) {
        self.bannerImageArray = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"homeBannerList"];
        self.introduceUrl = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"introduceUrl"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginBtnHidden) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginBtnHidden) name:LogoutNotification object:nil];
   
    [GeneralRequest checkVersionWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if ([dic integerForKey:@"updateType"] == 1) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[dic stringForKey:@"updateMessage"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [alertView show];
                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[[dic stringForKey:@"updateUrl"] toURL]];
                    }
                }];
                [UserDefaultsHelper sharedManager].isNewVersion = YES;
            } else if ([dic integerForKey:@"updateType"] == 2) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[dic stringForKey:@"updateMessage"] delegate:nil cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                    [[UIApplication sharedApplication] openURL:[[dic stringForKey:@"updateUrl"] toURL]];
                    exit(0);
                }];
                [UserDefaultsHelper sharedManager].isNewVersion = YES;
            } else {
                [UserDefaultsHelper sharedManager].isNewVersion = NO;
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    [self getData];
    
    self.loginBtn.hidden = [UserInfoModel sharedModel].token ? YES : NO;
    
    [self reloadTableView];
    
    // 加载 H5 页面
    if([[self class] copySrcToDoc]){
        [self setReq:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self class] componentIndex: @"home"]]]];
    }else{
        NSLog(@"Can't load component: [%@]", @"home");
    }
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick event:@"home_ui" label:@"首页"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endEvent:@"home_ui" label:@"首页"];
}

#pragma mark - Custom Method

- (void)reloadTableView {
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    if (self.bannerImageArray.count != 0) {
        [self.displayArray addObject:HomeBannerCell];
        [self.displayArray addObject:HomeEmptyCell];
    }
    
    if (self.noticeArray.count != 0) {
        [self.displayArray addObject:HomeNoticeCell];
        [self.displayArray addObject:HomeEmptyCell];
    }
    
    [self.displayArray addObject:HomePropagateCell];
    
    if (self.tenderArray.count != 0) {
        [self.displayArray addObject:HomeEmptyCell];
        [self.displayArray addObject:HomeNoviceCell];
        for (NSInteger i = 1; i < self.tenderArray.count; i++) {
            [self.displayArray addObject:[self.tenderArray objectAtIndex:i]];
        }
        
        [self.displayArray addObject:HomeBottomCell];
    }
    
    [self.tableView reloadData];
}

- (void)setLoginBtnHidden {
    self.loginBtn.hidden = [UserInfoModel sharedModel].token ? YES : NO;
    
    if ([UserInfoModel sharedModel].token) {
        [GeneralRequest getUnReadMessageWithSuccess:^(NSDictionary *dic, BCError *error) {
            if (error.code == 0) {
                if ([dic integerForKey:@"messageCount"] > 0) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                }
            }
        } failure:^(NSError *error) {
            
        }];
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:[UserInfoModel sharedModel].userId password:[[UserInfoModel sharedModel].userId md5Encrypt]];
        if (!error) {
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:CustomServiceSessionID type:EMConversationTypeChat createIfNotExist:YES];
            if (conversation.unreadMessagesCount > 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            }
        } else if (error.code == EMErrorUserNotFound) {
            EMError *registerError = [[EMClient sharedClient] registerWithUsername:[UserInfoModel sharedModel].userId password:[[UserInfoModel sharedModel].userId md5Encrypt]];
            if (!registerError) {
                EMError *loginError = [[EMClient sharedClient] loginWithUsername:[UserInfoModel sharedModel].userId password:[[UserInfoModel sharedModel].userId md5Encrypt]];
                if (!loginError) {
                    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:CustomServiceSessionID type:EMConversationTypeChat createIfNotExist:YES];
                    if (conversation.unreadMessagesCount > 0) {
                        [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                    }
                }
            }
        }
    } else {
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
    }
}

- (IBAction)loginBtnClick:(id)sender {
   [self toLoginViewController];
}

- (void)getData {
    [HomeRequest getBannerRequestWithBannerVersion:[UserDefaultsHelper sharedManager].bannerVersion success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error.code == 0) {
            if (![[UserDefaultsHelper sharedManager].bannerVersion isEqualToString:[dic objectForKey:@"bannerVersion"]]) {
                [UserDefaultsHelper sharedManager].bannerVersion = [dic objectForKey:@"bannerVersion"];
                [[UserDefaultsHelper sharedManager] setBannerInfo:dic];
                
                self.bannerImageArray = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"homeBannerList"];
                self.introduceUrl = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"introduceUrl"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBannerNotification object:nil];
            }
            [self reloadTableView];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    [HomeRequest getSystemNoticeWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            _noticeArray = [dic objectForKey:@"activeNotices"];
            
            _isShowNotice = _noticeArray.count > 0;
            
            [self reloadTableView];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [TenderRequest getHomeTenderListWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            [self.tenderArray removeAllObjects];
            
            NSArray *array = [dic objectForKey:@"tenderList"];
            for (NSDictionary *itemDic in array) {
                [self.tenderArray addObject:[[TenderItemModel alloc] initWithDic:itemDic]];
            }
            
            [self reloadTableView];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [HomeRequest getFloatAdvert:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if ([dic objectForKey:@"actionUrl"] && [dic objectForKey:@"imageUrl"]) {
                self.touchButton.hidden = NO;
                self.touchButton.data = dic;
                
                [self.touchButton sd_setImageWithURL:[[dic objectForKey:@"imageUrl"] toURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.touchButton.hidden = YES;
                        return;
                    }
                    self.floatViewUrl = [dic objectForKey:@"actionUrl"];
                    [self.view addSubview:self.touchButton];
                }];
            } else {
                self.touchButton.hidden = YES;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - touchDelegate

- (void)touchDownDTButton {
    [self openWebBrowserWithUrl:self.floatViewUrl];
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
        if ([cellName isEqualToString:HomeBannerCell]) {
            BCHomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCHomeBannerTableViewCell class]) forIndexPath:indexPath];
            [cell reloadBannerData:self.bannerImageArray bannerItemClickBlock:^(NSDictionary *dic) {
                [self openWebBrowserWithUrl:[dic objectForKey:@"actionUrl"]];
            }];
            
            return cell;
        } else if ([cellName isEqualToString:HomeNoticeCell]) {
            BCHomeNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCHomeNoticeTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.noticeArray closeNotice:^{
                _isShowNotice = NO;
                _noticeArray = [NSMutableArray arrayWithCapacity:0];
                [self reloadTableView];
            }];
            
            return cell;
        } else if ([cellName isEqualToString:HomePropagateCell]) {
            BCHomePropagateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCHomePropagateTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:HomeNoviceCell]) {
            BCHomeNoviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCHomeNoviceTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:[self.tenderArray objectAtIndex:0]];
            
            return cell;
        } else if ([cellName isEqualToString:HomeEmptyCell]) {
            BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:HomeBottomCell]) {
            BCBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCBottomTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        BCTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCTenderItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:(TenderItemModel *)cellType];
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:HomeBannerCell]) {
            return 111 * homeHeightScale;
        } else if ([cellName isEqualToString:HomeNoticeCell]) {
            return 20 * homeHeightScale;
        } else if ([cellName isEqualToString:HomePropagateCell]) {
            return 68 * homeHeightScale;
        } else if ([cellName isEqualToString:HomeNoviceCell]) {
            return 233 * homeHeightScale + (_isShowNotice ? 0 : (20 * homeHeightScale + 8 * homeHeightScale));
        } else if ([cellName isEqualToString:HomeEmptyCell]) {
            return 8 * homeHeightScale;
        } else if ([cellName isEqualToString:HomeBottomCell]) {
            return 30;
        }
        return tableView.rowHeight;
    } else {
        return 115;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cellType isKindOfClass:[NSString class]]) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:HomeBottomCell]) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 9999, 0, 0)];
            }
        }
    } else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 9999, 0, 0)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:HomePropagateCell]) {
            [self openWebBrowserWithUrl:self.introduceUrl];
            
            [MobClick event:@"home_ui_introduction"];
        } else if ([cellName isEqualToString:HomeNoviceCell]) {
            UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.itemModel = [self.tenderArray objectAtIndex:0];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.itemModel = cellType;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
