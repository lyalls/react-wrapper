//
//  NewViewController.m
//  StoreBoardDemo
//
//  Created by lishuo on 16/8/24.
//  Copyright © 2016年 lishuo. All rights reserved.
//

#import "UINewTicketListViewController.h"
#import "NewTicketTableViewCell.h"
#import "TicketExchangeTableViewCell.h"
#import "UITicketExchangeViewController.h"
#import "TicketTipTableViewCell.h"

#import <MJRefresh/MJRefresh.h>

#import "MyRequest.h"
#import "MyCoupon.h"




@interface UINewTicketListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *redUnuseViewLeading;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *redUsedTableViewLeading;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *secondSegmentLeading;


@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UIButton *addRateBtn;
@property (weak,nonatomic) IBOutlet UIButton *redRateBtn;

@property (weak,nonatomic) IBOutlet UIButton *exchangeBtn;

@property (weak,nonatomic) IBOutlet UILabel *line1;
@property (weak,nonatomic) IBOutlet UILabel *line2;

@property (weak,nonatomic) IBOutlet UISegmentedControl *segment1;
@property (weak,nonatomic) IBOutlet UISegmentedControl *segment2;

@property (weak,nonatomic) IBOutlet UITableView *raiseTableView1;
@property (weak,nonatomic) IBOutlet UITableView *raiseTableView2;

@property (weak,nonatomic) IBOutlet UITableView *redTableView1;
@property (weak,nonatomic) IBOutlet UIView *redTableSuperView;
@property (weak,nonatomic) IBOutlet UITableView *redTableView2;



@property (nonatomic,assign) NSInteger raiseCouponUnusePageIndex;
@property (nonatomic,assign) NSInteger redpacketCouponUnusePageIndex;

@property (nonatomic,assign) NSInteger raiseCouponUsedPageIndex;
@property (nonatomic,assign) NSInteger redpacketCouponUsedPageIndex;

@property (nonatomic,strong) NSMutableArray *raiseUnusedArray;
@property (nonatomic,strong) NSMutableArray *raiseUsedArray;
@property (nonatomic,strong) NSMutableArray *redUnusedArray;
@property (nonatomic,strong) NSMutableArray *redUsedArray;

@property (nonatomic,assign) NSInteger addRateCurrentStatus;//标示加息券已读未读
@property (nonatomic,assign) NSInteger redRateCurrentStatus;//标记红包券已读未读
@property (nonatomic,strong) NSString *raiseRegular;
@property (nonatomic,strong) NSString *redRegular;

@end

