//
//  NSDictionary+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (NSString *)stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSNumber *)numberForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    return nil;
}

- (NSInteger)integerForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)boolForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)floatForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0;
}

- (CGPoint)pointForKey:(id)key {
    id value = [self objectForKey:key];
    CGPoint point = CGPointFromString(value);
    return point;
}

- (CGSize)sizeForKey:(id)key {
    id value = [self objectForKey:key];
    CGSize size = CGSizeFromString(value);
    return size;
}

-(NSString*) toString
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

- (CGRect)rectForKey:(id)key {
    id value = [self objectForKey:key];
    CGRect rect = CGRectFromString(value);
    return rect;
}

@end

@implementation NSMutableDictionary (Category)

- (void)setString:(NSString *)s forKey:(NSString *)key {
    self[key] = s;
}

- (void)setBool:(BOOL)b forKey:(NSString *)key {
    self[key] = @(b);
}

- (void)setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}

- (void)setPoint:(CGPoint)p forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(p);
}

- (void)setSize:(CGSize)s forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(s);
}

- (void)setRect:(CGRect)r forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(r);
}

@end
