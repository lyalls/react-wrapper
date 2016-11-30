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


#define view_backGroundColor RGB_COLOR(242,242,242)
//#define text_color RGB_COLOR(102, 102, 102)


@interface UINewTicketListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>




@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIButton *addRateBtn;
@property (strong,nonatomic) UIButton *redRateBtn;

@property (strong,nonatomic) UIButton *exchangeBtn;

@property (strong,nonatomic) UILabel *line1;
@property (strong,nonatomic) UILabel *line2;

@property (strong,nonatomic) UISegmentedControl *segment1;
@property (strong,nonatomic) UISegmentedControl *segment2;

@property (strong,nonatomic) UITableView *raiseTableView1;
@property (strong,nonatomic) UITableView *raiseTableView2;

@property (strong,nonatomic) UITableView *redTableView1;
@property (strong,nonatomic) UIView *redTableSuperView;
@property (strong,nonatomic) UITableView *redTableView2;



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
    self.title = @"优惠券";
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
    [self createTopSubView];
    [self createSubView];
    
    
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
-(void)createTopSubView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 16, 22);
    
    [backBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"规则" forState:UIControlStateNormal];
    [rightBtn setTitle:@"规则" forState:UIControlStateHighlighted];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:Color666666 forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color666666 forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ruleItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = ruleItem;
    
    
}
-(void)createSubView
{
    __weak UIView *superView = self.view;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = view_backGroundColor;
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left);
        make.width.equalTo(superView.width);
        make.height.equalTo(@41);
        
    }];
    
    _addRateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_addRateBtn.frame = CGRectMake(1, 1, (SCREEN_WIDTH-2)/2-1, 39);
    [_addRateBtn setTitle:@"加息券" forState:UIControlStateNormal];
    [_addRateBtn setTitle:@"加息券" forState:UIControlStateHighlighted];
    _addRateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_addRateBtn setTitleColor:Color666666 forState:UIControlStateNormal];
    [_addRateBtn setTitleColor:Color666666 forState:UIControlStateHighlighted];
    [_addRateBtn setTitleColor:RGB_COLOR(228, 0, 18) forState:UIControlStateSelected];
    [_addRateBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _addRateBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _addRateBtn.backgroundColor = [UIColor whiteColor];
    [topView addSubview:_addRateBtn];
    
    [_addRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.top).offset(1);
        make.left.equalTo(topView.left).offset(1);
        make.width.equalTo((SCREEN_WIDTH-2)/2-1);
        make.height.equalTo(@39);
        
    }];
    
    
    _redRateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_redRateBtn.frame = CGRectMake((SCREEN_WIDTH-2)/2+1, 1, (SCREEN_WIDTH-2)/2-1, 39);
    [_redRateBtn setTitle:@"红包券" forState:UIControlStateNormal];
    [_redRateBtn setTitle:@"红包券" forState:UIControlStateHighlighted];
    _redRateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_redRateBtn setTitleColor:Color666666 forState:UIControlStateNormal];
    [_redRateBtn setTitleColor:Color666666 forState:UIControlStateHighlighted];
    [_redRateBtn setTitleColor:RGB_COLOR(228, 0, 18) forState:UIControlStateSelected];
    [_redRateBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _redRateBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _redRateBtn.backgroundColor = [UIColor whiteColor];
    [topView addSubview:_redRateBtn];
    
    [_redRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.top).offset(1);
        make.left.equalTo(topView.left).offset((SCREEN_WIDTH-2)/2+1);
        make.width.equalTo((SCREEN_WIDTH-2)/2-1);
        make.height.equalTo(@39);
        
    }];
    
    _line1 = [[UILabel alloc] init];//WithFrame:CGRectMake((CGRectGetWidth(_addRateBtn.frame) - 80)/2, 38, 80, 2)];
    _line1.backgroundColor = RGB_COLOR(228, 0, 18);
    [topView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addRateBtn.bottom).offset(-1);
        make.centerX.equalTo(_addRateBtn.centerX).offset(0);
        make.width.equalTo(@80);
        make.height.equalTo(@2);
        
    }];
    
    
    _line2 = [[UILabel alloc] init];//WithFrame:CGRectMake((_redRateBtn.center.x - 40), 38, 80, 2)];
    _line2.backgroundColor = RGB_COLOR(228, 0, 18);
    [topView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redRateBtn.bottom).offset(-1);
        make.centerX.equalTo(_redRateBtn.centerX).offset(0);
        make.width.equalTo(@80);
        make.height.equalTo(@2);
        
    }];
    
    _scrollView = [[UIScrollView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH, self.view.bounds.size.height - CGRectGetMaxY(view.frame) - 64)];
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom).offset(0);
        make.left.equalTo(superView.left).offset(0);
        make.bottom.equalTo(superView.bottom);
        make.right.equalTo(superView.right);
        
    }];
    
    UIView *scrollSubView = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, _scrollView.bounds.size.height)];
    scrollSubView.backgroundColor = view_backGroundColor;
    [_scrollView addSubview:scrollSubView];
    
    [scrollSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.top);
        make.left.equalTo(_scrollView.left);
        make.width.equalTo(@(SCREEN_WIDTH*2));
        make.height.equalTo(_scrollView.height);
        
    }];
    
    
    
    _segment1 = [[UISegmentedControl alloc] init];//WithFrame:CGRectMake(25, 10, SCREEN_WIDTH - 50, 28)];
    [_segment1 insertSegmentWithTitle:@"未使用" atIndex:0 animated:NO];
    [_segment1 insertSegmentWithTitle:@"已使用" atIndex:1 animated:NO];
    
    _segment1.selectedSegmentIndex = 0;
    _segment1.tintColor = RGB_COLOR(255, 166, 56);
    [_segment1 addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [scrollSubView addSubview:_segment1];
    
    [_segment1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollSubView.top).offset(10);
        make.left.equalTo(scrollSubView.left).offset(25);
        make.right.equalTo(scrollSubView.right).offset(-(SCREEN_WIDTH+25));
        make.height.equalTo(@28);
    }];
    
    
    _segment2 = [[UISegmentedControl alloc] init];//WithFrame:CGRectMake(SCREEN_WIDTH + 25, 10, SCREEN_WIDTH - 50, 28)];
    [_segment2 insertSegmentWithTitle:@"未使用" atIndex:0 animated:NO];
    [_segment2 insertSegmentWithTitle:@"已使用" atIndex:1 animated:NO];
    _segment2.selectedSegmentIndex = 0;
    _segment2.tintColor = RGB_COLOR(255, 166, 56);
    [_segment2 addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [scrollSubView addSubview:_segment2];
    [_segment2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollSubView.top).offset(10);
        make.left.equalTo(scrollSubView.left).offset(SCREEN_WIDTH+25);
        make.right.equalTo(scrollSubView.right).offset(-25);
        make.height.equalTo(@28);
    }];
    
    
    
    _raiseTableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _raiseTableView1.backgroundColor = view_backGroundColor;
    _raiseTableView1.delegate = self;
    _raiseTableView1.dataSource = self;
    [scrollSubView addSubview:_raiseTableView1];
    
    [_raiseTableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollSubView.top).offset(40);
        make.left.equalTo(scrollSubView.left).offset(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(scrollSubView.bottom);
    }];
    
    
    _raiseTableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _raiseTableView2.backgroundColor = view_backGroundColor;
    _raiseTableView2.hidden = YES;
    _raiseTableView2.delegate = self;
    _raiseTableView2.dataSource = self;
    [scrollSubView addSubview:_raiseTableView2];
    
    [_raiseTableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollSubView.top).offset(40);
        make.left.equalTo(scrollSubView.left).offset(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(scrollSubView.bottom);
    }];
    
    _redTableSuperView = [[UIView alloc] initWithFrame:CGRectZero];
    _redTableSuperView.backgroundColor = view_backGroundColor;
    [scrollSubView addSubview:_redTableSuperView];
    
    [_redTableSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollSubView.top).offset(40);
        make.left.equalTo(scrollSubView.left).offset(SCREEN_WIDTH);
        make.bottom.equalTo(scrollSubView.bottom);
        make.right.equalTo(scrollSubView.right);
    }];
    
    
    _redTableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _redTableView1.backgroundColor = view_backGroundColor;
    _redTableView1.dataSource = self;
    _redTableView1.delegate = self;
    [_redTableSuperView addSubview:_redTableView1];
    
    [_redTableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redTableSuperView.top);
        make.left.equalTo(_redTableSuperView.left);
        make.bottom.equalTo(_redTableSuperView.bottom).offset(-51);
        make.right.equalTo(_redTableSuperView.right);
        //make.height.equalTo(_redTableSuperView.bounds.size.height - 51);
    }];
    
    
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
    labelLine.backgroundColor = RGB_COLOR(229, 229, 229);
    [_redTableSuperView addSubview:labelLine];
    
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redTableView1.bottom);
        make.left.equalTo(_redTableView1.left);
        // make.bottom.equalTo(_redTableSuperView.bottom).offset(-51);
        make.right.equalTo(_redTableSuperView.right);
        make.height.equalTo(@1);
    }];
    
    
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.frame = CGRectMake(0, CGRectGetMaxY(labelLine.frame), SCREEN_WIDTH, 50);
    [exchangeBtn setTitle:@"红包券兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitle:@"红包券兑换" forState:UIControlStateHighlighted];
    [exchangeBtn setTitleColor:RGB_COLOR(228, 0, 18) forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:RGB_COLOR(228, 0, 18) forState:UIControlStateHighlighted];
    [exchangeBtn setImage:[UIImage imageNamed:@"addTicket"] forState:UIControlStateNormal];
    [exchangeBtn setImage:[UIImage imageNamed:@"addTicket"] forState:UIControlStateHighlighted];
    [exchangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,14,0,0)];
    [exchangeBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-14,0,0)];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    exchangeBtn.backgroundColor = [UIColor whiteColor];
    [_redTableSuperView addSubview:exchangeBtn];
    
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelLine.bottom);
        make.left.equalTo(labelLine.left);
        //make.bottom.equalTo(_redTableSuperView.bottom).offset(-50);
        make.right.equalTo(_redTableSuperView.right);
        make.height.equalTo(@50);
    }];
    
    
    
    _redTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 40, SCREEN_WIDTH, scrollSubView.bounds.size.height - 40) style:UITableViewStylePlain];
    _redTableView2.backgroundColor = view_backGroundColor;
    _redTableView2.hidden = YES;
    _redTableView2.delegate = self;
    _redTableView2.dataSource = self;
    [scrollSubView addSubview:_redTableView2];
    
    [_redTableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redTableSuperView.top);
        make.left.equalTo(_redTableSuperView.left);
        make.bottom.equalTo(_redTableSuperView.bottom);
        make.right.equalTo(_redTableSuperView.right);
        
    }];
    
    if(_couponType == RedPacketCoupon)
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    
    
}

//- (void)updateViewConstraints
//{
//    [super updateViewConstraints];
//
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//    self.viewWidth.constant = self.view.bounds.size.width*2;
//    self.redUnuseViewLeading.constant = self.view.bounds.size.width;
//    self.redUsedTableViewLeading.constant = self.view.bounds.size.width;
//    self.secondSegmentLeading.constant = self.view.bounds.size.width+25;
//
//    if(_couponType == RedPacketCoupon)
//    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
//}

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
    UITicketExchangeViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UITicketExchangeViewController"];
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
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
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
    NSLog(@"end.....");
    
    
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
    if(_raiseCouponUnusePageIndex == 0)//第一次数据没获取钱，不显示footerview
        return 0;
    return tableView.bounds.size.height;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"noRedPacket.png"];
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.bounds];
    CGFloat positionY = 133*(SCREEN_HEIGHT/480)-tableView.frame.origin.y;
    if(tableView == _redTableView1)
    {
        positionY = 133*(SCREEN_HEIGHT/480)-_redTableSuperView.frame.origin.y;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((footerView.bounds.size.width - image.size.width)/2, positionY, image.size.width,image.size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, tableView.bounds.size.width, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = Color999999;
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
        NSInteger currentPage = floor((scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
        
        
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
