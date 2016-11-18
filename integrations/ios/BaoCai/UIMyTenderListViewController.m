//
//  UIMyTenderListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIMyTenderListViewController.h"
#import "UIMyTenderDetailViewController.h"
#import "UITenderDetailViewController.h"

#import "MyTenderItemTableViewCell.h"
#import "EmptyTableViewCell.h"

#import "MyTenderListItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UIMyTenderListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (nonatomic, strong) NSMutableArray *displayRecoveryArray;
@property (nonatomic, assign) NSInteger recoveryPageIndex;
@property (nonatomic, strong) NSMutableArray *displayTenderArray;
@property (nonatomic, assign) NSInteger tenderPageIndex;
@property (nonatomic, strong) NSMutableArray *displayAlreadyRecoveryArray;
@property (nonatomic, assign) NSInteger alreadyRecoveryPageIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView3LeftConstraint;

@end

@implementation UIMyTenderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self.tableView1 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    [self.tableView2 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    [self.tableView3 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    
    [self.tableView1 registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView2 registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView3 registerCellNibWithClass:[EmptyTableViewCell class]];
    
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.scrollView.contentSize = CGSizeMake(Screen_width * 3, Screen_width - 64 - 44);
    self.scrollViewContentViewConstraint.constant = Screen_width * 3;
    self.tableView2LeftConstraint.constant = Screen_width;
    self.tableView3LeftConstraint.constant = Screen_width * 2;
    
    if (self.showPageIndex < 3) {
        if (self.showPageIndex == 0) {
            [self.tableView1.mj_header beginRefreshing];
        } else {
            self.lineView1.hidden = YES;
            self.btn1.selected = NO;
            if (self.showPageIndex == 1) {
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                [self.tableView2.mj_header beginRefreshing];
                [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:NO];
            } else if (self.showPageIndex == 2) {
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                [self.tableView3.mj_header beginRefreshing];
                [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:NO];
            }
        }
        self.showPageIndex = 3;
    }
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    if (self.isPopToRootViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)typeBtnClick:(UIButton *)sender {
    self.lineView1.hidden = YES;
    self.btn1.selected = NO;
    self.lineView2.hidden = YES;
    self.btn2.selected = NO;
    self.lineView3.hidden = YES;
    self.btn3.selected = NO;
    
    if (sender == self.btn1) {
        self.lineView1.hidden = NO;
        self.btn1.selected = YES;
        if (self.recoveryPageIndex == 0) {
            [self.tableView1.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.btn2) {
        self.lineView2.hidden = NO;
        self.btn2.selected = YES;
        if (self.tenderPageIndex == 0) {
            [self.tableView2.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
    } else if (sender == self.btn3) {
        self.lineView3.hidden = NO;
        self.btn3.selected = YES;
        if (self.alreadyRecoveryPageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:YES];
    }
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
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    }
    
    MyTenderItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTenderItemTableViewCellTypeRecovery;
    else if (tableView == self.tableView2)
        type = MyTenderItemTableViewCellTypeTender;
    else if (tableView == self.tableView3)
        type = MyTenderItemTableViewCellTypeAlreadyRecovery;
    
    MyTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTenderItemTableViewCell class]) forIndexPath:indexPath];
    
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
        UITenderDetailViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UITenderDetailViewController"];
        viewController.tenderId = model.myTenderListItemId;
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    UIMyTenderDetailViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIMyTenderDetailViewController"];
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

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    UIImage *image = [UIImage imageNamed:@"noRecovery.png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, 150*(Screen_height/480) - image.size.height+60, image.size.width, image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(153, 153, 153);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"暂无记录";
    
    [footerView addSubview:label];
    
    NSString * title = @"开启财富之旅";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.backgroundColor = RGB_COLOR(255, 106, 32);
    btn.frame = CGRectMake((footerView.bounds.size.width - 230)/2, CGRectGetMaxY(label.frame)+60, 230, 45);
    [btn addTarget:self action:@selector(openWealthClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    return footerView;
    
}
-(void)openWealthClick:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        int currentPage = floor((scrollView.contentOffset.x - Screen_width / 2) / Screen_width) + 1;
        
        self.lineView1.hidden = YES;
        self.btn1.selected = NO;
        self.lineView2.hidden = YES;
        self.btn2.selected = NO;
        self.lineView3.hidden = YES;
        self.btn3.selected = NO;
        
        switch (currentPage) {
            case 0:
                self.lineView1.hidden = NO;
                self.btn1.selected = YES;
                if (self.recoveryPageIndex == 0) {
                    [self.tableView1.mj_header beginRefreshing];
                }
                break;
            case 1:
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                if (self.tenderPageIndex == 0) {
                    [self.tableView2.mj_header beginRefreshing];
                }
                break;
            case 2:
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                if (self.alreadyRecoveryPageIndex == 0) {
                    [self.tableView3.mj_header beginRefreshing];
                }
                break;
        }
    }
}

@end
