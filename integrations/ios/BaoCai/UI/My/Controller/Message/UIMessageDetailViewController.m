//
//  UIMessageDetailViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIMessageDetailViewController.h"

#import "BCMessageDetailTopTableViewCell.h"
#import "BCMessageDetailContentTableViewCell.h"

#import "MyRequest.h"

NSString *MessageDetailTopCell = @"MessageDetailTopCell";
NSString *MessageDetailContentCell = @"MessageDetailContentCell";

@interface UIMessageDetailViewController ()

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation UIMessageDetailViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"取消详情";
    
    BCBackButton *backBtn = [[BCBackButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.view.backgroundColor = BackViewColor;
    self.tableView.backgroundColor = BackViewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellWithClass:[BCMessageDetailTopTableViewCell class]];
    [self.tableView registerCellWithClass:[BCMessageDetailContentTableViewCell class]];
    
    [self reloadTableView];
    
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

- (void)reloadTableView {
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.displayArray addObject:MessageDetailTopCell];
    
    if (self.messageModel.messageContent && self.messageModel.messageContent.length != 0) {
        [self.displayArray addObject:MessageDetailContentCell];
    }
    
    [self.tableView reloadData];
}

- (void)getData {
    if (self.messageModel.messageContent && self.messageModel.messageContent.length != 0) {
        return;
    }
    SHOWPROGRESSHUD;
    [MyRequest getMessageDetailWithMessageId:self.messageModel.messageId success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [self.messageModel reloadData:dic];
            
            [self reloadTableView];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
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
    NSString *cellName = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellName isEqualToString:MessageDetailTopCell]) {
        BCMessageDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMessageDetailTopTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:self.messageModel];
        
        return cell;
    } else if ([cellName isEqualToString:MessageDetailContentCell]) {
        BCMessageDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCMessageDetailContentTableViewCell class]) forIndexPath:indexPath];
        
        [cell reloadData:self.messageModel];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([cellName isEqualToString:MessageDetailTopCell]) {
        return 85;
    }
    if ([cellName isEqualToString:MessageDetailContentCell]) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
        CGRect frame = [self.messageModel.messageContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        return frame.size.height + 40;
    }
    return tableView.rowHeight;
}

@end
