//
//  NSUserDefaults+Category.h
//  KuaiYi_User
//
//  Created by 刘国龙 on 16/3/3.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)

+ (void)saveUserDefaultsBool:(BOOL)value key:(NSString *)key;

+ (void)saveUserDefaultObject:(NSObject *)value key:(NSString *)key;

@end
