//
//  UIMessageListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIMessageListViewController.h"

#import "UIMessageDetailViewController.h"

#import "BCMessageItemTableViewCell.h"
#import "BCEmptyTableViewCell.h"

#import "MessageItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UIMessageListViewController ()

@property (nonatomic, assign) NSInteger messagePageIndex;

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation UIMessageListViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"消息";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"全部已读" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color666666 forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(allReadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self.tableView registerCellWithClass:[BCMessageItemTableViewCell class]];
    [self.tableView registerCellWithClass:[BCEmptyTableViewCell class]];
    
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        self.messagePageIndex = 1;
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.messagePageIndex++;
        [self getData];
    }];
    
    self.messageArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allReadBtnClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否全部标记已读" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"全部已读", nil];
    [alert show];
    
    [alert clickedButtonEvent:^(NSInteger buttonIndex) {
        if(buttonIndex == 1) {
            [self setMessageAllRead];
        }
    }];
}

- (void)setMessageAllRead {
    SHOWPROGRESSHUD;
    [MyRequest setMessageListTypeAllReadWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (error.code == 0) {
            NSInteger count = self.messageArray.count;
            for (NSInteger index = 0; index <count; index++) {
                MessageItemModel *model = [self.messageArray objectAtIndex:index];
                model.messageStatus = @"1";
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        SHOWTOAST(@"设置全部已读失败，请稍后再试");
    }];
    
}
- (void)getData {
    [MyRequest getMessageListWithMessageListType:MessageListTypeAll pageIndex:_messagePageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (error.code == 0) {
            NSArray *messageArray = [dic objectForKey:@"messageList"];
            
            if (self.messagePageIndex == 1)
                [self.messageArray removeAllObjects];
            if (messageArray.count < PageMaxCount)
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            for (NSDictionary *dic in messageArray) {
                MessageItemModel *model = [[MessageItemModel alloc] initWithDic:dic];
                if (![self.messageArray containsObject:model]) {
                    [self.messageArray addObject:model];
                }
                
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        SHOWTOAST(@"消息获取失败，请稍后再试");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageArray.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.messageArray.count;
    if (indexPath.row == 0 || indexPath.row == count + 1) {
        BCEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCEmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    } else {
        MessageItemModel *model = [self.messageArray objectAtIndex:indexPath.row - 1];
        
        BCMessageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMessageItemTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:model];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.messageArray.count;
    if (indexPath.row == 0 || indexPath.row == count + 1) {
        return 10;
    } else {
        return 50;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger count = self.messageArray.count;
    
    if (indexPath.row == 0 || indexPath.row == count + 1) {
        
    } else {
        MessageItemModel *model = [self.messageArray objectAtIndex:indexPath.row - 1];
        //移除
        if ([model.messageStatus isEqualToString:@"0"]) {
            model.messageStatus = @"1";
        }
        UIMessageDetailViewController *viewController = [[UIMessageDetailViewController alloc] init];
        viewController.messageModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
