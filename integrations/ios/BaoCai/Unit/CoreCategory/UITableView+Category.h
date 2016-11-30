//
//  UITableView+Category.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Category)

- (void)registerCellWithClass:(Class)className;
- (void)registerCellNibWithClass:(Class)className;

@end
