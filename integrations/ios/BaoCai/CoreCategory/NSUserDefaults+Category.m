//
//  NSUserDefaults+Category.m
//  KuaiYi_User
//
//  Created by 刘国龙 on 16/3/3.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)

+ (void)saveUserDefaultsBool:(BOOL)value key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (void)saveUserDefaultObject:(NSObject *)value key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

@end
