//
//  CALayer+Category.m
//  CustomService
//
//  Created by baocai on 16/9/26.
//  Copyright © 2016年 baocai. All rights reserved.
//

#import "CALayer+Category.h"
#import <objc/runtime.h>

@implementation CALayer (Category)

- (UIColor *)borderColorFromUIColor {
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
}

- (void)setBorderColorFromUIColor:(UIColor *)color {
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBorderColorFromUI:self.borderColorFromUIColor];
}

- (void)setBorderColorFromUI:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
