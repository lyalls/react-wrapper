//
//  UIImage+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "UIImage+Category.h"
#import "qrencode.h"

#define PI 3.14159265358979323846

typedef enum {
    QRPointRect = 0,
    QRPointRound
}QRPointType;

typedef enum {
    QRPositionNormal = 0,
    QRPositionRound
}QRPositionType;

enum {
    qr_margin = 3
};

@implementation UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [UIImage imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)scale:(CGSize)targetSize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)scaleForScreenImage {
    float scaleSize = 1;
    if (self.size.width - 640.0 * 2 > 0) {
        scaleSize = 640 * 2 / self.size.width;
        CGSize size = CGSizeMake(scaleSize * self.size.width, scaleSize * self.size.height);
        return [self scale:size];
    } else if (self.size.width - 640.0 > 0) {
        scaleSize = 640.0 / self.size.width;
        CGSize size = CGSizeMake(scaleSize * self.size.width, scaleSize * self.size.height);
        return [self scale:size];
    } else {
        return self;
    }
}

#pragma mark-> 二维码生成
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size Topimg:(UIImage *)topimg withColor:(UIColor *)color {
    
    if (![string length]) {
        return nil;
    }
    
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [UIImage drawQRCode:code context:ctx size:size withPointType:0 withPositionType:0 withColor:color];
    
    // get image
    CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
    UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    if(topimg) {
        UIGraphicsBeginImageContext(qrImage.size);
        
        //Draw image2
        [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
        
        //Draw image1
        float r = qrImage.size.width * 35 / 240;
        [topimg drawInRect:CGRectMake((qrImage.size.width - r) / 2, (qrImage.size.height - r) / 2 ,r, r)];
        
        qrImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    // some releases
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
}
+ (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withColor:(UIColor *)color {
    unsigned char *data = 0;
    int width;
    data = code -> data;
    width = code -> width;
    float zoom = (double)size / (code -> width + 2.0 * qr_margin);
    CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);
    
    // draw
    const CGFloat *components;
    if (color) {
        components = CGColorGetComponents([UIColor blackColor].CGColor);
    } else {
        components = CGColorGetComponents([UIColor blackColor].CGColor);
    }
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1.0);
    
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                if (positionType == QRPositionNormal) {
                    switch (pointType) {
                        case QRPointRect:
                            CGContextAddRect(ctx, rectDraw);
                            break;
                        case QRPointRound:
                            CGContextAddEllipseInRect(ctx, rectDraw);
                            break;
                        default:
                            break;
                    }
                } else if(positionType == QRPositionRound) {
                    switch (pointType) {
                        case QRPointRect:
                            CGContextAddRect(ctx, rectDraw);
                            break;
                        case QRPointRound:
                            if ((i >= 0 && i <= 6 && j >= 0 && j <= 6) || (i >= 0 && i <= 6 && j >= width - 7 - 1 && j <= width - 1) || (i >= width - 7 - 1 && i <= width - 1 && j >= 0 && j <= 6)) {
                                CGContextAddRect(ctx, rectDraw);
                            } else {
                                CGContextAddEllipseInRect(ctx, rectDraw);
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}

- (UIImage *)imageCompressForWidth:(CGFloat)defineWidth {
    
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if(widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

@end
