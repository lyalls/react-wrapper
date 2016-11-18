//
//  NSDate+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

+ (NSArray *)getWeekStartEndDaysWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    NSInteger firstDiff, lastDiff;
    if (comp.weekday == 1) {
        firstDiff = -5;
        lastDiff = 1;
    } else {
        firstDiff = [calendar firstWeekday] - comp.weekday + 2;
        lastDiff = 9 - comp.weekday;
    }
    
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    [firstDayComp setDay:comp.day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    [lastDayComp setDay:comp.day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    return [NSDate getBetweenDateArrayWithStartDate:firstDayOfWeek endDate:lastDayOfWeek];;
}

+ (NSArray *)getBetweenDateArrayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
    [returnArray addObject:[[startDate toStringWithFormatter:@""] toDateWithFormatter:@""]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *startDateComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit fromDate:startDate];
    
    while (![startDate isEqual:endDate]) {
        [startDateComp setDay:startDateComp.day + 1];
        [startDateComp setHour:0];
        startDate = [calendar dateFromComponents:startDateComp];
        [returnArray addObject:[[startDate toStringWithFormatter:@""] toDateWithFormatter:@""]];
    }
    
    return returnArray;
}

- (BOOL)isToday {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

+ (NSDate *)dateChina {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;
    return [calendar components:unit fromDate:self];
}

+ (NSInteger)currentYear {
    return [NSDate dateChina].components.year;
}

+ (NSString *)currentYearString {
    return [NSString stringWithFormat:@"%li", (long)[NSDate currentYear]];
}

+ (NSInteger)currentMonth {
    return [NSDate dateChina].components.month;
}

+ (NSString *)currentMonthString {
    return [NSString stringWithFormat:@"%02li", (long)[NSDate currentMonth]];
}

+ (NSInteger)currentDay {
    return [NSDate dateChina].components.day;
}

+ (NSString *)currentDayString {
    return [NSString stringWithFormat:@"%02li", (long)[NSDate currentDay]];
}

- (NSString *)toStringWithFormatter:(NSString *)fmt {
    if (fmt == nil || fmt.length == 0) {
        fmt = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateWithJavaMillisecond:(NSNumber *)millisecond {
    return [NSDate dateWithTimeIntervalSince1970:millisecond.doubleValue / 1000];
}

@end
