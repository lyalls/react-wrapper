//
//  UIHomeTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIHomeTableViewController.h"
#import "UIWebBrowserViewController.h"
#import "UITenderDetailViewController.h"

#import "HomeBannerTableViewCell.h"
#import "HomeNoticeTableViewCell.h"
#import "HomePropagateTableViewCell.h"
#import "HomeNoviceTableViewCell.h"
#import "TenderItemTableViewCell.h"
#import "BottomTableViewCell.h"
#import "EmptyTableViewCell.h"
#import "UITenderSuccessViewController.h"
#import "TenderItemModel.h"
#import "UserInfoModel.h"

#import "HomeRequest.h"
#import "TenderRequest.h"
#import "GeneralRequest.h"

#import "DTouchButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "UIWebViewController.h"
#import "EMSDK.h"

NSString *HomeEmptyCell = @"HomeEmptyCell";
NSString *HomeBannerCell = @"HomeBannerCell";
NSString *HomeNoticeCell = @"HomeNoticeCell";
NSString *HomePropagateCell = @"HomePropagateCell";
NSString *HomeNoviceCell = @"HomeNoviceCell";
NSString *HomeBottomCell = @"HomeBottomCell";

@interface UIHomeTableViewController () <UITableViewDelegate, UITableViewDataSource, touchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellNibWithClass:[HomeBannerTableViewCell class]];
    [self.tableView registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView registerCellNibWithClass:[HomeNoticeTableViewCell class]];
    [self.tableView registerCellNibWithClass:[HomePropagateTableViewCell class]];
    [self.tableView registerCellNibWithClass:[HomeNoviceTableViewCell class]];
    [self.tableView registerCellNibWithClass:[TenderItemTableViewCell class]];
    [self.tableView registerCellNibWithClass:[BottomTableViewCell class]];
    
    self.touchButton = [[DTouchButton alloc] initWithFrame:CGRectMake(Screen_width - 60, (self.view.height - 75) / 2, 60, 75)];
    self.touchButton.delegate = self;
    self.touchButton.userInteractionEnabled_DT = YES;
    self.touchButton.hidden = YES;
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self getData];
        
        if ([UserInfoModel sharedModel].token) {
            [self setLoginBtnHidden];
        }
    }];
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^
     {
         [UITableView randSlogan];
         [self resetSlogan];
     }];
    [self.tableView setRefreshGifHeader:FROM_HOME];
    
    self.tenderArray = [NSMutableArray arrayWithCapacity:0];
    
    self.isShowNotice = NO;
    
    if ([UserDefaultsHelper sharedManager].bannerInfo) {
        self.bannerImageArray = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"homeBannerList"];
        self.introduceUrl = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"introduceUrl"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginBtnHidden) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginBtnHidden) name:LogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSlogan) name:RefreshSloganNotification object:nil];
    
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
-(void)resetSlogan
{
    [self.tableView setRefreshGifHeader:FROM_HOME];
}
- (IBAction)loginBtnClick:(id)sender {
   [self toLoginViewController];
    
    /*UIWebViewController* view = [[UIWebViewController alloc] init];
    view.req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.5.217:3000/test.html"]];
    view.canScroll = YES;
    [self.navigationController pushViewController:view animated:YES];*/
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
            HomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeBannerTableViewCell class]) forIndexPath:indexPath];
            [cell setupView:self.bannerImageArray bannerItemClickBlock:^(NSDictionary *dic) {
                [self openWebBrowserWithUrl:[dic objectForKey:@"actionUrl"]];
            }];
            
            return cell;
        } else if ([cellName isEqualToString:HomeNoticeCell]) {
            HomeNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeNoticeTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.noticeArray closeNotice:^{
                _isShowNotice = NO;
                _noticeArray = [NSMutableArray arrayWithCapacity:0];
                [self reloadTableView];
            }];
            
            return cell;
        } else if ([cellName isEqualToString:HomePropagateCell]) {
            HomePropagateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePropagateTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:HomeNoviceCell]) {
            HomeNoviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeNoviceTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:[self.tenderArray objectAtIndex:0]];
            
            return cell;
        } else if ([cellName isEqualToString:HomeEmptyCell]) {
            EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:HomeBottomCell]) {
            BottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottomTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        TenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TenderItemTableViewCell class]) forIndexPath:indexPath];
        
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
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
            }
        }
    } else {
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
    
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:HomePropagateCell]) {
            [self openWebBrowserWithUrl:self.introduceUrl];
            
            [MobClick event:@"home_ui_introduction"];
        } else if ([cellName isEqualToString:HomeNoviceCell]) {
            UITenderDetailViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UITenderDetailViewController"];
            viewController.itemModel = [self.tenderArray objectAtIndex:0];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        UITenderDetailViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UITenderDetailViewController"];
        viewController.itemModel = cellType;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
