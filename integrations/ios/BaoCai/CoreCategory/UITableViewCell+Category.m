//
//  UITableViewCell+Category.m
//  QMEDICAL
//
//  Created by 刘国龙 on 16/2/22.
//  Copyright © 2016年 LiuGuolong. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Category)

+ (NSString *)cellIdentifier {
    NSString *className = NSStringFromClass(self.class);
    return [className stringByAppendingString:@"_Cell"];
}

@end
