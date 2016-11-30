//
//  UITenderProjectDetailViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITenderProjectDetailViewController.h"

#import "BCInvestmentRecordTableViewCell.h"
#import "BCFullRecordTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import <MJRefresh/MJRefresh.h>

#import "InvestmentRecordModel.h"

#import "TenderRequest.h"

#import "UIViewController+WebView.h"

#import "BCButtonScrollView.h"

@interface UITenderProjectDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, BCButtonScrollViewDelegate>

@property (nonatomic, strong) BCButtonScrollView *buttonScrollView;

@property (nonatomic, strong) UIWebView *webView1;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView1;
@property (nonatomic, strong) UIWebView *webView2;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView2;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *isFullReward;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UIView *loginView;

@end

@implementation UITenderProjectDetailViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"项目详情";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
    
    self.webView1 = [[UIWebView alloc] init];
    self.webView1.delegate = self;
    self.webView1.opaque = NO;
    self.webView1.backgroundColor = [UIColor clearColor];
    
    self.loadingView1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.webView1 addSubview:self.loadingView1];
    
    [self.loadingView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
    }];
    
    self.webView2 = [[UIWebView alloc] init];
    self.webView2.delegate = self;
    self.webView2.opaque = NO;
    self.webView2.backgroundColor = [UIColor clearColor];
    
    self.loadingView2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.webView2 addSubview:self.loadingView2];
    
    [self.loadingView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
    }];
    
    self.loginView = [[UIView alloc] init];
    [self.webView2 addSubview:self.loginView];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(200, 200));
        make.centerX.equalTo(0);
        make.centerY.equalTo(-40);
    }];
    
    UIImageView *loginImageView = [[UIImageView alloc] init];
    loginImageView.image = [UIImage imageNamed:@"projectDetail.png"];
    [self.loginView addSubview:loginImageView];
    
    [loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(90, 72));
        make.centerX.equalTo(0);
        make.top.equalTo(0);
    }];
    
    UILabel *loginLabel = [[UILabel alloc] init];
    loginLabel.text = @"请登录后查看";
    loginLabel.textColor = Color999999;
    loginLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.loginView addSubview:loginLabel];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(loginImageView.mas_bottom).mas_offset(25);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = OrangeColor;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(45);
        make.left.right.bottom.equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackViewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.buttonScrollView = [[BCButtonScrollView alloc] init];
    self.buttonScrollView.delegate = self;
    [self.buttonScrollView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.view addSubview:self.buttonScrollView];
    
    [self.buttonScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
    [self.tableView registerCellWithClass:[BCInvestmentRecordTableViewCell class]];
    [self.tableView registerCellWithClass:[BCFullRecordTableViewCell class]];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self getData];
    }];
    
    if ([self.itemModel.detailList objectAtIndex:0]) {
        [self.webView1 loadRequest:[self getWebBrowserRequestWithUrl:[[self.itemModel.detailList objectAtIndex:0] objectForKey:@"url"]]];
    }
    
    BCButtonScrollItemModel *model1 = [[BCButtonScrollItemModel alloc] init];
    model1.buttonName = [[self.itemModel.detailList objectAtIndex:0] objectForKey:@"title"];
    model1.displayView = self.webView1;
    model1.isSelected = !self.isTenderRecord;
    
    BCButtonScrollItemModel *model2 = [[BCButtonScrollItemModel alloc] init];
    model2.buttonName = [[self.itemModel.detailList objectAtIndex:1] objectForKey:@"title"];
    model2.displayView = self.webView2;
    
    BCButtonScrollItemModel *model3 = [[BCButtonScrollItemModel alloc] init];
    model3.buttonName = @"投资记录";
    model3.displayView = self.tableView;
    model3.isSelected = self.isTenderRecord;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [array addObject:model1];
    [array addObject:model2];
    [array addObject:model3];
    
    [self.buttonScrollView reloadDisplay:array];
    
    if (self.isTenderRecord) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    if ([UserInfoModel sharedModel].token.length != 0) {
        self.loginView.hidden = YES;
        if ([self.itemModel.detailList objectAtIndex:1]) {
            [self.webView2 loadRequest:[self getWebBrowserRequestWithUrl:[[self.itemModel.detailList objectAtIndex:1] objectForKey:@"url"]]];
        }
    } else {
        self.loginView.hidden = NO;
        self.loadingView2.hidden = YES;
    }
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    self.pageIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccessNotification object:nil];
    [self toLoginViewController];
}

- (void)getData {
    [TenderRequest getTenderRecordListWithTenderId:self.itemModel.tenderId pageIndex:self.pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == 0) {
            NSArray *array = [dic objectForKey:@"tenderRecordList"];
            if (self.pageIndex == 1) {
                [self.displayArray removeAllObjects];
            }
            
            if (array.count < PageMaxCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            self.isFullReward = [dic stringForKey:@"isFullReward"];
            for (NSDictionary *itemDic in array) {
                [self.displayArray addObject:[[InvestmentRecordModel alloc] initWithDic:itemDic]];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        SHOWTOAST(@"投资记录获取失败，请稍后再试");
    }];
}

#pragma mark - NSNotificationCenter

- (void)loginSuccess {
    self.loginView.hidden = YES;
    if ([self.itemModel.detailList objectAtIndex:1]) {
        [self.webView2 loadRequest:[self getWebBrowserRequestWithUrl:[[self.itemModel.detailList objectAtIndex:1] objectForKey:@"url"]]];
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView == self.webView1) {
        self.loadingView1.hidden = NO;
        [self.loadingView1 startAnimating];
    }
    if (webView == self.webView2) {
        self.loadingView2.hidden = NO;
        [self.loadingView2 startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == self.webView1) {
        self.loadingView1.hidden = YES;
        [self.loadingView1 stopAnimating];
    }
    if (webView == self.webView2) {
        self.loadingView2.hidden = YES;
        [self.loadingView2 stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView == self.webView1) {
        self.loadingView1.hidden = YES;
        [self.loadingView1 stopAnimating];
    }
    if (webView == self.webView2) {
        self.loadingView2.hidden = YES;
        [self.loadingView2 stopAnimating];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {  
    return [self handelWebBrowserJsonMethod:request.URL.absoluteString];
}

#pragma mark - BCButtonScrollViewDelegate

- (void)buttonScrollViewDidChangeIndexPage:(NSInteger)pageIndex {
    if (pageIndex == 2) {
        if (self.pageIndex == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.itemModel.isFull) {
            BCFullRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCFullRecordTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.isFullReward];
            
            return cell;
        } else {
            BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else if (indexPath.row == self.displayArray.count + 1) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        BCInvestmentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCInvestmentRecordTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:[self.displayArray objectAtIndex:indexPath.row - 1]];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.itemModel.isFull) {
            return 40;
        } else {
            return 10;
        }
    } else if (indexPath.row == self.displayArray.count + 1) {
        return 10;
    } else {
        return 56;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.displayArray.count != 0)
        return 0;
    
    if (self.pageIndex == 0)
        return 0;
    
    return tableView.bounds.size.height;
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
    noDataLabel.text = @"暂无投资记录";
    [centerView addSubview:noDataLabel];
    
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(noDataImageView.mas_bottom).offset(30);
    }];
    
    return footerView;
}

@end
