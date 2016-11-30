//
//  NSArray+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (NSString *)stringWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
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

- (NSNumber *)numberWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
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

- (NSInteger)integerWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)boolWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)floatWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0;
}

- (CGPoint)pointWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    CGPoint point = CGPointFromString(value);
    return point;
}

- (CGSize)sizeWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    CGSize size = CGSizeFromString(value);
    return size;
}

- (CGRect)rectWithIndex:(NSUInteger)index {
    id value = [self objectAtIndex:index];
    CGRect rect = CGRectFromString(value);
    return rect;
}

- (id)objectSafeAtIndex:(NSUInteger)index {
    if (self.count <= index)
        return nil;
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end

@implementation NSMutableArray (Category)

- (void)addString:(NSString *)s {
    if (s) {
        [self addObject:s];
    }
}

- (void)addBool:(BOOL)b {
    [self addObject:@(b)];
}

- (void)addInteger:(NSInteger)i {
    [self addObject:@(i)];
}

- (void)addFloat:(CGFloat)f {
    [self addObject:@(f)];
}

- (void)addPoint:(CGPoint)p {
    [self addObject:NSStringFromCGPoint(p)];
}

- (void)addSize:(CGSize)s {
    [self addObject:NSStringFromCGSize(s)];
}

- (void)addRect:(CGRect)r {
    [self addObject:NSStringFromCGRect(r)];
}

@end
