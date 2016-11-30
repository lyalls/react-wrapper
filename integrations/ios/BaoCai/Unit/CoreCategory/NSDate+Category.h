//
//  NSDate+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

+ (NSArray *)getWeekStartEndDaysWithDate:(NSDate *)date;

- (BOOL)isToday;

@property (nonatomic, strong, readonly) NSDateComponents *components;

+ (NSDate *)dateChina;

/**
 *  获取当前年
 *
 *  @return 返回NSInteger类型
 */
+ (NSInteger)currentYear;

/**
 *  获取当前年
 *
 *  @return 返回NSString类型
 */
+ (NSString *)currentYearString;

/**
 *  获取当前月
 *
 *  @return 返回NSInteger类型
 */
+ (NSInteger)currentMonth;

/**
 *  获取当前月
 *
 *  @return 返回NSString类型
 */
+ (NSString *)currentMonthString;

/**
 *  获取当前日
 *
 *  @return 返回NSInteger类型
 */
+ (NSInteger)currentDay;

/**
 *  获取当前日
 *
 *  @return 返回NSString类型
 */
+ (NSString *)currentDayString;

/**
 *  按指定字符串格式化日期
 *
 *  @param fmt 格式化字符串，如yyyy-MM-dd
 *
 *  @return 返回指定格式，格式化后的日期字符串
 */
- (NSString *)toStringWithFormatter:(NSString *)fmt;

/**
 *  按Java中1970时间戳得到OC中的时间
 *
 *  @param millisecond Java中的1970年时间戳
 *
 *  @return OC中的时间对象
 */
+ (NSDate *)dateWithJavaMillisecond:(NSNumber *)millisecond;

@end
