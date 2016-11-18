//
//  UITransferListViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITransferListViewController.h"
#import "UITransferTurnOutViewController.h"
#import "UITransferRecoveryViewController.h"

#import "MyTenderItemTableViewCell.h"
#import "EmptyTableViewCell.h"

#import "MyTransferListItemModel.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"

@interface UITransferListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeTypeControl;

@property (nonatomic, strong) NSMutableArray *displayTransferArray;
@property (nonatomic, assign) NSInteger transferPageIndex;
@property (nonatomic, strong) NSMutableArray *displayTurnOutArray;
@property (nonatomic, assign) NSInteger turnOutPageIndex;
@property (nonatomic, strong) NSMutableArray *displayRecoveryArray;
@property (nonatomic, assign) NSInteger recoveryPageIndex;
@property (nonatomic, strong) NSMutableArray *displayAlreadyRecoveryArray;
@property (nonatomic, assign) NSInteger alreadyRecoveryPageIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView3LeftConstraint;

@end

@implementation UITransferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self.changeTypeControl setBorder:OrangeColor width:0.5];
    self.changeTypeControl.layer.cornerRadius = 3;
    
    [self.tableView1 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    [self.tableView2 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    [self.tableView3 registerCellNibWithClass:[MyTenderItemTableViewCell class]];
    
    [self.tableView1 registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView2 registerCellNibWithClass:[EmptyTableViewCell class]];
    [self.tableView3 registerCellNibWithClass:[EmptyTableViewCell class]];
    
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    self.tableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.transferPageIndex = 1;
        [self getDataWithType:MyTransferItemTableViewCellTypeTransfer];
    }];
    
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.transferPageIndex++;
        [self getDataWithType:MyTransferItemTableViewCellTypeTransfer];
    }];
    
    self.tableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.turnOutPageIndex = 1;
        [self getDataWithType:MyTransferItemTableViewCellTypeTurnOut];
    }];
    
    self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.turnOutPageIndex++;
        [self getDataWithType:MyTransferItemTableViewCellTypeTurnOut];
    }];
    
    self.tableView3.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            self.recoveryPageIndex = 1;
            [self getDataWithType:MyTransferItemTableViewCellTypeRecovery];
        } else {
            self.alreadyRecoveryPageIndex = 1;
            [self getDataWithType:MyTransferItemTableViewCellTypeAlreadyRecovery];
        }
    }];
    
    self.tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            self.recoveryPageIndex++;
            [self getDataWithType:MyTransferItemTableViewCellTypeRecovery];
        } else {
            self.alreadyRecoveryPageIndex++;
            [self getDataWithType:MyTransferItemTableViewCellTypeAlreadyRecovery];
        }
    }];
    
    self.transferPageIndex = 0;
    self.turnOutPageIndex = 0;
    self.recoveryPageIndex = 0;
    self.alreadyRecoveryPageIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.scrollView.contentSize = CGSizeMake(Screen_width * 3, Screen_width - 64 - 44);
    self.scrollViewContentViewConstraint.constant = Screen_width * 3;
    self.tableView2LeftConstraint.constant = Screen_width;
    self.tableView3LeftConstraint.constant = Screen_width * 2;
    
    if (self.showPageIndex < 4) {
        
        if (self.showPageIndex == 0) {
            [self.tableView1.mj_header beginRefreshing];
        } else {
            self.lineView1.hidden = YES;
            self.btn1.selected = NO;
            if (self.showPageIndex == 1) {
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                [self.tableView2.mj_header beginRefreshing];
                [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:NO];
            } else if (self.showPageIndex == 2 || self.showPageIndex == 3) {
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                self.changeTypeControl.selectedSegmentIndex = self.showPageIndex - 2;
                [self.tableView3.mj_header beginRefreshing];
                [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:NO];
            }
        }
        self.showPageIndex = 4;
    }
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        if (self.transferPageIndex == 0) {
            [self.tableView1.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.btn2) {
        self.lineView2.hidden = NO;
        self.btn2.selected = YES;
        if (self.turnOutPageIndex == 0) {
            [self.tableView2.mj_header beginRefreshing];
        }
        [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
    } else if (sender == self.btn3) {
        self.lineView3.hidden = NO;
        self.btn3.selected = YES;
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (self.recoveryPageIndex == 0) {
                [self.tableView3.mj_header beginRefreshing];
            }
        } else {
            if (self.alreadyRecoveryPageIndex == 0) {
                [self.tableView3.mj_header beginRefreshing];
            }
        }
        [self.scrollView setContentOffset:CGPointMake(Screen_width * 2, 0) animated:YES];
    }
}

