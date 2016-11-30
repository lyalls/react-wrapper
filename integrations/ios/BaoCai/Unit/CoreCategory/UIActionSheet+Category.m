//
//  UIActionSheet+Category.m
//  QMEDICAL
//
//  Created by 刘国龙 on 15/10/17.
//  Copyright © 2015年 LiuGuolong. All rights reserved.
//

#import "UIActionSheet+Category.h"
#import <objc/runtime.h>

static const void *UIActionSheetClickedBlockKey = &UIActionSheetClickedBlockKey;

@implementation UIActionSheet (Category)

- (void)clickedButtonEvent:(ClickedButtonBlock)event{
    objc_setAssociatedObject(self, UIActionSheetClickedBlockKey, event, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDelegate:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ClickedButtonBlock event = objc_getAssociatedObject(self, UIActionSheetClickedBlockKey);
    if (event) {
        event(buttonIndex);
    }
}

@end
