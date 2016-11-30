//
//  UIColor+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    return [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
}

+ (UIColor *)getColorWithRGBStr:(NSString *)rgbStr {
    NSArray *rgbColorArray = [rgbStr componentsSeparatedByString:@","];
    if (rgbColorArray.count == 3) {
        CGFloat red = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:0]].floatValue;
        CGFloat green = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:1]].floatValue;
        CGFloat blue = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:2]].floatValue;
        return RGB_COLOR(red, green, blue);
    }
    return nil;
}

+ (UIColor *)getColorWithRGBStr:(NSString *)rgbStr alpha:(CGFloat)alpha {
    NSArray *rgbColorArray = [rgbStr componentsSeparatedByString:@","];
    if (rgbColorArray.count == 3) {
        CGFloat red = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:0]].floatValue;
        CGFloat green = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:1]].floatValue;
        CGFloat blue = [NSString stringWithFormat:@"%@", [rgbColorArray objectAtIndex:2]].floatValue;
        return RGBA_COLOR(red, green, blue, alpha);
    }
    return nil;
}

@end
