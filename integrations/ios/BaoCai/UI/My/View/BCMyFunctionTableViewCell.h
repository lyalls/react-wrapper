//
//  BCMyFunctionTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FunctionType) {
    FunctionTypeRecharge,
    FunctionTypeWithdrawals
};

typedef void (^FunctionClickBlock)(FunctionType type);

@interface BCMyFunctionTableViewCell : UITableViewCell

- (void)reloadData:(FunctionClickBlock)block;

@end
