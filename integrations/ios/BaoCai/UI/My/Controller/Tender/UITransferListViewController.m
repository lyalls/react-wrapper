//
//  UITransferListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITransferListViewController.h"
#import "UITransferTurnOutViewController.h"
#import "UITransferRecoveryViewController.h"

#import "BCMyTenderItemTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import "BCButtonScrollView.h"

#import "MyTransferListItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UITransferListViewController () <UITableViewDelegate, UITableViewDataSource, BCButtonScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UIView *page3View;
@property (nonatomic, strong) UITableView *tableView3;
@property (nonatomic, strong) UISegmentedControl *changeTypeControl;

@property (nonatomic, strong) BCButtonScrollView *buttonScrollView;

@property (nonatomic, strong) NSMutableArray *displayTransferArray;
@property (nonatomic, assign) NSInteger transferPageIndex;
@property (nonatomic, strong) NSMutableArray *displayTurnOutArray;
@property (nonatomic, assign) NSInteger turnOutPageIndex;
@property (nonatomic, strong) NSMutableArray *displayRecoveryArray;
@property (nonatomic, assign) NSInteger recoveryPageIndex;
@property (nonatomic, strong) NSMutableArray *displayAlreadyRecoveryArray;
@property (nonatomic, assign) NSInteger alreadyRecoveryPageIndex;

@end

