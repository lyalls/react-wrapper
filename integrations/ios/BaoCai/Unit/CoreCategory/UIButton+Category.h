//
//  UIButton+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchUpInsideBlock)(UIButton *sender);

@interface UIButton (Category)

@property (nonatomic, strong) NSObject *data;

- (void)addTargetHandler:(TouchUpInsideBlock)targetHandler;

@end
