//
//  UITicketListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITicketListViewController.h"

#import "UITicketExchangeViewController.h"

#import "TicketItemTableViewCell.h"
#import "TicketExchangeTableViewCell.h"

#import "TicketItemModel.h"

#import "MyRequest.h"

#import <MJRefresh/MJRefresh.h>

@interface UITicketListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

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

@property (nonatomic, assign) TicketListType ticketListType;

@property (nonatomic, strong) NSMutableArray *displayUnusedArray;
@property (nonatomic, assign) NSInteger unusedPageIndex;
@property (nonatomic, strong) NSMutableArray *displayUsedArray;
@property (nonatomic, assign) NSInteger usedPageIndex;
@property (nonatomic, strong) NSMutableArray *displayExpireArray;
@property (nonatomic, assign) NSInteger expirePageIndex;

@property (nonatomic, strong) NSString *ruleUrlStr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView3LeftConstraint;

@end

@implementation UITicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView1.tableFooterView = [[UIView alloc] init];
    self.tableView2.tableFooterView = [[UIView alloc] init];
    self.tableView3.tableFooterView = [[UIView alloc] init];
    
    [self.tableView1 registerCellNibWithClass:[TicketItemTableViewCell class]];
    [self.tableView1 registerCellNibWithClass:[TicketExchangeTableViewCell class]];
    [self.tableView2 registerCellNibWithClass:[TicketItemTableViewCell class]];
    [self.tableView3 registerCellNibWithClass:[TicketItemTableViewCell class]];
    
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    self.tableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.unusedPageIndex = 1;
        [self getData];
    }];
    
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.unusedPageIndex++;
        [self getData];
    }];
    
    self.tableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.usedPageIndex = 1;
        [self getData];
    }];
    
    self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.usedPageIndex++;
        [self getData];
    }];
    
    self.tableView3.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.expirePageIndex = 1;
        [self getData];
    }];
    
    self.tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.expirePageIndex++;
        [self getData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTicket) name:RefreshTicketNotification object:nil];
    
    self.displayUnusedArray = [NSMutableArray arrayWithCapacity:0];
    self.displayUsedArray = [NSMutableArray arrayWithCapacity:0];
    self.displayExpireArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView1.mj_header beginRefreshing];
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
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ruleBtnClick:(id)sender {
    [self openWebBrowserWithUrl:self.ruleUrlStr];
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
        if (self.unusedPageIndex == 0) {
            [self.tableView1.mj_header beginRefreshing];
        }
        self.ticketListType = TicketListTypeUnused;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.btn2) {
        self.lineView2.hidden = NO;
        self.btn2.selected = YES;
        if (self.usedPageIndex == 0) {
            [self.tableView2.mj_header beginRefreshing];
        }
        self.ticketListType = TicketListTypeUsed;
        [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
    } else if (sender == self.btn3) {
        self.lineView3.hidden = NO;
        self.btn3.selected = YES;
        if (self.expirePageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        }
        self.ticketListType = TicketListTypeExpire;
        [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:YES];
    }
}

- (void)getData {
    NSInteger pageIndex = 0;
    switch (self.ticketListType) {
        case TicketListTypeUnused: {
            pageIndex = self.unusedPageIndex;
            break;
        }
        case TicketListTypeUsed: {
            pageIndex= self.usedPageIndex;
            break;
        }
        case TicketListTypeExpire: {
            pageIndex = self.expirePageIndex;
            break;
        }
    }
    [MyRequest getTicketListWithTicketType:self.ticketListType pageIndex:pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        if (error.code == 0) {
            self.ruleUrlStr = [dic stringForKey:@"ticketUrl"];
            NSArray *array = [dic mutableArrayValueForKey:@"ticketList"];
            NSString *ticketType = [dic objectForKey:@"type"];
            
            if ([ticketType isEqualToString:@"nouse"]) {
                if (self.unusedPageIndex == 1)
                    [self.displayUnusedArray removeAllObjects];
                if (array.count < PageMaxCount)
                    [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                
                for (NSDictionary *item in array) {
                    TicketItemModel *model = [[TicketItemModel alloc] initWithDic:item];
                    [self.displayUnusedArray addObject:model];
                }
                [self.tableView1 reloadData];
            } else if ([ticketType isEqualToString:@"use"]) {
                if (self.usedPageIndex == 1)
                    [self.displayUsedArray removeAllObjects];
                if (array.count < PageMaxCount)
                    [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                
                for (NSDictionary *item in array) {
                    TicketItemModel *model = [[TicketItemModel alloc] initWithDic:item];
                    [self.displayUsedArray addObject:model];
                }
                [self.tableView2 reloadData];
            } else if ([ticketType isEqualToString:@"expired"]) {
                if (self.expirePageIndex == 1)
                    [self.displayExpireArray removeAllObjects];
                if (array.count < PageMaxCount)
                    [self.tableView3.mj_footer endRefreshingWithNoMoreData];
                
                for (NSDictionary *item in array) {
                    TicketItemModel *model = [[TicketItemModel alloc] initWithDic:item];
                    [self.displayExpireArray addObject:model];
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
    }];
}

#pragma mark - NSNotificationCenter

- (void)refreshTicket {
    [self.tableView1.mj_header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        return self.displayUnusedArray.count + 1;
    } else if (tableView == self.tableView2) {
        return self.displayUsedArray.count;
    } else if (tableView == self.tableView3) {
        return self.displayExpireArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1 && indexPath.row == 0) {
        TicketExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketExchangeTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        TicketItemModel *model = nil;
        if (tableView == self.tableView1) {
            model = [self.displayUnusedArray objectAtIndex:indexPath.row - 1];
        } else if (tableView == self.tableView2) {
            model = [self.displayUsedArray objectAtIndex:indexPath.row];
        } else if (tableView == self.tableView3) {
            model = [self.displayExpireArray objectAtIndex:indexPath.row];
        }
        TicketItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:model ticketListType:self.ticketListType];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1 && indexPath.row == 0) {
        return 50;
    } else {
        return 94;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView1 && indexPath.row == 0) {
        UITicketExchangeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITicketExchangeViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
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
                if (self.unusedPageIndex == 0) {
                    [self.tableView1.mj_header beginRefreshing];
                }
                self.ticketListType = TicketListTypeUnused;
                break;
            case 1:
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                if (self.usedPageIndex == 0) {
                    [self.tableView2.mj_header beginRefreshing];
                }
                self.ticketListType = TicketListTypeUsed;
                break;
            case 2:
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                if (self.expirePageIndex == 0) {
                    [self.tableView3.mj_header beginRefreshing];
                }
                self.ticketListType = TicketListTypeExpire;
                break;
        }
    }
}

@end