- (IBAction)changeTypeControlChange:(id)sender {
    if (self.changeTypeControl.selectedSegmentIndex == 0) {
        if (self.recoveryPageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        } else {
            [self.tableView3 reloadData];
        }
    } else {
        if (self.alreadyRecoveryPageIndex == 0) {
            [self.tableView3.mj_header beginRefreshing];
        } else {
            [self.tableView3 reloadData];
        }
    }
}

- (void)getDataWithType:(MyTransferItemTableViewCellType)myTransferListType {
    NSInteger pageIndex = 0;
    switch (myTransferListType) {
        case MyTransferItemTableViewCellTypeTransfer: {
            pageIndex = self.transferPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeTurnOut: {
            pageIndex = self.turnOutPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeRecovery: {
            pageIndex = self.recoveryPageIndex;
            break;
        }
        case MyTransferItemTableViewCellTypeAlreadyRecovery: {
            pageIndex = self.alreadyRecoveryPageIndex;
            break;
        }
    }
    
    [MyRequest getMyTransferListWithTenderType:myTransferListType pageIndex:pageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        
        if (error.code == 0) {
            NSString *transferType = [dic objectForKey:@"tenderType"];
            NSMutableArray *myTenderArray = [dic objectForKey:@"transferList"];
            if ([transferType isEqualToString:@"changing"]) {
                if (!self.displayTransferArray) {
                    self.displayTransferArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.transferPageIndex == 1) {
                    [self.displayTransferArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayTransferArray containsObject:model]) {
                        [self.displayTransferArray addObject:model];
                    }
                }
                
                [self.tableView1 reloadData];
            } else if ([transferType isEqualToString:@"changYes"]) {
                if (!self.displayTurnOutArray) {
                    self.displayTurnOutArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.turnOutPageIndex == 1) {
                    [self.displayTurnOutArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayTurnOutArray containsObject:model]) {
                        [self.displayTurnOutArray addObject:model];
                    }
                }
                
                [self.tableView2 reloadData];
            } else if ([transferType isEqualToString:@"changRecoverWait"]) {
                if (!self.displayRecoveryArray) {
                    self.displayRecoveryArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.recoveryPageIndex == 1) {
                    [self.displayRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayRecoveryArray containsObject:model]) {
                        [self.displayRecoveryArray addObject:model];
                    }
                }
                
                [self.tableView3 reloadData];
            } else if ([transferType isEqualToString:@"changRecoverYes"]) {
                if (!self.displayAlreadyRecoveryArray) {
                    self.displayAlreadyRecoveryArray = [NSMutableArray arrayWithCapacity:0];
                }
                if (self.alreadyRecoveryPageIndex == 1) {
                    [self.displayAlreadyRecoveryArray removeAllObjects];
                }
                
                for (NSDictionary *item in myTenderArray) {
                    MyTransferListItemModel *model = [[MyTransferListItemModel alloc] initWithDic:item];
                    if (![self.displayAlreadyRecoveryArray containsObject:model]) {
                        [self.displayAlreadyRecoveryArray addObject:model];
                    }
                }
                
                [self.tableView3 reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        SHOWTOAST(@"我的债权转让信息获取失败，请稍后再试");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1)
        return self.displayTransferArray.count + 1;
    else if (tableView == self.tableView2)
        return self.displayTurnOutArray.count + 1;
    else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0)
            return self.displayRecoveryArray.count + 1;
        else
            return self.displayAlreadyRecoveryArray.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    MyTransferListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
        else
            model = [self.displayTransferArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
        else
            model = [self.displayTurnOutArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
        }
    }
    
    if (isEnd) {
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
        
        return cell;
    }
    
    MyTransferItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTransferItemTableViewCellTypeTransfer;
    else if (tableView == self.tableView2)
        type = MyTransferItemTableViewCellTypeTurnOut;
    else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0)
            type = MyTransferItemTableViewCellTypeRecovery;
        else
            type = MyTransferItemTableViewCellTypeAlreadyRecovery;
    }
    
    MyTenderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTenderItemTableViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:model myTransferItemTableViewCellType:type];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
        }
    }
    return isEnd ? 10 : 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isEnd = NO;
    MyTransferListItemModel *model = nil;
    if (tableView == self.tableView1) {
        if (indexPath.row == self.displayTransferArray.count)
            isEnd = YES;
        else
            model = [self.displayTransferArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView2) {
        if (indexPath.row == self.displayTurnOutArray.count)
            isEnd = YES;
        else
            model = [self.displayTurnOutArray objectAtIndex:indexPath.row];
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (indexPath.row == self.displayRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayRecoveryArray objectAtIndex:indexPath.row];
        } else {
            if (indexPath.row == self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            else
                model = [self.displayAlreadyRecoveryArray objectAtIndex:indexPath.row];
        }
    }
    
    if (isEnd) return;
    
    if (tableView == self.tableView3) {
        UITransferRecoveryViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITransferRecoveryViewController"];
        view.transferItemModel = model;
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    
    MyTransferItemTableViewCellType type;
    if (tableView == self.tableView1)
        type = MyTransferItemTableViewCellTypeTransfer;
    else if (tableView == self.tableView2)
        type = MyTransferItemTableViewCellTypeTurnOut;
    
    UITransferTurnOutViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITransferTurnOutViewController"];
    view.transferItemModel = model;
    view.transferItemType = type;
    [self.navigationController pushViewController:view animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL isEnd = NO;
    if (tableView == self.tableView1) {
        if (self.displayTransferArray.count)
            isEnd = YES;
        if (self.transferPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView2) {
        if (self.displayTurnOutArray.count)
            isEnd = YES;
        if (self.turnOutPageIndex == 0)
            isEnd = YES;
    } else if (tableView == self.tableView3) {
        if (self.changeTypeControl.selectedSegmentIndex == 0) {
            if (self.displayRecoveryArray.count)
                isEnd = YES;
            if (self.recoveryPageIndex == 0)
                isEnd = YES;
        } else {
            if (self.displayAlreadyRecoveryArray.count)
                isEnd = YES;
            if (self.alreadyRecoveryPageIndex == 0)
                isEnd = YES;
        }
    }
    return isEnd ? 0 : tableView.bounds.size.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    UIImage *image = [UIImage imageNamed:@"noRecovery.png"];
    NSLog(@"tableView.frame.origin.y = %f",tableView.frame.origin.y);
    NSLog(@"tableView.frame.origin.y = %f",self.tableView3.frame.origin.y);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, 150*(Screen_height/480) - image.size.height+(self.tableView3.frame.origin.y - tableView.frame.origin.y), image.size.width, image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(153, 153, 153);;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"暂无记录";
    
    [footerView addSubview:label];
    
    if(tableView == self.tableView1)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tableView.bounds.size.height - 37, tableView.bounds.size.width, 12)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB_COLOR(204, 204, 204);;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = @"如需债权转让请到PC端操作";
        
        [footerView addSubview:label];
    }
    
    return footerView;
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
                if (self.transferPageIndex == 0) {
                    [self.tableView1.mj_header beginRefreshing];
                }
                break;
            case 1:
                self.lineView2.hidden = NO;
                self.btn2.selected = YES;
                if (self.turnOutPageIndex == 0) {
                    [self.tableView2.mj_header beginRefreshing];
                }
                break;
            case 2:
                self.lineView3.hidden = NO;
                self.btn3.selected = YES;
                if (self.changeTypeControl.selectedSegmentIndex == 0) {
                    if (self.recoveryPageIndex == 0) {
                        [self.tableView3.mj_header beginRefreshing];
                    }
                } else {
                    if (self.alreadyRecoveryPageIndex == 0) {
                        [self.tableView3.mj_header beginRefreshing];
                    }
                }
                break;
        }
    }
}

@end
