//
//  UIRechargeRecordViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIRechargeRecordViewController.h"

#import "RechargeRecordItemTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import "MyRequest.h"

#import <MJRefresh/MJRefresh.h>

@interface UIRechargeRecordViewController ()

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation UIRechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerCellNibWithClass:[RechargeRecordItemTableViewCell class]];
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    [MyRequest getRechargeRecodeWithPageIndex:self.pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == 0) {
            NSArray *array = [dic objectForKey:@"payList"];
            if (self.pageIndex == 1) {
                [self.displayArray removeAllObjects];
            }
            for (NSDictionary *dic in array) {
               // if (![self.displayArray containsObject:dic]) {
                    [self.displayArray addObject:dic];
                //}
            }
            if (array.count < PageMaxCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        SHOWTOAST(@"充值记录获取失败，请稍后再试");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == (self.displayArray.count + 1)) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        RechargeRecordItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RechargeRecordItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:[self.displayArray objectAtIndex:indexPath.row - 1]];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == self.displayArray.count + 1) {
        return 10;
    } else {
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.displayArray.count != 0)
        return 0;
    
    if(self.pageIndex == 0)
        return 0;
    
    return tableView.bounds.size.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    UIImage *image = [UIImage imageNamed:@"noRecovery.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, (footerView.bounds.size.height - image.size.height - 46)/2 - 70, image.size.width, image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = Color999999;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"暂无充值记录";
    
    [footerView addSubview:label];
    
    return footerView;
}

@end