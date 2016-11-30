//
//  UITableView+Category.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)

- (void)registerCellWithClass:(Class)className {
    [self registerClass:className forCellReuseIdentifier:NSStringFromClass(className)];
}

- (void)registerCellNibWithClass:(Class)className {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(className) bundle:nil] forCellReuseIdentifier:NSStringFromClass(className)];
}

@end
