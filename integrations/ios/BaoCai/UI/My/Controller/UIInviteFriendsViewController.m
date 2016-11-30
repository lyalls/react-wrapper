//
//  UIInviteFriendsViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIInviteFriendsViewController.h"

#import "UIShareViewController.h"

#import "InviteFriendsTableViewCell.h"

#import "InviteFriendsModel.h"

#import "MyRequest.h"

#import <MJRefresh/MJRefresh.h>

@interface UIInviteFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *waitTotalRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTotalRewardLabel;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;

@property (nonatomic, strong) InviteFriendsModel *model;

@property (nonatomic, assign) NSInteger inviteRecordPageIndex;

@end

@implementation UIInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerCellNibWithClass:[InviteFriendsTableViewCell class]];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.inviteRecordPageIndex = 1;
        
        [self getInviteRecordData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.inviteRecordPageIndex++;
        
        [self getInviteRecordData];
    }];
    
    self.model = [[InviteFriendsModel alloc] init];
    
    [self getData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ruleBtnClick:(id)sender {
    [self openWebBrowserWithUrl:self.model.invitationRuleUrl model:self.model];
}

- (IBAction)shareBtnClick:(id)sender {
    UIShareViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIShareViewController"];
    view.shareTitle = self.model.invitationTitle;
    view.shareDesc = self.model.invitationDesc;
    view.shareUrl = self.model.invitationUrl;
    view.shareImageUrl = self.model.invitationImageUrl;
    [self presentTranslucentViewController:view animated:YES];
}

- (void)getData {
    SHOWPROGRESSHUD;
    [MyRequest getInviteFriendsDataWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            [self.model reloadInviteFriendsData:dic];
            
            self.waitTotalRewardLabel.text = self.model.waitTotalReward;
            self.receiveTotalRewardLabel.text = self.model.receiveTotalReward;
            [self.invitationBtn setTitle:[NSString stringWithFormat:@"分享我的邀请码 %@", self.model.invitationCode] forState:UIControlStateNormal];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"获取邀请好友信息失败，请稍后再试");
    }];
}

- (void)getInviteRecordData {
    [MyRequest getInviteFriendsListDataWithPageIndex:self.inviteRecordPageIndex success:^(NSDictionary *dic, BCError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error.code == 0) {
            if (self.inviteRecordPageIndex == 1) {
                self.model.invitationRecordList = [NSMutableArray arrayWithCapacity:0];
            }
            
            NSArray *array = [dic objectForKey:@"invitationRecordList"];
            if (array.count < PageMaxCount)
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            for (NSDictionary *dic in array) {
                InviteFriendsListItemModel *item = [[InviteFriendsListItemModel alloc] initWithDic:dic];
                [self.model.invitationRecordList addObject:item];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.invitationRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InviteFriendsTableViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:[self.model.invitationRecordList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(!self.model.invitationRecordList)
        return 0;
    if(self.model.invitationRecordList.count != 0)
        return 0;
    return tableView.bounds.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    UIImage *image = [UIImage imageNamed:@"inviteFriends.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, (SCREEN_HEIGHT == 480)?40:120, image.size.width, image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+27, tableView.bounds.size.width, 14)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"您还未邀请好友加入";
    
    [footerView addSubview:label];
    
    NSString * title = @"点击查看邀请攻略";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
    //修改某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,8)];
    //修改某个范围内字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:RGBA_COLOR(255,165,72, 1)  range:NSMakeRange(0,8)];
    //在某个范围内增加下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"点击查看邀请攻略" forState:UIControlStateNormal];
//    [btn setTitle:@"点击查看邀请攻略" forState:UIControlStateHighlighted];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
//    [btn setTitleColor:RGB_COLOR(255,165,72) forState:UIControlStateNormal];
//    [btn setTitleColor:RGB_COLOR(255,165,72) forState:UIControlStateNormal];
    btn.frame = CGRectMake((footerView.bounds.size.width - 150)/2, CGRectGetMaxY(label.frame)+17, 150, 30);
    [btn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;

}

@end
