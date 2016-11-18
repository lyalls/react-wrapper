//
//  UIButton+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

static const void *IndieDataNameKey = &IndieDataNameKey;
static const void *UIButtonEventBlockKey = &UIButtonEventBlockKey;

@implementation UIButton (Category)

- (void)setData:(NSObject *)data {
    objc_setAssociatedObject(self, IndieDataNameKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)data {
    return objc_getAssociatedObject(self, IndieDataNameKey);
}

- (void)addTargetHandler:(TouchUpInsideBlock)targetHandler {
    objc_setAssociatedObject(self, UIButtonEventBlockKey, targetHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionTouched:(UIButton *)btn {
    TouchUpInsideBlock block = objc_getAssociatedObject(self, UIButtonEventBlockKey);
    if (block) {
        block(btn);
    }
}

+(UIButton*)CreateButtonWithFrame:(NSString*)title frame:(CGRect)frame color:(UIColor*)color
                       background:(UIColor*)background
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setBackgroundColor:background];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    return button;
}

@end
