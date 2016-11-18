//
//  UITransferRecoveryViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITransferRecoveryViewController.h"

#import "MyTransferRecoveryTopTableViewCell.h"
#import "MyTenderDetailPaymentTopTableViewCell.h"
#import "MyTenderDetailPaymentItemTableViewCell.h"

#import "MyRequest.h"

NSString *TransferDetailTopCell = @"DetailTopCell";
NSString *TransferDetailPaymentTopCell = @"DetailPaymentTopCell";

@interface UITransferRecoveryViewController ()

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation UITransferRecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerCellNibWithClass:[MyTransferRecoveryTopTableViewCell class]];
    [self.tableView registerCellNibWithClass:[MyTenderDetailPaymentTopTableViewCell class]];
    [self.tableView registerCellNibWithClass:[MyTenderDetailPaymentItemTableViewCell class]];
    
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
    
    [self.displayArray addObject:TransferDetailTopCell];
    
    if (self.transferItemModel.paymentDetail.count != 0) {
        [self.displayArray addObject:TransferDetailPaymentTopCell];
        for (MyPaymentDetailItemModel *model in self.transferItemModel.paymentDetail) {
            [self.displayArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
}

- (void)getData {
    SHOWPROGRESSHUD;
    [MyRequest getMyTransferDetailWithTenderId:self.transferItemModel.tenderId borrowId:self.transferItemModel.myTransferListItemId success:^(NSDictionary *dic, BCError *error) {
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
        
        if ([cellName isEqualToString:TransferDetailTopCell]) {
            MyTransferRecoveryTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTransferRecoveryTopTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.transferItemModel];
            
            return cell;
        } else if ([cellName isEqualToString:TransferDetailPaymentTopCell]) {
            MyTenderDetailPaymentTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTenderDetailPaymentTopTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        MyTenderDetailPaymentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTenderDetailPaymentItemTableViewCell class]) forIndexPath:indexPath];
        
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
        
        if ([cellName isEqualToString:TransferDetailTopCell]) {
            return 285;
        } else if ([cellName isEqualToString:TransferDetailPaymentTopCell]) {
            return 80;
        }
    } else {
        return 30;
    }
    return tableView.rowHeight;
}

@end
