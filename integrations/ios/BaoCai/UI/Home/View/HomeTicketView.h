//
//  HomeTicketView.h
//  BaoCai
//
//  Created by 刘国龙 on 16/8/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ToTicketViewClick)();

@interface HomeTicketView : UIView

- (void)reloadData:(NSMutableArray *)array;

@property (nonatomic, strong) ToTicketViewClick block;

@end
