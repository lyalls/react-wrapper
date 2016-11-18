//
//  TenderDetailMenuModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "TenderDetailMenuModel.h"

@implementation TenderDetailMenuModel

+ (NSMutableArray *)getDataWithPurchaseNumber:(NSString *)purchaseNumber {
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
    
    TenderDetailMenuModel *model1 = [[TenderDetailMenuModel alloc] init];
    model1.iconImage = [UIImage imageNamed:@"tenderDetailIcon1.png"];
    model1.title = @"投资记录";
    model1.desc = purchaseNumber ? [NSString stringWithFormat:@"%@人次", purchaseNumber] : @"";
    model1.pageNameType = PageNameTypeTZJL;
    
    TenderDetailMenuModel *model2 = [[TenderDetailMenuModel alloc] init];
    model2.iconImage = [UIImage imageNamed:@"tenderDetailIcon2.png"];
    model2.title = @"项目详情";
    model2.desc = @"";
    model2.pageNameType = PageNameTypeXMXQ;
    
    [returnArray addObject:model1];
    [returnArray addObject:model2];
    
    return returnArray;
}

@end
