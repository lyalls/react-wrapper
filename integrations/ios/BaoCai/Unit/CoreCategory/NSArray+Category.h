//
//  NSArray+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (Category)

/**
 *  获取数组内指定索引的字符串
 *
 *  @param index 数组索引
 *
 *  @return 数组索引指定的字符串
 */
- (NSString *)stringWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的NSNumber
 *
 *  @param index 数组索引
 *
 *  @return 数组索引指定的NSNumber
 */
- (NSNumber *)numberWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的NSInteger
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的NSInteger
 */
- (NSInteger)integerWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的BOOL
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的BOOL
 */
- (BOOL)boolWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的CGFloat
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的CGFloat
 */
- (CGFloat)floatWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的CGPoint
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的CGPoint
 */
- (CGPoint)pointWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的CGSize
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的CGSize
 */
- (CGSize)sizeWithIndex:(NSUInteger)index;

/**
 *  获取数组内指定索引的CGSize
 *
 *  @param index 数组索引
 *
 *  @return 数组内指定索引的CGSize
 */
- (CGRect)rectWithIndex:(NSUInteger)index;

/**
 获取安全对象

 @param index 数组索引
 @return 数组内指定索引的值
 */
- (id)objectSafeAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (Category)

/**
 *  向NSMutableArray添加字符串
 *
 *  @param s 添加的字符串
 */
- (void)addString:(NSString *)s;

/**
 *  向NSMutableArray添加BOOL
 *
 *  @param b 添加的BOOL
 */
- (void)addBool:(BOOL)b;

/**
 *  向NSMutableArray添加NSInteger
 *
 *  @param i 添加的NSInteger
 */
- (void)addInteger:(NSInteger)i;

/**
 *  向NSMutableArray添加CGFloat
 *
 *  @param f 添加的CGFloat
 */
- (void)addFloat:(CGFloat)f;

/**
 *  向NSMutableArray添加CGPoint
 *
 *  @param p 添加的CGPoint
 */
- (void)addPoint:(CGPoint)p;

/**
 *  向NSMutableArray添加CGSize
 *
 *  @param s 添加的CGSize
 */
- (void)addSize:(CGSize)s;

/**
 *  向NSMutableArray添加CGRect
 *
 *  @param r 添加的CGRect
 */
- (void)addRect:(CGRect)r;

@end
