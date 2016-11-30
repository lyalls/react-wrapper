//
//  UIColor+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0]
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:A]

#define RANDOM_COLO [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

@interface UIColor (Category)

+ (UIColor *)randomColor;
+ (UIColor *)getColorWithRGBStr:(NSString *)rgbStr;
+ (UIColor *)getColorWithRGBStr:(NSString *)rgbStr alpha:(CGFloat)alpha;

@end
