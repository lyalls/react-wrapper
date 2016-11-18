//
//  NSObject+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

- (void)performSelector:(NSString *)selector onDelegate:(id)delegate withObject:(id)object {
//    if (selector == nil || delegate == nil) {
//        return;
//    }
//    
//    SEL sel = NSSelectorFromString(selector);
//    IMP imp = [delegate methodForSelector:sel];
//    if (object) {
//        void (*func)(id, SEL, id) = (void *)imp;
//        func(delegate, sel, object);
//    }else{
//        void (*func)(id, SEL) = (void *)imp;
//        func(delegate, sel);
//    }
}

@end
