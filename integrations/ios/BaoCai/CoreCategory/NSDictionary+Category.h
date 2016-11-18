//
//  NSDictionary+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (Category)

- (NSString *)stringForKey:(id)key;

- (NSNumber *)numberForKey:(id)key;

- (NSInteger)integerForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (CGFloat)floatForKey:(id)key;

- (CGPoint)pointForKey:(id)key;

- (CGSize)sizeForKey:(id)key;

- (CGRect)rectForKey:(id)key;

-(NSString*) toString;

@end

@interface NSMutableDictionary (Category)

- (void)setString:(NSString *)s forKey:(NSString *)key;

- (void)setBool:(BOOL)b forKey:(NSString *)key;

- (void)setInteger:(NSInteger)i forKey:(NSString *)key;

- (void)setFloat:(CGFloat)f forKey:(NSString *)key;

- (void)setPoint:(CGPoint)p forKey:(NSString *)key;

- (void)setSize:(CGSize)s forKey:(NSString *)key;

- (void)setRect:(CGRect)r forKey:(NSString *)key;

@end
