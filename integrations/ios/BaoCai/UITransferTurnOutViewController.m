//
//  UITransferTurnOutViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITransferTurnOutViewController.h"

#import "MyTransferTransferTableViewCell.h"
#import "MyTransferTurnOutTableViewCell.h"
#import "UIMyTenderDetailViewController.h"

@interface UITransferTurnOutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation UITransferTurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.transferItemType == MyTransferItemTableViewCellTypeTransfer) {
        self.title = @"转让中资产详情";
        self.checkBtn.layer.cornerRadius = 4;
    } else {
        self.checkBtn.hidden = YES;
    }
    
    [self.tableView registerCellNibWithClass:[MyTransferTransferTableViewCell class]];
    [self.tableView registerCellNibWithClass:[MyTransferTurnOutTableViewCell class]];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkBtnClick:(id)sender {
    UIMyTenderDetailViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIMyTenderDetailViewController"];
    view.transferItemModel = self.transferItemModel;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)getData {
    SHOWPROGRESSHUD;
    [MyRequest getMyTransferDetailWithTenderId:self.transferItemModel.tenderId borrowId:self.transferItemModel.myTransferListItemId success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [self.transferItemModel reloadData:dic];
            
            [self.tableView reloadData];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.transferItemType == MyTransferItemTableViewCellTypeTransfer) {
        MyTransferTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTransferTransferTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:self.transferItemModel];
        
        return cell;
    }
    MyTransferTurnOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTransferTurnOutTableViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:self.transferItemModel];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.transferItemType == MyTransferItemTableViewCellTypeTransfer) {
        return 225;
    }
    return 305;
}

@end
