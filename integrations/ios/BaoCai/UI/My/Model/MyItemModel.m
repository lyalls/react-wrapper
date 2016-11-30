//
//  MyItemModel.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "MyItemModel.h"

@implementation MyItemModel

+ (NSMutableArray *)getDataWithIsHasUnRead:(BOOL)isHasUnRead isHasNewVersion:(BOOL)isHasNewVersion withMyPageDataModel:(MyPageDataModel *)model {
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
    
    MyItemModel *model1 = [[MyItemModel alloc] init];
    model1.type = MyItemModelTypeTitleDesc;
    model1.pageNameType = PageNameTypeSBTZ;
    model1.title = @"散标投资";
    model1.desc = (model.tenderCount && model.tenderCount.length != 0) ? [NSString stringWithFormat:@"回收中%@笔", model.tenderCount] : @"";
    model1.iconImage = @"myIcon1.png";
    
    MyItemModel *model2 = [[MyItemModel alloc] init];
    model2.type = MyItemModelTypeTitleDesc;
    model2.pageNameType = PageNameTypeZQZR;
    model2.title = @"债权转让";
    model2.desc = (model.transferAssetsCount && model.transferAssetsCount.length != 0) ?  [NSString stringWithFormat:@"转让中%@笔", model.transferAssetsCount] : @"";
    model2.iconImage = @"myIcon2.png";
    
    MyItemModel *model3 = [[MyItemModel alloc] init];
    model3.type = MyItemModelTypeTitleDesc;
    model3.pageNameType = PageNameTypeTicket;
    model3.title = @"优惠券";
    model3.desc = (model.inceaseTicketCount && model.ticketCount && model.inceaseTicketCount.integerValue + model.ticketCount.integerValue != 0) ? [NSString stringWithFormat:@"%ld张", model.inceaseTicketCount.integerValue + model.ticketCount.integerValue] : @"";
    model3.iconImage = @"myIcon3.png";
    
    MyItemModel *model4 = [[MyItemModel alloc] init];
    model4.type = MyItemModelTypeTitleDesc;
    model4.pageNameType = PageNameTypeInviteFriends;
    model4.title = @"邀请好友";
    model4.desc = model.invitationDesc;
    model4.iconImage = @"myIcon4.png";
    
    [returnArray addObject:[NSArray arrayWithObjects:model1, model2, model3, model4, nil]];
    
    MyItemModel *model5 = [[MyItemModel alloc] init];
    model5.type = MyItemModelTypeUnRead;
    model5.pageNameType = PageNameTypeCustomService;
    model5.title = @"在线客服";
    model5.isHasUnRead = isHasUnRead;
    model5.iconImage = @"myIcon5.png";
    
    [returnArray addObject:[NSArray arrayWithObjects:model5, nil]];
    
    MyItemModel *model6 = [[MyItemModel alloc] init];
    model6.pageNameType = PageNameTypeSetting;
    model6.type = MyItemModelTypeNewVersion;
    model6.title = @"设置";
    model6.isHasNewVersion = isHasNewVersion;
    model6.iconImage = @"myIcon6.png";
    
    [returnArray addObject:[NSArray arrayWithObjects:model6, nil]];
    
    return returnArray;
}

@end
