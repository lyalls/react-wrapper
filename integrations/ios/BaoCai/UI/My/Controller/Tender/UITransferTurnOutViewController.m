//
//  UITransferTurnOutViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITransferTurnOutViewController.h"

#import "BCMyTransferTransferTableViewCell.h"
#import "BCMyTransferTurnOutTableViewCell.h"

#import "UIMyTenderDetailViewController.h"

@interface UITransferTurnOutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation UITransferTurnOutViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"已转出资产详情";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackViewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
    }];
    
    self.checkBtn = [[UIButton alloc] init];
    [self.checkBtn setTitle:@"查看标的原始信息" forState:UIControlStateNormal];
    [self.checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.checkBtn.backgroundColor = OrangeColor;
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.checkBtn];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(44);
        make.left.equalTo(15);
        make.right.bottom.equalTo(-15);
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(15);
    }];
}

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
    
    [self.tableView registerCellWithClass:[BCMyTransferTransferTableViewCell class]];
    [self.tableView registerCellWithClass:[BCMyTransferTurnOutTableViewCell class]];
    
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
    UIMyTenderDetailViewController *view = [[UIMyTenderDetailViewController alloc] init];
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
        BCMyTransferTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTransferTransferTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:self.transferItemModel];
        
        return cell;
    }
    BCMyTransferTurnOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMyTransferTurnOutTableViewCell class]) forIndexPath:indexPath];
    
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
