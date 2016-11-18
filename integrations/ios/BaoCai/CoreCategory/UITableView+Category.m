//
//  UITableView+Category.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITableView+Category.h"
#import <MJRefresh/MJRefresh.h>
#import "GeneralRequest.h"
@implementation UITableView (Category)

- (void)registerCellNibWithClass:(Class)className {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(className) bundle:nil] forCellReuseIdentifier:NSStringFromClass(className)];
}

- (void)setRefreshGifHeader:(NSInteger)fromType
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
                 
                 [UITableView randSlogan];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:RefreshSloganNotification object:nil];
             }
         } failure:^(NSError *error) {
             
         }];
    });

    NSArray *startArray;
    NSArray *ImageArray;
    NSArray *endArray;
    if(fromType == FROM_HOME)
    {
        startArray = @[[UIImage imageNamed:@"home_refresh_01"]];
        ImageArray = @[[UIImage imageNamed:@"home_refresh_01"],
                        [UIImage imageNamed:@"home_refresh_02"],
                        [UIImage imageNamed:@"home_refresh_03"],
                        [UIImage imageNamed:@"home_refresh_04"]
                        ];
        endArray = @[[UIImage imageNamed:@"home_refresh_04"]];
    }
    else
    {
        startArray = @[[UIImage imageNamed:@"my_refresh_01"]];
        ImageArray = @[[UIImage imageNamed:@"my_refresh_01"],
                       [UIImage imageNamed:@"my_refresh_02"],
                       [UIImage imageNamed:@"my_refresh_03"],
                       [UIImage imageNamed:@"my_refresh_04"]
                       ];
        endArray = @[[UIImage imageNamed:@"my_refresh_04"]];
    }
    
    NSString *slogn = [UserDefaultsHelper sharedManager].strSlogan;
    if (!slogn || [slogn isEqualToString:@""]) {
        slogn = @"值得信赖的投资理财平台";
    }
    
    MJRefreshGifHeader *refreshStateHeader = (MJRefreshGifHeader *)self.mj_header;
    [refreshStateHeader lastUpdatedTimeLabel].hidden = YES;//textColor = RGB_COLOR(255, 255, 255);
    refreshStateHeader.stateLabel.hidden = NO;//textColor = RGB_COLOR(255, 255, 255);
   // refreshStateHeader.labelLeftInset = 10;
    [refreshStateHeader setTitle:slogn forState:MJRefreshStateIdle];
    [refreshStateHeader setTitle:slogn forState:MJRefreshStatePulling];
    [refreshStateHeader setTitle:slogn forState:MJRefreshStateRefreshing];
    
    [(MJRefreshGifHeader*)(self.mj_header) setImages:startArray forState:MJRefreshStateIdle];
    [(MJRefreshGifHeader*)(self.mj_header) setImages:ImageArray forState:MJRefreshStateRefreshing];
    [(MJRefreshGifHeader*)(self.mj_header) setImages:endArray forState:MJRefreshStatePulling];
}

+(void)randSlogan
{
    NSDictionary *sloganDic = [UserDefaultsHelper sharedManager].slogan;
    NSArray *sloganArray = [sloganDic objectForKey:@"list"];
    
    NSString *strSlogan = @"";
    if ([[sloganDic objectForKey:@"control"] boolValue])
    {
        NSInteger rand = [[sloganDic objectForKey:@"rand"] integerValue];
        strSlogan = sloganArray[rand];
    }
    else
    {
        NSInteger random = [[NSUserDefaults standardUserDefaults] integerForKey:@"random"];
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
        [NSUserDefaults saveUserDefaultObject:[NSNumber numberWithInteger:random] key:@"random"];
    }
    [NSUserDefaults saveUserDefaultObject:strSlogan key:@"strSlogan"];
}

@end
