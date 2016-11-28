//
//  BCRefreshGifHeader.m
//  BaoCai
//
//  Created by lishuo on 16/11/23.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "BCRefreshGifHeader.h"
#import "GeneralRequest.h"
@interface BCRefreshGifHeader()
{
    
}
@property (nonatomic,assign) NSInteger formType;
@end

@implementation BCRefreshGifHeader


#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    [self initData];
    
}
-(void)initData
{
    //[self.gifView set]
    _formType = FROM_HOME;
    [self setRefreshGifHeader];
    [BCRefreshGifHeader getSloganData];
    [self performSelector:@selector(endRefreshingBlock) withObject:nil afterDelay:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefreshGifHeader) name:RefreshSloganNotification object:nil];
}
+(void)getSloganData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [GeneralRequest getSloganRequestWithVersion:[UserDefaultsHelper sharedManager].sloganVersion success:^(NSDictionary *dic, BCError *error)
         {
             if (error.code == 0)
             {
                 if(![[UserDefaultsHelper sharedManager].sloganVersion isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sloganVersion"]]])
                 {
                     [[UserDefaultsHelper sharedManager] setSlogan:[dic objectForKey:@"slogan"]];
                     
                 }
                 
                 [BCRefreshGifHeader randSlogan];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:RefreshSloganNotification object:nil];
             }
         } failure:^(NSError *error) {
             
         }];
    });

}
-(void)setRefreshGifHeaderType:(NSInteger)fromType
{
    _formType = fromType;
    [self setRefreshGifHeader];
}
- (void)setRefreshGifHeader
{
    
    NSArray *ImageArray;
    if(_formType == FROM_HOME)
    {
        ImageArray = @[[UIImage imageNamed:@"home_refresh_01"],
                       [UIImage imageNamed:@"home_refresh_02"],
                       [UIImage imageNamed:@"home_refresh_03"],
                       [UIImage imageNamed:@"home_refresh_04"]
                       ];
    }
    else
    {
        ImageArray = @[[UIImage imageNamed:@"my_refresh_01"],
                       [UIImage imageNamed:@"my_refresh_02"],
                       [UIImage imageNamed:@"my_refresh_03"],
                       [UIImage imageNamed:@"my_refresh_04"]
                       ];
    }
    
    NSString *slogn = [UserDefaultsHelper sharedManager].strSlogan;
    if (!slogn || [slogn isEqualToString:@""]) {
        slogn = @"值得信赖的投资理财平台";
    }
    self.labelLeftInset = 10;
    [self lastUpdatedTimeLabel].hidden = YES;
    self.stateLabel.hidden = NO;
    [self setTitle:slogn forState:MJRefreshStatePulling];
    [self setTitle:slogn forState:MJRefreshStateRefreshing];
    [self setTitle:slogn forState:MJRefreshStateIdle];
    
    [self setImages:ImageArray duration:0.5 forState:MJRefreshStateRefreshing];
    [self setImages:ImageArray duration:0.5 forState:MJRefreshStatePulling];
    [self setImages:ImageArray duration:0.5 forState:MJRefreshStateIdle];

    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

+(void)randSlogan
{
    NSDictionary *sloganDic = [UserDefaultsHelper sharedManager].slogan;
    NSArray *sloganArray = [sloganDic objectForKey:@"list"];
    
    NSString *strSlogan = @"";
    static NSInteger random = 0;
    if ([[sloganDic objectForKey:@"control"] boolValue])
    {
        NSInteger rand = [[sloganDic objectForKey:@"rand"] integerValue];
        strSlogan = sloganArray[rand];
    }
    else
    {

        if(random>=sloganArray.count)
            random = 0;
        strSlogan = sloganArray[random];
        if ((random+1) <sloganArray.count) {
            random++;
        }
        else
        {
            random = 0;
        }
    }
    [UserDefaultsHelper sharedManager].strSlogan = strSlogan;
}
-(void)endRefreshingBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefreshingWithCompletionBlock:^{
            [BCRefreshGifHeader randSlogan];
            [self setRefreshGifHeader];

        }];
    });

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
