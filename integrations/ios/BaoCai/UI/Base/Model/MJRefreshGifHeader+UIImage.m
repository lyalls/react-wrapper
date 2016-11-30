//
//  MJRefreshGifHeader-UIImage.m
//  BaoCai
//
//  Created by lishuo on 16/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MJRefreshGifHeader+UIImage.h"
#import "GeneralRequest.h"

@implementation MJRefreshGifHeader (UIImage)

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
                 
                 [MJRefreshGifHeader randSlogan];
                 
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
    
   
    [self lastUpdatedTimeLabel].hidden = YES;//textColor = RGB_COLOR(255, 255, 255);
    self.stateLabel.hidden = NO;//textColor = RGB_COLOR(255, 255, 255);
    self.labelLeftInset = 10;
    [self setTitle:slogn forState:MJRefreshStateIdle];
    [self setTitle:slogn forState:MJRefreshStatePulling];
    [self setTitle:slogn forState:MJRefreshStateRefreshing];
    
    [self setImages:startArray forState:MJRefreshStateIdle];
    [self setImages:ImageArray forState:MJRefreshStateRefreshing];
    [self setImages:endArray forState:MJRefreshStatePulling];
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
   // [NSUserDefaults saveUserDefaultObject:strSlogan key:@"strSlogan"];
     [UserDefaultsHelper sharedManager].strSlogan = strSlogan;
}

@end
