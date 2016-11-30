//
//  MyTenderDetailViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIMyTenderDetailViewController.h"

#import "BCMyTenderDetailTopTableViewCell.h"
#import "BCMyTenderDetailPaymentTopTableViewCell.h"
#import "BCMyTenderDetailPaymentItemTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import "MyPaymentDetailItemModel.h"

#import "MyRequest.h"

NSString *DetailTopCell = @"DetailTopCell";
NSString *DetailPaymentTopCell = @"DetailPaymentTopCell";
NSString *DetailEmptyCell = @"DetailEmptyCell";

@interface UIMyTenderDetailViewController ()

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation UIMyTenderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"标的详情";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BackViewColor;
    
    [self.tableView registerCellWithClass:[BCMyTenderDetailTopTableViewCell class]];
    [self.tableView registerCellWithClass:[BCMyTenderDetailPaymentTopTableViewCell class]];
    [self.tableView registerCellWithClass:[BCMyTenderDetailPaymentItemTableViewCell class]];
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
    
    [self reloadTableView];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTableView {
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.displayArray addObject:DetailTopCell];
    
    if (self.tenderItemModel) {
        if (self.tenderItemModel.paymentDetail.count != 0) {
            [self.displayArray addObject:DetailPaymentTopCell];
            for (MyPaymentDetailItemModel *model in self.tenderItemModel.paymentDetail) {
                [self.displayArray addObject:model];
            }
        }
    } else if (self.transferItemModel) {
        if (self.transferItemModel.paymentDetail.count != 0) {
            [self.displayArray addObject:DetailPaymentTopCell];
            for (MyPaymentDetailItemModel *model in self.transferItemModel.paymentDetail) {
                [self.displayArray addObject:model];
            }
        }
    }
    
    [self.displayArray addObject:DetailEmptyCell];
    
    [self.tableView reloadData];
}

- (void)getData {
    if (self.tenderItemModel) {
        SHOWPROGRESSHUD;
        [MyRequest getMyTenderDetailWithTenderId:self.tenderItemModel.tenderId withBorrowId:self.tenderItemModel.myTenderListItemId success:^(NSDictionary *dic, BCError *error) {
            HIDDENPROGRESSHUD;
            if (error.code == 0) {
                [self.tenderItemModel reloadData:dic];
                
                [self reloadTableView];
            } else {
                SHOWTOAST(error.message);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backBtnClick:nil];
                });
            }
        } failure:^(NSError *error) {
            HIDDENPROGRESSHUD;
            SHOWTOAST(@"散标信息获取失败，请稍后再试");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backBtnClick:nil];
            });
        }];
    }
    if (self.transferItemModel) {
        SHOWPROGRESSHUD;
        [MyRequest getMyTenderDetailWithTenderId:self.transferItemModel.tenderId withBorrowId:self.transferItemModel.myTransferListItemId success:^(NSDictionary *dic, BCError *error) {
            HIDDENPROGRESSHUD;
            if (error.code == 0) {
                [self.transferItemModel reloadData:dic];
                
                [self reloadTableView];
            } else {
                SHOWTOAST(error.message);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backBtnClick:nil];
                });
            }
        } failure:^(NSError *error) {
            HIDDENPROGRESSHUD;
            SHOWTOAST(@"转让信息获取失败，请稍后再试");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backBtnClick:nil];
            });
        }];
    }
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
        
        if ([cellName isEqualToString:DetailTopCell]) {
            BCMyTenderDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTenderDetailTopTableViewCell class]) forIndexPath:indexPath];
            
            if (self.tenderItemModel)
                [cell reloadData:self.tenderItemModel];
            if (self.transferItemModel)
                [cell reloadDataWithTransfer:self.transferItemModel];
            
            return cell;
        } else if ([cellName isEqualToString:DetailPaymentTopCell]) {
            BCMyTenderDetailPaymentTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTenderDetailPaymentTopTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        } else if ([cellName isEqualToString:DetailEmptyCell]) {
            BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        BCMyTenderDetailPaymentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTenderDetailPaymentItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:(MyPaymentDetailItemModel *)cellType];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellType = [self.displayArray objectAtIndex:indexPath.row];
    if ([cellType isKindOfClass:[NSString class]]) {
        NSString *cellName = (NSString *)cellType;
        
        if ([cellName isEqualToString:DetailTopCell]) {
            return 245;
        } else if ([cellName isEqualToString:DetailPaymentTopCell]) {
            return 80;
        } else if ([cellName isEqualToString:DetailEmptyCell]) {
            return 10;
        }
    } else {
        return 30;
    }
    return tableView.rowHeight;
}

@end
