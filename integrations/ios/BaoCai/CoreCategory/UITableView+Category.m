//
//  UITableView+Category.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/4.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITableView+Category.h"


@implementation UITableView (Category)

- (void)registerCellNibWithClass:(Class)className {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(className) bundle:nil] forCellReuseIdentifier:NSStringFromClass(className)];
}



@end
