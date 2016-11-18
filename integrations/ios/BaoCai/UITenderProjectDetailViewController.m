//
//  UITenderProjectDetailViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITenderProjectDetailViewController.h"

#import "InvestmentRecordTableViewCell.h"
#import "FullRecordTableViewCell.h"
#import "EmptyTableViewCell.h"

#import <MJRefresh/MJRefresh.h>

#import "InvestmentRecordModel.h"

#import "TenderRequest.h"

#import "UIViewController+WebView.h"

@interface UITenderProjectDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView1;
@property (weak, nonatomic) IBOutlet UIWebView *webView2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *isFullReward;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic, assign) NSInteger pageIndex;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView3LeftConstraint;

@end

@implementation UITenderProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerCellNibWithClass:[InvestmentRecordTableViewCell class]];
    [self.tableView registerCellNibWithClass:[FullRecordTableViewCell class]];
    [self.tableView registerCellNibWithClass:[EmptyTableViewCell class]];
    
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self getData];
    }];
    
    if ([self.itemModel.detailList objectAtIndex:0]) {
        [self.btn1 setTitle:[[self.itemModel.detailList objectAtIndex:0] objectForKey:@"title"] forState:UIControlStateNormal];
        [self.webView1 loadRequest:[self getWebBrowserRequestWithUrl:[[self.itemModel.detailList objectAtIndex:0] objectForKey:@"url"]]];
    }
    
    if ([self.itemModel.detailList objectAtIndex:1]) {
        [self.btn2 setTitle:[[self.itemModel.detailList objectAtIndex:1] objectForKey:@"title"] forState:UIControlStateNormal];
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
    
    self.scrollView.contentSize = CGSizeMake(Screen_width * 3, Screen_width - 64 - 44);
    self.scrollViewContentViewConstraint.constant = Screen_width * 3;
    self.view2LeftConstraint.constant = Screen_width;
    self.tableView3LeftConstraint.constant = Screen_width * 2;
    
    if (self.isTenderRecord) {
        self.isTenderRecord = NO;
        self.lineView1.hidden = YES;
        self.btn1.selected = NO;
        self.lineView3.hidden = NO;
        self.btn3.selected = YES;
        [self.tableView.mj_header beginRefreshing];
        [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:NO];
    }
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
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.btn2) {
        self.lineView2.hidden = NO;
        self.btn2.selected = YES;
        [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
    } else if (sender == self.btn3) {
        self.lineView3.hidden = NO;
        self.btn3.selected = YES;
        if (self.pageIndex == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:YES];
    }
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
                break;
            case 1:
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                break;
            case 2:
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                if (self.pageIndex == 0) {
                    [self.tableView.mj_header beginRefreshing];
                }
                break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pageIndex == 0) {
        return self.displayArray.count;
    }
    return self.displayArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.itemModel.isFull) {
            FullRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullRecordTableViewCell class]) forIndexPath:indexPath];
            
            [cell reloadData:self.isFullReward];
            
            return cell;
        } else {
            EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
            
            return cell;
        }
    } else if (indexPath.row == self.displayArray.count + 1) {
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        InvestmentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InvestmentRecordTableViewCell class]) forIndexPath:indexPath];
        
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, 150*(Screen_height/480) - image.size.height+60, image.size.width, image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(153, 153, 153);;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"暂无投资记录";
    
    [footerView addSubview:label];
    
    return footerView;
}

@end
