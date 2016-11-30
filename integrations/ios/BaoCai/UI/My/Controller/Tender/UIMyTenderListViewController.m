//
//  UIMyTenderListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIMyTenderListViewController.h"
#import "UIMyTenderDetailViewController.h"
#import "UITenderDetailViewController.h"

#import "BCMyTenderItemTableViewCell.h"
#import "BCEmptyTableViewCell.h"
#import "BCButtonScrollView.h"

#import "MyTenderListItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UIMyTenderListViewController () <UITableViewDelegate, UITableViewDataSource, BCButtonScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;
@property (nonatomic, strong) BCButtonScrollView *buttonScrollView;

@property (nonatomic, strong) NSMutableArray *displayRecoveryArray;
@property (nonatomic, assign) NSInteger recoveryPageIndex;
@property (nonatomic, strong) NSMutableArray *displayTenderArray;
@property (nonatomic, assign) NSInteger tenderPageIndex;
@property (nonatomic, strong) NSMutableArray *displayAlreadyRecoveryArray;
@property (nonatomic, assign) NSInteger alreadyRecoveryPageIndex;

@end

@implementation UIMyTenderListViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = BackViewColor;
    
    self.title = @"我的散标";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BackViewColor;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.backgroundColor = BackViewColor;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView3.backgroundColor = BackViewColor;
    self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.buttonScrollView = [[BCButtonScrollView alloc] init];
    self.buttonScrollView.delegate = self;
    [self.view addSubview:self.buttonScrollView];
    
    [self.buttonScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self.buttonScrollView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    [self.tableView1 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    [self.tableView2 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    [self.tableView3 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    
    [self.tableView1 registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView2 registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView3 registerCellWithClass:[BCEmptyTableViewCell class]];
    
    self.displayRecoveryArray = [NSMutableArray arrayWithCapacity:0];
    self.displayTenderArray = [NSMutableArray arrayWithCapacity:0];
    self.displayAlreadyRecoveryArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.recoveryPageIndex = 1;
        [self getDataWithType:MyTenderItemTableViewCellTypeRecovery];
    }];
    
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.recoveryPageIndex++;
        [self getDataWithType:MyTenderItemTableViewCellTypeRecovery];
    }];
    
    self.tableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.tenderPageIndex = 1;
        [self getDataWithType:MyTenderItemTableViewCellTypeTender];
    }];
    
    self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.tenderPageIndex++;
        [self getDataWithType:MyTenderItemTableViewCellTypeTender];
    }];
    
    self.tableView3.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.alreadyRecoveryPageIndex = 1;
        [self getDataWithType:MyTenderItemTableViewCellTypeAlreadyRecovery];
    }];
    
    self.tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.alreadyRecoveryPageIndex++;
        [self getDataWithType:MyTenderItemTableViewCellTypeAlreadyRecovery];
    }];
    
    self.recoveryPageIndex = 0;
    self.tenderPageIndex = 0;
    self.alreadyRecoveryPageIndex = 0;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    BCButtonScrollItemModel *model1 = [[BCButtonScrollItemModel alloc] init];
    model1.buttonName = @"回收中";
    model1.displayView = self.tableView1;
    model1.isSelected = self.showPageIndex == 0;
    [array addObject:model1];
    
    BCButtonScrollItemModel *model2 = [[BCButtonScrollItemModel alloc] init];
    model2.buttonName = @"投标中";
    model2.displayView = self.tableView2;
    model2.isSelected = self.showPageIndex == 1;
    [array addObject:model2];
    
    BCButtonScrollItemModel *model3 = [[BCButtonScrollItemModel alloc] init];
    model3.buttonName = @"已回收";
    model3.displayView = self.tableView3;
    model3.isSelected = self.showPageIndex == 2;
    [array addObject:model3];
    
    [self.buttonScrollView reloadDisplay:array];
    
    switch (self.showPageIndex) {
        case 0:
            [self.tableView1.mj_header beginRefreshing];
            break;
        case 1:
            [self.tableView2.mj_header beginRefreshing];
            break;
        case 2:
            [self.tableView3.mj_header beginRefreshing];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    if (self.isPopToRootViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataWithType:(MyTenderItemTableViewCellType)myTenderListType {
    NSInteger pageIndex = 0;
    switch (myTenderListType) {
        case MyTenderItemTableViewCellTypeRecovery: {
            pageIndex = self.recoveryPageIndex;
            break;
        }
        case MyTenderItemTableViewCellTypeTender: {
            pageIndex = self.tenderPageIndex;
            break;
        }
        case MyTenderItemTableViewCellTypeAlreadyRecovery: {
            pageIndex = self.alreadyRecoveryPageIndex;
            break;
        }
    }
    [MyRequest getMyTenderListWithTenderType:myTenderListType pageIndex:pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        
        if (error.code == 0) {
            NSString *tenderType = [dic objectForKey:@"tenderType"];
            NSMutableArray *myTenderArray = [dic objectForKey:@"tenderList"];
            if ([tenderType isEqualToString:@"roamNo"]) {
                if (myTenderArray.count < PageMaxCount)
                    [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                if (self.recoveryPageIndex == 1) {
                    [self.displayRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTenderListItemModel *model = [[MyTenderListItemModel alloc] initWithDic:item];
                    if (![self.displayRecoveryArray containsObject:model]) {
                        [self.displayRecoveryArray addObject:model];
                    }
                }
                
                [self.tableView1 reloadData];
            } else if ([tenderType isEqualToString:@"loan"]) {
                if (myTenderArray.count < PageMaxCount)
                    [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                if (self.tenderPageIndex == 1) {
                    [self.displayTenderArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTenderListItemModel *model = [[MyTenderListItemModel alloc] initWithDic:item];
                    if (![self.displayTenderArray containsObject:model]) {
                        [self.displayTenderArray addObject:model];
                    }
                }
                
                [self.tableView2 reloadData];
            } else if ([tenderType isEqualToString:@"roamYes"]) {
                if (myTenderArray.count < PageMaxCount)
                    [self.tableView3.mj_footer endRefreshingWithNoMoreData];
                if (self.alreadyRecoveryPageIndex == 1) {
                    [self.displayAlreadyRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTenderListItemModel *model = [[MyTenderListItemModel alloc] initWithDic:item];
                    if (![self.displayAlreadyRecoveryArray containsObject:model]) {
                        [self.displayAlreadyRecoveryArray addObject:model];
                    }
                }
                
                [self.tableView3 reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        SHOWTOAST(@"我的散标信息获取失败，请稍后再试");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1)
        return self.displayRecoveryArray.count + 1;
    else if (tableView == self.tableView2)
        return self.displayTenderArray.count + 1;
    else if (tableView == self.tableView3)
        return self.displayAlreadyRecoveryArray.count + 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    MyTenderListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayRecoveryArray.count)
            isEnd = YES;
        else
            model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTenderArray.count)
            isEnd = YES;
        else
            model = [self.displayTenderArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (indexPath.row == self.displayAlreadyRecoveryArray.count)
            isEnd = YES;
        else
            model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
    }
    
    if (isEnd) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    }
    
    MyTenderItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTenderItemTableViewCellTypeRecovery;
    else if (tableView == self.tableView2)
        type = MyTenderItemTableViewCellTypeTender;
    else if (tableView == self.tableView3)
        type = MyTenderItemTableViewCellTypeAlreadyRecovery;
    
    BCMyTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTenderItemTableViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:model myTenderItemTableViewCellType:type];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayRecoveryArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTenderArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (indexPath.row == self.displayAlreadyRecoveryArray.count)
            isEnd = YES;
    }
    return isEnd ? 10 : 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isEnd = NO;
    MyTenderListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayRecoveryArray.count)
            isEnd = YES;
        else
            model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTenderArray.count)
            isEnd = YES;
        else
            model = [self.displayTenderArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (indexPath.row == self.displayAlreadyRecoveryArray.count)
            isEnd = YES;
        else
            model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
    }
    
    if (isEnd) return;
    
    if (tableView == self.tableView2) {
        UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
        viewController.tenderId = model.myTenderListItemId;
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    UIMyTenderDetailViewController *view = [[UIMyTenderDetailViewController alloc] init];
    view.tenderItemModel = model;
    [self.navigationController pushViewController:view animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (self.displayRecoveryArray.count)
            isEnd = YES;
        if (self.recoveryPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (self.displayTenderArray.count)
            isEnd = YES;
        if (self.tenderPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (self.displayAlreadyRecoveryArray.count)
            isEnd = YES;
        if (self.alreadyRecoveryPageIndex == 0)
            isEnd = YES;
    }
    return isEnd ? 0 : tableView.bounds.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    
    UIView *centerView = [[UIView alloc] init];
    [footerView addSubview:centerView];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(-70);
    }];
    
    UIImage *noDataImage = [UIImage imageNamed:@"noRecovery.png"];
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = noDataImage;
    [centerView addSubview:noDataImageView];
    
    [noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.size.equalTo(noDataImage.size);
        make.centerX.equalTo(0);
    }];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.font = [UIFont systemFontOfSize:16];
    noDataLabel.textColor = Color999999;
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = @"暂无记录";
    [centerView addSubview:noDataLabel];
    
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noDataImageView.mas_bottom).offset(30);
        make.centerX.equalTo(0);
    }];
    
    UIButton *noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noDataButton setTitle:@"开启财富之旅" forState:UIControlStateNormal];
    [noDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noDataButton.layer.cornerRadius = 5;
    noDataButton.titleLabel.font = [UIFont systemFontOfSize:20];
    noDataButton.backgroundColor = OrangeColor;
    [noDataButton addTargetHandler:^(UIButton *sender) {
        [self.tabBarController setSelectedIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [centerView addSubview:noDataButton];
    
    [noDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(noDataLabel.mas_bottom).equalTo(60);
        make.size.equalTo(CGSizeMake(230, 45));
    }];
    
    return footerView;
    
}

#pragma mark - BCButtonScrollViewDelegate

- (void)buttonScrollViewDidChangeIndexPage:(NSInteger)pageIndex {
    switch (pageIndex) {
        case 0:
            if (self.recoveryPageIndex == 0) {
                [self.tableView1.mj_header beginRefreshing];
            }
            break;
        case 1:
            if (self.tenderPageIndex == 0) {
                [self.tableView2.mj_header beginRefreshing];
            }
            break;
        case 2:
            if (self.alreadyRecoveryPageIndex == 0) {
                [self.tableView3.mj_header beginRefreshing];
            }
            break;
    }
}

@end
