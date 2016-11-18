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

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//图片缩小
- (UIImage *)scale:(CGSize)targetSize;

//裁剪到适合屏幕尺寸的图片
- (UIImage *)scaleForScreenImage;

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg withColor:(UIColor *)color;

- (UIImage *)imageCompressForWidth:(CGFloat)defineWidth;

@end
