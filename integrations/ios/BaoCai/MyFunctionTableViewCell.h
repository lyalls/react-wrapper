//
//  MyFunctionTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/5.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FunctionType) {
    FunctionTypeRecharge,
    FunctionTypeWithdrawals
};

typedef void (^FunctionClickBlock)(FunctionType type);

@interface MyFunctionTableViewCell : UITableViewCell

- (void)reloadData:(FunctionClickBlock)block;

@end