@implementation UINewTicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self setNavigationBarWithColor:[UIColor whiteColor]];
    _addRateCurrentStatus = TicketListTypeUnused;
    _redRateCurrentStatus = TicketListTypeUnused;
    _raiseUnusedArray = [NSMutableArray arrayWithCapacity:0];
    _raiseUsedArray = [NSMutableArray arrayWithCapacity:0];
    _redUnusedArray  = [NSMutableArray arrayWithCapacity:0];
    _redUsedArray  = [NSMutableArray arrayWithCapacity:0];
    
     [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    [self.raiseTableView1 registerCellNibWithClass:[NewTicketTableViewCell class]];
    [self.raiseTableView1 registerCellNibWithClass:[TicketTipTableViewCell class]];
    [self.raiseTableView2 registerCellNibWithClass:[NewTicketTableViewCell class]];
    
    [self.redTableView1 registerCellNibWithClass:[NewTicketTableViewCell class]];
    [self.redTableView1 registerCellNibWithClass:[TicketTipTableViewCell class]];
    [self.redTableView2 registerCellNibWithClass:[NewTicketTableViewCell class]];
    
    [self.raiseTableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.raiseTableView2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.redTableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.redTableView2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    
    
    self.raiseTableView1.tableFooterView = [[UIView alloc] init];
    self.raiseTableView2.tableFooterView = [[UIView alloc] init];
    
    self.redTableView1.tableFooterView = [[UIView alloc] init];
    self.redTableView2.tableFooterView = [[UIView alloc] init];
    
    self.raiseTableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
               _raiseCouponUnusePageIndex = 1;
        [self getDataWithType:_addRateCurrentStatus];
    }];
    
    self.raiseTableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _raiseCouponUnusePageIndex++;
        [self getDataWithType:_addRateCurrentStatus];
    }];
    
    self.raiseTableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{

        _raiseCouponUsedPageIndex = 1;
        [self getDataWithType:_addRateCurrentStatus];
    }];
    
    self.raiseTableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _raiseCouponUsedPageIndex++;
        [self getDataWithType:_addRateCurrentStatus];
    }];
    
    
    self.redTableView1.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _redpacketCouponUnusePageIndex = 1;
        [self getDataWithType:_redRateCurrentStatus];
    }];
    
    self.redTableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _redpacketCouponUnusePageIndex++;
        [self getDataWithType:_redRateCurrentStatus];
    }];
    
    self.redTableView2.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        _redpacketCouponUsedPageIndex = 1;
        [self getDataWithType:_redRateCurrentStatus];
    }];
    
    self.redTableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _redpacketCouponUsedPageIndex++;
        [self getDataWithType:_redRateCurrentStatus];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTicket) name:RefreshTicketNotification object:nil];
    
    if(_couponType == RedPacketCoupon)
        [self typeBtnClick:_redRateBtn];
    else
        [self typeBtnClick:_addRateBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    _scrollView.contentSize = CGSizeMake(Screen_width * 2, 0);
    self.viewWidth.constant = self.view.bounds.size.width*2;
    self.redUnuseViewLeading.constant = self.view.bounds.size.width;
    self.redUsedTableViewLeading.constant = self.view.bounds.size.width;
    self.secondSegmentLeading.constant = self.view.bounds.size.width+25;
    
    if(_couponType == RedPacketCoupon)
        [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
}

-(IBAction)segmentClick:(id)sender
{
    UISegmentedControl *segment = sender;
    NSInteger selectedIndex = [segment selectedSegmentIndex];
    
    if(segment == _segment1)
    {
        _addRateCurrentStatus = selectedIndex;
        
    }
    else
    {
        
        _redRateCurrentStatus = selectedIndex;
    }
    [self reLoadData];
   
}

-(IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
   
}
-(IBAction)exchangeBtnClick:(id)sender
{
    UITicketExchangeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITicketExchangeViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(IBAction)ruleBtnClick:(id)sender
{
    if(_couponType == RaiseInterestRatesCoupon)
        [self openWebBrowserWithUrl:self.raiseRegular];
    else
        [self openWebBrowserWithUrl:self.redRegular];
}
- (void)refreshTicket {
    [self.redTableView1.mj_header beginRefreshing];
}
- (IBAction)typeBtnClick:(UIButton *)sender
{
        self.line1.hidden = YES;
        self.addRateBtn.selected = NO;
        self.line2.hidden = YES;
        self.redRateBtn.selected = NO;
        
        
        if (sender == self.addRateBtn)
        {
            self.line1.hidden = NO;
            self.addRateBtn.selected = YES;
            
            _couponType = RaiseInterestRatesCoupon;
            
            if(_addRateCurrentStatus == TicketListTypeUnused)
            {
                self.raiseTableView1.hidden = NO;
                self.raiseTableView2.hidden = YES;
                if (self.raiseCouponUnusePageIndex == 0) {
                    [self.raiseTableView1.mj_header beginRefreshing];
                }
                else
                {
                    [self.raiseTableView1 reloadData];
                }
            }
            else if(_addRateCurrentStatus == TicketListTypeUsed)
            {
                self.raiseTableView1.hidden = YES;
                self.raiseTableView2.hidden = NO;
                
                if(self.raiseCouponUsedPageIndex == 0)
                {
                    [self.raiseTableView2.mj_header beginRefreshing];
                }
                else
                {
                    [self.raiseTableView2 reloadData];
                }
            }
            
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (sender == self.redRateBtn)
        {
            
            self.line2.hidden = NO;
            self.redRateBtn.selected = YES;
            
            _couponType = RedPacketCoupon;
            if(_redRateCurrentStatus == TicketListTypeUnused)
            {
                self.redTableSuperView.hidden = NO;
                self.redTableView2.hidden = YES;
                if (self.redpacketCouponUnusePageIndex == 0) {
                    [self.redTableView1.mj_header beginRefreshing];
                }
                else
                {
                    [self.redTableView1 reloadData];
                }
                
            }
            else if(_redRateCurrentStatus == TicketListTypeUsed)
            {
                self.redTableSuperView.hidden = YES;
                self.redTableView2.hidden = NO;
                if(self.redpacketCouponUsedPageIndex == 0)
                {
                    [self.redTableView2.mj_header beginRefreshing];
                }
                else
                {
                    [self.redTableView2 reloadData];
                }
            }
            [self.scrollView setContentOffset:CGPointMake(Screen_width, 0) animated:YES];
        }
    
}

- (void)getDataWithType:(TicketListType)myTicketListType {
    NSInteger pageIndex = 0;
    switch (myTicketListType) {
        case TicketListTypeUnused: {
            if (_couponType == RaiseInterestRatesCoupon) {
                pageIndex = _raiseCouponUnusePageIndex;
            }
            else
                pageIndex = _redpacketCouponUnusePageIndex;
            break;
        }
        case TicketListTypeUsed: {
            if (_couponType == RaiseInterestRatesCoupon) {
                pageIndex = _raiseCouponUsedPageIndex;
            }
            else
                pageIndex = _redpacketCouponUsedPageIndex;
            break;
            break;
        }
        default:
            break;
    }
    
    [MyRequest getCouponListWithType:_couponType andTicketListType:myTicketListType pageIndex:pageIndex success:^(NSDictionary *dic, BCError *error)
     {
         [self.raiseTableView1.mj_header endRefreshing];
         [self.raiseTableView1.mj_footer endRefreshing];
         [self.raiseTableView2.mj_header endRefreshing];
         [self.raiseTableView2.mj_footer endRefreshing];
         [self.redTableView1.mj_header endRefreshing];
         [self.redTableView1.mj_footer endRefreshing];
         [self.redTableView2.mj_header endRefreshing];
         [self.redTableView2.mj_footer endRefreshing];
         NSLog(@"%@",dic);
         NSString *ticketType = [dic objectForKey:@"type"];
         NSString *couponsType = [dic objectForKey:@"ticketUrl"];
          if (error.code == 0)
          {
              
              //if (_couponType == RaiseInterestRatesCoupon)//加息券
              if ([couponsType hasSuffix:@"increase"])
              {
                  self.raiseRegular = [dic objectForKey:@"ticketUrl"];
                  NSArray *array = [dic mutableArrayValueForKey:@"list"];
                  if([ticketType isEqualToString:@"nouse"])//未使用
                  {
                      if (_raiseCouponUnusePageIndex == 1)
                          [self.raiseUnusedArray removeAllObjects];
                      if (array.count < PageMaxCount)
                          [self.raiseTableView1.mj_footer endRefreshingWithNoMoreData];
                      
                     
                      for (NSDictionary *item in array) {
                          RaiseRatesCoupon *model = [[RaiseRatesCoupon alloc] initWithDic:item];
                          [self.raiseUnusedArray addObject:model];
                      }
                      [self.raiseTableView1 reloadData];
                  }
                  else //已使用
                  {
                      if (_raiseCouponUsedPageIndex == 1)
                          [self.raiseUsedArray removeAllObjects];
                      if (array.count < PageMaxCount)
                          [self.raiseTableView2.mj_footer endRefreshingWithNoMoreData];
                      
                      for (NSDictionary *item in array) {
                          RaiseRatesCoupon *model = [[RaiseRatesCoupon alloc] initWithDic:item];
                          [self.raiseUsedArray addObject:model];
                      }
                      [self.raiseTableView2 reloadData];
                  }
                  
              }
              else//红包券
              {
                  NSArray *array = [dic mutableArrayValueForKey:@"ticketList"];

                  self.redRegular = [dic objectForKey:@"ticketUrl"];
                  if([ticketType isEqualToString:@"nouse"])//未使用
                  {

                      if (_redpacketCouponUnusePageIndex == 1)
                          [self.redUnusedArray removeAllObjects];
                      if (array.count < PageMaxCount)
                          [self.redTableView1.mj_footer endRefreshingWithNoMoreData];
                      
                      for (NSDictionary *item in array) {
                          RedBagCoupon *model = [[RedBagCoupon alloc] initWithDic:item];
                          [self.redUnusedArray addObject:model];
                      }
                      [self.redTableView1 reloadData];
                  }
                  else //已使用
                  {
                      if (_redpacketCouponUsedPageIndex == 1)
                          [self.redUsedArray removeAllObjects];
                      if (array.count < PageMaxCount)
                          [self.redTableView2.mj_footer endRefreshingWithNoMoreData];
                      
                      for (NSDictionary *item in array) {
                          RedBagCoupon *model = [[RedBagCoupon alloc] initWithDic:item];
                          [self.redUsedArray addObject:model];
                      }
                      [self.redTableView2 reloadData];
                  }

                  
              }
          }
         else
         {
             SHOWTOAST(error.message);
         }
         
    } failure:^(NSError *error)
     {
        [self.raiseTableView1.mj_header endRefreshing];
        [self.raiseTableView1.mj_footer endRefreshing];
        [self.raiseTableView2.mj_header endRefreshing];
        [self.raiseTableView2.mj_footer endRefreshing];
        [self.redTableView1.mj_header endRefreshing];
        [self.redTableView1.mj_footer endRefreshing];
        [self.redTableView2.mj_header endRefreshing];
        [self.redTableView2.mj_footer endRefreshing];
        SHOWTOAST(@"优惠券获取失败，请稍后再试");
        
    }];
    
    
     
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_couponType == RaiseInterestRatesCoupon)
    {
        if(_addRateCurrentStatus == TicketListTypeUnused)//未使用
        {
            return [_raiseUnusedArray count]>0?[_raiseUnusedArray count] +1 : 0;
        }
        else
        {
            return [_raiseUsedArray count];
        }
    }
    else
    {
        if(_redRateCurrentStatus == TicketListTypeUnused)//未使用
        {
            return [_redUnusedArray count]>0?[_redUnusedArray count]+1:0;
        }
        else
        {
            return [_redUsedArray count];
        }

    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTicketTableViewCell *cell;
    if (tableView == self.raiseTableView1) {
        if (indexPath.row == 0)
        {
            TicketTipTableViewCell *tipCell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTipTableViewCell class]) forIndexPath:indexPath];
            tipCell.tipLabel.text = @"仅限有加息券标识的项目可用";
             tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return tipCell;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewTicketTableViewCell class]) forIndexPath:indexPath];
            [cell reloadData:[self.raiseUnusedArray objectSafeAtIndex: indexPath.row-1] type:_addRateCurrentStatus];
        }
        
    }
    else if(tableView == self.raiseTableView2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewTicketTableViewCell class]) forIndexPath:indexPath];
        [cell reloadData:[self.raiseUsedArray objectSafeAtIndex: indexPath.row] type:_addRateCurrentStatus];
    }
    else if(tableView == self.redTableView1)
    {
        if (indexPath.row == 0)
        {
            TicketTipTableViewCell *tipCell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTipTableViewCell class]) forIndexPath:indexPath];
            tipCell.tipLabel.text = @"仅限有红包券标识的项目可用";
            tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return tipCell;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewTicketTableViewCell class]) forIndexPath:indexPath];
            [cell reloadData:[self.redUnusedArray objectSafeAtIndex: indexPath.row-1] type:_redRateCurrentStatus];
        }
    }
    else if(tableView == self.redTableView2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewTicketTableViewCell class]) forIndexPath:indexPath];
        [cell reloadData:[self.redUsedArray objectSafeAtIndex: indexPath.row] type:_redRateCurrentStatus];
    }
   
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_couponType == RaiseInterestRatesCoupon && _addRateCurrentStatus == TicketListTypeUnused && [self.raiseUnusedArray count]>0 && indexPath.row == 0)
        return 21;
    else if(_couponType == RedPacketCoupon && _redRateCurrentStatus == TicketListTypeUnused && [self.redUnusedArray count] >0 && indexPath.row == 0)
        return 21;

    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _raiseTableView1 && _couponType == RaiseInterestRatesCoupon && _addRateCurrentStatus == TicketListTypeUnused && _raiseUnusedArray.count > 0)
        return 0;
    if(tableView == _raiseTableView2 && _couponType == RaiseInterestRatesCoupon && _addRateCurrentStatus == TicketListTypeUsed && _raiseUsedArray.count > 0)
        return 0;
    if(tableView == _redTableView1 && _couponType == RedPacketCoupon  && _redRateCurrentStatus == TicketListTypeUnused && _redUnusedArray.count > 0)
        return 0;
    if(tableView == _redTableView2 && _couponType == RedPacketCoupon  && _redRateCurrentStatus == TicketListTypeUsed && _redUsedArray.count > 0)
        return 0;
    if(_raiseCouponUnusePageIndex == 0 && _redpacketCouponUsedPageIndex == 0)//第一次数据没获取钱，不显示footerview
        return 0;
    return tableView.bounds.size.height;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"noRedPacket.png"];
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    CGFloat positionY = 133*(Screen_height/480)-tableView.frame.origin.y;
    if(tableView == _redTableView1)
    {
        positionY = 133*(Screen_height/480)-_redTableSuperView.frame.origin.y;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, positionY, image.size.width,image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(153, 153, 153);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (tableView == _raiseTableView1)
    {
        label.text = @"暂无加息券";
    }
    else if(tableView == _raiseTableView2)
    {
        label.text = @"暂无已使用加息券";
    }
    else if(tableView == _redTableView1)
    {
        label.text = @"暂无红包券";
    }
    else if(tableView == _redTableView2)
    {
        label.text = @"暂无已使用红包券";
    }
    [footerView addSubview:label];
    return footerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView)
    {
        NSInteger currentPage = floor((scrollView.contentOffset.x - Screen_width / 2) / Screen_width) + 1;
        
        
        self.line1.hidden = YES;
        self.addRateBtn.selected = NO;
        self.line2.hidden = YES;
        self.redRateBtn.selected = NO;
        _couponType = currentPage;
        switch (currentPage)
        {
            case 0:
                self.line1.hidden = NO;
                self.addRateBtn.selected = YES;
//                if (self.unReadMessagePageIndex == 0) {
//                    [self.tableView1.mj_header beginRefreshing];
//                }
                break;
            case 1:
                self.line2.hidden = NO;
                self.redRateBtn.selected = YES;
//                if (self.readMessagePageIndex == 0) {
//                    [self.tableView2.mj_header beginRefreshing];
//                }
                break;
        }
        [self reLoadData];
    }
}
-(void)reLoadData
{
    if (_couponType == RaiseInterestRatesCoupon) {//当前为加息券
        if(_addRateCurrentStatus == TicketListTypeUnused)
        {
            self.raiseTableView1.hidden = NO;
            self.raiseTableView2.hidden = YES;
            if (_raiseCouponUnusePageIndex == 0) {
                [self.raiseTableView1.mj_header beginRefreshing];
            }
            else
            {
                 [self.raiseTableView1 reloadData];
            }
        
        }
        else
        {
            
            self.raiseTableView1.hidden = YES;
            self.raiseTableView2.hidden = NO;
            
            if (_raiseCouponUsedPageIndex == 0)
            {
                 [self.raiseTableView2.mj_header beginRefreshing];
            }
            else
            {
                 [self.raiseTableView2 reloadData];
            }
        }
    }
    else
    {
        if(_redRateCurrentStatus == TicketListTypeUnused)
        {
            self.redTableSuperView.hidden = NO;
            self.redTableView2.hidden = YES;
        
            if (_redpacketCouponUnusePageIndex == 0) {
                [self.redTableView1.mj_header beginRefreshing];
            }
            else
            {
                [self.redTableView1 reloadData];
            }
            
        }
        else
        {
    
            self.redTableSuperView.hidden = YES;
            self.redTableView2.hidden = NO;
            
            if (_redpacketCouponUsedPageIndex == 0) {
                [self.redTableView2.mj_header beginRefreshing];
            }
            else
            {
                [self.redTableView2 reloadData];
            }
        }

    }
}
@end
