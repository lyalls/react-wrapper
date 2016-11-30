//
//  UITenderListTableViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITenderListTableViewController.h"

#import "UITenderDetailViewController.h"

#import "BCHomeBannerTableViewCell.h"
#import "BCTenderItemTableViewCell.h"
#import "BCBottomTableViewCell.h"

#import "TenderRequest.h"
#import "BCRefreshGifHeader.h"
#import <MJRefresh/MJRefresh.h>


NSString *TenderBannerCell = @"TenderBannerCell";
NSString *TenderBottomCell = @"TenderBottomCell";

@interface UITenderListTableViewController ()

@property (nonatomic, strong) NSMutableArray *bannerImageArray;
@property (nonatomic, strong) NSMutableArray *tenderArray;
@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isNoData;

@end

@implementation UITenderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"理财";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = BackViewColor;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self.tableView registerCellWithClass:[BCHomeBannerTableViewCell class]];
    [self.tableView registerCellWithClass:[BCTenderItemTableViewCell class]];
    [self.tableView registerCellWithClass:[BCBottomTableViewCell class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBanner) name:RefreshBannerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTender) name:RefreshTenderNotification object:nil];
    
    self.pageIndex = 0;
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    self.tenderArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [BCRefreshGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        
        [self getData];
    }];
   
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        
        [self getData];
    }];
    
    [(BCRefreshGifHeader*)self.tableView.mj_header beginRefreshing];
    [self refreshBanner];
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

#pragma mark - Service method

- (void)reloadTableView {
    [self.displayArray removeAllObjects];
    if (self.bannerImageArray.count > 0) {
        [self.displayArray addObject:TenderBannerCell];
    }
    
    [self.displayArray addObjectsFromArray:self.tenderArray];
    
    if (self.isNoData) {
        [self.displayArray addObject:TenderBottomCell];
    }
    
    [self.tableView reloadData];
}

- (void)refreshBanner {
    if ([UserDefaultsHelper sharedManager].bannerInfo) {
        self.bannerImageArray = [[UserDefaultsHelper sharedManager].bannerInfo objectForKey:@"tenderBannerList"];
    }
    [self reloadTableView];
}

- (void)refreshTender {
    [self.tableView.mj_header beginRefreshing];
}
- (void)getData {
    [TenderRequest getTenderListWithPageIndex:self.pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == 0) {
            NSArray *array = [dic objectForKey:@"tenderList"];
            if (self.pageIndex == 1) {
                [self.tenderArray removeAllObjects];
            }
            for (NSDictionary *itemDic in array) {
                [self.tenderArray addObject:[[TenderItemModel alloc] initWithDic:itemDic]];
            }
            
            if (array.count < PageMaxCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.isNoData = YES;
            }
            
            [self reloadTableView];
        } else {
            self.pageIndex--;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.pageIndex--;
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
        if ([cellName isEqualToString:TenderBannerCell]) {
            BCHomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCHomeBannerTableViewCell class]) forIndexPath:indexPath];
            [cell reloadBannerData:self.bannerImageArray bannerItemClickBlock:^(NSDictionary *dic) {
                [self openWebBrowserWithUrl:[dic objectForKey:@"actionUrl"]];
            }];
            
            return cell;
        } else if ([cellName isEqualToString:TenderBottomCell]) {
            BCBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCBottomTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        BCTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCTenderItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:[self.displayArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:TenderBannerCell]) {
            return 64 * homeHeightScale;
        }
        if ([cellName isEqualToString:TenderBottomCell]) {
            return 30;
        }
    } else {
        return 115;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        if ([cellName isEqualToString:TenderBannerCell]) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return;
        }
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 9999, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 9999, 0, 0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    if ([cellType isKindOfClass:[NSString class]]) {
        
    } else {
        UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.itemModel = [self.displayArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
