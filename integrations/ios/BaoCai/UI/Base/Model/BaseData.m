//
//  BaseData.m
//  LightOfProof
//
//  Created by jfst-mbp-G3QH on 15/3/24.
//  Copyright (c) 2015年 linkipr. All rights reserved.
//

#import "BaseData.h"
#import <objc/runtime.h>

@implementation BaseData

#pragma  mark - NSCoding

//序列化对象
- (void)encodeWithCoder:(NSCoder *)coder
{
    NSArray* list = [self GetAllvars];
    
    for(NSString* var in list)
    {
        [coder encodeObject:[self valueForKey:var] forKey:var];
    }
    
    
}


//序列化对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        NSArray* list = [self GetAllvars];
        
        for(NSString* var in list)
        {
            if([aDecoder containsValueForKey:var])
            {
                [self setValue:[aDecoder decodeObjectForKey:var] forKey:var];
            }
        }
        
    }
    
    return self;
}


//排除列表
- (NSDictionary *)exceptionlist
{
    return nil;
}

//加载数据
-(void) loadDataFromDict:(NSDictionary*)dict
{
    NSArray* vars = [self GetAllvars];
    for(NSString* col in vars)
    {
        [self setValue:dict[col] forKey:col];
    }
}

//数据转为Dict
-(NSDictionary*)transToDict
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSArray* vars = [self GetAllvars];
    for(NSString* col in vars)
    {
        id val = [self valueForKey:col];
        if(val && [val isKindOfClass:[BaseData class]])
        {
            [dict setValue:[val transToDict] forKey:col];
        }
        else
        if(val)
        {
            [dict setValue:[self valueForKey:col] forKey:col];
        }
    }
    
    return dict;
}

#pragma mark - private method

-(NSArray*) GetAllvars
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    
    //获取当前的类
    Class c = [self class];
    NSDictionary* dict = [self exceptionlist];
    
    while(c && ![[NSString stringWithUTF8String:object_getClassName(c)] isEqualToString:@"BaseData"])
    {
        
        unsigned int numberOfIvars = 0;
        //获取cls 类成员变量列表
        objc_property_t* ivars = class_copyPropertyList(c, &numberOfIvars);
        //采用指针+1 来获取下一个变量
        for(const objc_property_t* p = ivars; p < ivars+numberOfIvars; p++)
        {
            
            NSString *key = [NSString stringWithUTF8String:property_getName(*p)];
            if(!dict || !dict[key])
            {
                [list addObject:key];
            }
        }
        
        free(ivars);
        c = class_getSuperclass(c);
    }
    
    return list;
}

@end
