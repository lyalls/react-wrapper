//
//  UIImage+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImageNamed(name) [UIImage imageNamed:name]

@interface UIImage (Category)

/**
 按颜色生成图片

 @param color 图片颜色

 @return 生成好的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 按颜色生成指定大小的图片

 @param color 图片颜色
 @param size  图片尺寸

 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 缩小图片到指定大小

 @param targetSize 新的图片尺寸

 @return 缩小后的图片
 */
- (UIImage *)scale:(CGSize)targetSize;

/**
 裁剪到适合屏幕的尺寸的图片

 @return 裁剪后的图片
 */
- (UIImage *)scaleForScreenImage;

//+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg withColor:(UIColor *)color;

- (UIImage *)imageCompressForWidth:(CGFloat)defineWidth;

@end
