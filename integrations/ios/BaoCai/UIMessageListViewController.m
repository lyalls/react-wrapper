//
//  UIMessageListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIMessageListViewController.h"

#import "UIMessageDetailViewController.h"

#import "MessageItemTableViewCell.h"
#import "EmptyTableViewCell.h"

#import "MessageItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UIMessageListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView1;



@property (nonatomic, assign) NSInteger messagePageIndex;


@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation UIMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    [self.tableView1.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    
    self.tableView1.tableFooterView = [[UIView alloc] init];
    
    
    [self.tableView1 registerCellNibWithClass:[MessageItemTableViewCell class]];
    [self.tableView1 registerCellNibWithClass:[EmptyTableViewCell class]];

    
    self.tableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        self.messagePageIndex = 1;
        [self getData];
    }];
    
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.messagePageIndex++;
        [self getData];
    }];
    
    
    self.messageArray = [NSMutableArray arrayWithCapacity:0];
   
    
    [self.tableView1.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)allReadBtnClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否全部标记已读" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"全部已读", nil];
    [alert show];
    
    [alert clickedButtonEvent:^(NSInteger buttonIndex)
    {
        if(buttonIndex == 1)
        {
            [self setMessageAllRead];
        }
    }];
    
}
-(void)setMessageAllRead
{
     SHOWPROGRESSHUD;
    [MyRequest setMessageListTypeAllReadWithSuccess:^(NSDictionary *dic, BCError *error)
     {
          HIDDENPROGRESSHUD;
         [self.tableView1.mj_header endRefreshing];
         
         [self.tableView1.mj_footer endRefreshing];
        if (error.code == 0)
        {
            NSInteger count = self.messageArray.count;
            for (NSInteger index = 0; index <count; index++) {
                MessageItemModel *model = [self.messageArray objectAtIndex:index];
                model.messageStatus = @"1";
            }
            [self.tableView1 reloadData];
        }
         
     } failure:^(NSError *error)
     {
          HIDDENPROGRESSHUD;
         [self.tableView1.mj_header endRefreshing];
         
         [self.tableView1.mj_footer endRefreshing];
         SHOWTOAST(@"设置全部已读失败，请稍后再试");
     }];
    
}
- (void)getData {
    [MyRequest getMessageListWithMessageListType:MessageListTypeAll pageIndex:_messagePageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView1.mj_header endRefreshing];
        
        [self.tableView1.mj_footer endRefreshing];

        if (error.code == 0) {
            NSArray *messageArray = [dic objectForKey:@"messageList"];
            
            
            if (self.messagePageIndex == 1)
                [self.messageArray removeAllObjects];
            if (messageArray.count < PageMaxCount)
                [self.tableView1.mj_footer endRefreshingWithNoMoreData];
            
            for (NSDictionary *dic in messageArray) {
                MessageItemModel *model = [[MessageItemModel alloc] initWithDic:dic];
                if (![self.messageArray containsObject:model]) {
                    [self.messageArray addObject:model];
                }
                
                [self.tableView1 reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView1.mj_header endRefreshing];
        
        [self.tableView1.mj_footer endRefreshing];
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
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        MessageItemModel *model = [self.messageArray objectAtIndex:indexPath.row - 1];
        
        MessageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageItemTableViewCell class]) forIndexPath:indexPath];
        
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
        
    }
    else
    {
        MessageItemModel *model = [self.messageArray objectAtIndex:indexPath.row - 1];
        //移除
        if ([model.messageStatus isEqualToString:@"0"]) {
            model.messageStatus = @"1";
        }
        UIMessageDetailViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIMessageDetailViewController"];
        viewController.messageModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Scroll view delegate



@end
