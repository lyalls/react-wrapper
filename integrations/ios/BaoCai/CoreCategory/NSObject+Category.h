//
//  NSObject+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/8.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)

- (void)performSelector:(NSString *)selector onDelegate:(id)delegate withObject:(id)object;

@end
