//
//  UIAlertView+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "UIAlertView+Category.h"
#import <objc/runtime.h>

static const void *UIAlertClickedBlockKey = &UIAlertClickedBlockKey;
static const void *UIAlertClickedBlockKey1 = &UIAlertClickedBlockKey1;

@implementation UIAlertView (Category)

- (void)clickedButtonEvent:(ClickedButtonBlock)event {
    objc_setAssociatedObject(self, UIAlertClickedBlockKey, event, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDelegate:self];
}

- (void)clickedButtonEventWithAlertView:(ClickedButtonBlockWithAlertView)event {
    objc_setAssociatedObject(self, UIAlertClickedBlockKey1, event, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ClickedButtonBlock event = objc_getAssociatedObject(self, UIAlertClickedBlockKey);
    if (event) {
        event(buttonIndex);
    } else {
        ClickedButtonBlockWithAlertView event = objc_getAssociatedObject(self, UIAlertClickedBlockKey1);
        if (event) {
            event(self, buttonIndex);
        }
    }
}

@end