@implementation UITransferListViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"我的债权转让";
    
    self.view.backgroundColor = BackViewColor;
    
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
    
    self.page3View = [[UIView alloc] init];
    self.page3View.backgroundColor = BackViewColor;
    
    self.changeTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"回收中", @"已回收", nil]];
    self.changeTypeControl.tintColor = OrangeColor;
    self.changeTypeControl.selectedSegmentIndex = 0;
    [self.changeTypeControl addTarget:self action:@selector(changeTypeControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.page3View addSubview:self.changeTypeControl];
    
    [self.changeTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(30);
        make.right.equalTo(-30);
    }];
    
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView3.backgroundColor = BackViewColor;
    self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.page3View addSubview:self.tableView3];
    
    [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(60);
    }];
    
    self.buttonScrollView = [[BCButtonScrollView alloc] init];
    self.buttonScrollView.delegate = self;
    [self.view addSubview:self.buttonScrollView];
    
    [self.buttonScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self.buttonScrollView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    [self.changeTypeControl setBorder:OrangeColor width:0.5];
    self.changeTypeControl.layer.cornerRadius = 3;
    
    [self.tableView1 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    [self.tableView2 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    [self.tableView3 registerCellWithClass:[BCMyTenderItemTableViewCell class]];
    
    [self.tableView1 registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView2 registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView3 registerCellWithClass:[BCEmptyTableViewCell class]];
    
    self.tableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.transferPageIndex = 1;
        [self getDataWithType:MyTransferItemTableViewCellTypeTransfer];
    }];
    
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.transferPageIndex++;
        [self getDataWithType:MyTransferItemTableViewCellTypeTransfer];
    }];
    
    self.tableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.turnOutPageIndex = 1;
        [self getDataWithType:MyTransferItemTableViewCellTypeTurnOut];
    }];
    
    self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.turnOutPageIndex++;
        [self getDataWithType:MyTransferItemTableViewCellTypeTurnOut];
    }];
    
    self.tableView3.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            self.recoveryPageIndex = 1;
            [self getDataWithType:MyTransferItemTableViewCellTypeRecovery];
        } else {
            self.alreadyRecoveryPageIndex = 1;
            [self getDataWithType:MyTransferItemTableViewCellTypeAlreadyRecovery];
        }
    }];
    
    self.tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            self.recoveryPageIndex++;
            [self getDataWithType:MyTransferItemTableViewCellTypeRecovery];
        } else {
            self.alreadyRecoveryPageIndex++;
            [self getDataWithType:MyTransferItemTableViewCellTypeAlreadyRecovery];
        }
    }];
    
    self.transferPageIndex = 0;
    self.turnOutPageIndex = 0;
    self.recoveryPageIndex = 0;
    self.alreadyRecoveryPageIndex = 0;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    BCButtonScrollItemModel *model1 = [[BCButtonScrollItemModel alloc] init];
    model1.buttonName = @"转让中";
    model1.displayView = self.tableView1;
    model1.isSelected = YES;
    [array addObject:model1];
    
    BCButtonScrollItemModel *model2 = [[BCButtonScrollItemModel alloc] init];
    model2.buttonName = @"已转出";
    model2.displayView = self.tableView2;
    [array addObject:model2];
    
    BCButtonScrollItemModel *model3 = [[BCButtonScrollItemModel alloc] init];
    model3.buttonName = @"已购入";
    model3.displayView = self.page3View;
    [array addObject:model3];
    
    [self.buttonScrollView reloadDisplay:array];
    
    [self.tableView1.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeTypeControlChange:(id)sender {
    if (self.changeTypeControl.selectedSegmentIndex == 0) {
        if (self.recoveryPageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        } else {
            [self.tableView3 reloadData];
        }
    } else {
        if (self.alreadyRecoveryPageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        } else {
            [self.tableView3 reloadData];
        }
    }
}

- (void)getDataWithType:(MyTransferItemTableViewCellType)myTransferListType {
    NSInteger pageIndex = 0;
    switch (myTransferListType) {
        case MyTransferItemTableViewCellTypeTransfer: {
            pageIndex = self.transferPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeTurnOut: {
            pageIndex = self.turnOutPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeRecovery: {
            pageIndex = self.recoveryPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeAlreadyRecovery: {
            pageIndex = self.alreadyRecoveryPageIndex;
            break;
        }
    }
    
    [MyRequest getMyTransferListWithTenderType:myTransferListType pageIndex:pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        
        if (error.code == 0) {
            NSString *transferType = [dic objectForKey:@"tenderType"];
            NSMutableArray *myTenderArray = [dic objectForKey:@"transferList"];
            if ([transferType isEqualToString:@"changing"]) {
                if (!self.displayTransferArray) {
                    self.displayTransferArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.transferPageIndex == 1) {
                    [self.displayTransferArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayTransferArray containsObject:model]) {
                        [self.displayTransferArray addObject:model];
                    }
                }
                
                [self.tableView1 reloadData];
            } else if ([transferType isEqualToString:@"changYes"]) {
                if (!self.displayTurnOutArray) {
                    self.displayTurnOutArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.turnOutPageIndex == 1) {
                    [self.displayTurnOutArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayTurnOutArray containsObject:model]) {
                        [self.displayTurnOutArray addObject:model];
                    }
                }
                
                [self.tableView2 reloadData];
            } else if ([transferType isEqualToString:@"changRecoverWait"]) {
                if (!self.displayRecoveryArray) {
                    self.displayRecoveryArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.recoveryPageIndex == 1) {
                    [self.displayRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayRecoveryArray containsObject:model]) {
                        [self.displayRecoveryArray addObject:model];
                    }
                }
                
                [self.tableView3 reloadData];
            } else if ([transferType isEqualToString:@"changRecoverYes"]) {
                if (!self.displayAlreadyRecoveryArray) {
                    self.displayAlreadyRecoveryArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.alreadyRecoveryPageIndex == 1) {
                    [self.displayAlreadyRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
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
        SHOWTOAST(@"我的债权转让信息获取失败，请稍后再试");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1)
        return self.displayTransferArray.count + 1;
    else if (tableView == self.tableView2)
        return self.displayTurnOutArray.count + 1;
    else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0)
            return self.displayRecoveryArray.count + 1;
        else
            return self.displayAlreadyRecoveryArray.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    MyTransferListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
        else
            model = [self.displayTransferArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
        else
            model = [self.displayTurnOutArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
        }
    }
    
    if (isEnd) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    }
    
    MyTransferItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTransferItemTableViewCellTypeTransfer;
    else if (tableView == self.tableView2)
        type = MyTransferItemTableViewCellTypeTurnOut;
    else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0)
            type = MyTransferItemTableViewCellTypeRecovery;
        else
            type = MyTransferItemTableViewCellTypeAlreadyRecovery;
    }
    
    BCMyTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTenderItemTableViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:model myTransferItemTableViewCellType:type];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
        }
    }
    return isEnd ? 10 : 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isEnd = NO;
    MyTransferListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
        else
            model = [self.displayTransferArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
        else
            model = [self.displayTurnOutArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
        }
    }
    
    if (isEnd) return;
    
    if (tableView == self.tableView3) {
        UITransferRecoveryViewController *view = [[UITransferRecoveryViewController alloc] init];
        view.transferItemModel = model;
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    
    MyTransferItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTransferItemTableViewCellTypeTransfer;
    else if (tableView == self.tableView2)
        type = MyTransferItemTableViewCellTypeTurnOut;
    
    UITransferTurnOutViewController *view = [[UITransferTurnOutViewController alloc] init];
    view.transferItemModel = model;
    view.transferItemType = type;
    [self.navigationController pushViewController:view animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (self.displayTransferArray.count)
            isEnd = YES;
        if (self.transferPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (self.displayTurnOutArray.count)
            isEnd = YES;
        if (self.turnOutPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (self.displayRecoveryArray.count)
                isEnd = YES;
            if (self.recoveryPageIndex == 0)
                isEnd = YES;
        } else {
            if (self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            if (self.alreadyRecoveryPageIndex == 0)
                isEnd = YES;
        }
    }
    return isEnd ? 0 : tableView.bounds.size.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(noDataImageView.mas_bottom).offset(30);
    }];
    
    if(tableView == self.tableView1) {
        UILabel *tishiLabel = [[UILabel alloc] init];
        tishiLabel.font = [UIFont systemFontOfSize:12];
        tishiLabel.textColor = RGB_COLOR(204, 204, 204);;
        tishiLabel.backgroundColor = [UIColor clearColor];
        tishiLabel.textAlignment = NSTextAlignmentCenter;
        tishiLabel.text = @"如需债权转让请到PC端操作";
        [footerView addSubview:tishiLabel];
        
        [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(-22);
        }];
    }
    
    return footerView;
}

#pragma mark - BCButtonScrollViewDelegate

- (void)buttonScrollViewDidChangeIndexPage:(NSInteger)pageIndex {
    switch (pageIndex) {
        case 0:
            if (self.transferPageIndex == 0) {
                [self.tableView1.mj_header beginRefreshing];
            }
            break;
        case 1:
            if (self.turnOutPageIndex == 0) {
                [self.tableView2.mj_header beginRefreshing];
            }
            break;
        case 2:
            if (self.changeTypeControl.selectedSegmentIndex == 0) {
                if (self.recoveryPageIndex == 0) {
                    [self.tableView3.mj_header beginRefreshing];
                }
            } else {
                if (self.alreadyRecoveryPageIndex == 0) {
                    [self.tableView3.mj_header beginRefreshing];
                }
            }
            break;
    }
}

@end
