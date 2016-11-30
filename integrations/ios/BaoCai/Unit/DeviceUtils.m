//
//  DeviceUtils.m
//  LightOfProof
//
//  Created by jfst-mbp-G3QH on 15/3/25.
//  Copyright (c) 2015年 linkipr. All rights reserved.
//

#import "DeviceUtils.h"
#include "sys/stat.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <arpa/inet.h> 


#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "NSData+Base64.h"

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位

#define Digest_Length 20




@implementation DeviceUtils



//Device Version
+(float) systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


//IOS6
+(BOOL) IOS6
{
    return [self systemVersion] >=6.0 && [self systemVersion] < 7.0;
}

//iphone6
+(BOOL) IPhone6
{
    return [UIScreen mainScreen].bounds.size.height == 667;
}

//iphone6p
+(BOOL) IPhone6Plus
{
    return [UIScreen mainScreen].bounds.size.height == 736;
}
//iphone5
+(BOOL) IPhone5
{
    return [UIScreen mainScreen].bounds.size.height == 568;
}
//iphone4
+(BOOL) IPhone4
{
    return [UIScreen mainScreen].bounds.size.height == 480;
}

//获取文件大小
+(long long) fileSize:(NSString*)path
{
    struct stat st;
    if(lstat([path cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

//屏幕高度
+(float) screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

//屏幕宽度
+(float) screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

//获取文件路径
+(NSString*) pathForResource:(NSString*)name fileType:(NSString*)fileType
{
    return [[NSBundle mainBundle] pathForResource:name ofType:fileType];
}

//获取文件内容
+(NSData*) getFileContent:(NSString*)path
{
    return [[NSData alloc] initWithContentsOfFile:path];
}

//保存文件
+(void) writeFile:(NSString*)path data:(NSData*)data
{
    [data writeToFile:path atomically:YES];
}

//获取tmp文件夹
+(NSString*) TempPath
{
   return  NSTemporaryDirectory();
}

//获取Documents文件夹
//+(NSString*) documentsPath
//{
//    NSString *g_docPath = nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    if (paths.count) {
//        g_docPath = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
//    }
//    else{
//        g_docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
//    }
//    return g_docPath;
//}

//获取图片
+(UIImage*) getImageWithName:(NSString*)name imageType:(NSString*)imageType
{
    return [UIImage imageWithContentsOfFile:[self pathForResource:name fileType:imageType]];
}

//根据机型获取图片
+(UIImage*) getImageWithNameByDevice:(NSString*)name imageType:(NSString*)imageType
{
    NSString * file = [NSString stringWithFormat:@"%@-%d",name,(int)self.screenHeight];
    
    file = [self pathForResource:file fileType:imageType];
    if(file == nil)
    {
        file = [self pathForResource:name fileType:imageType];
    }
    
    return [UIImage imageWithContentsOfFile:file];
}

//获取文本文件内容
+(NSString*) getStringWithName:(NSString*)name
{
    return [[NSString alloc] initWithContentsOfFile:name encoding:NSUTF8StringEncoding error:nil];
}

//获取IP地址
+(NSString*) getIPaddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                NSLog(@"%@:%@",[NSString stringWithUTF8String:temp_addr->ifa_name],[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

//获取设备唯一编号
+ (NSString *)getDeviceId
{
    return [[UIDevice currentDevice]identifierForVendor].UUIDString;
}

//字符串空处理
+ (NSString*) stringTransString:(NSString *)string
{
    NSString *strContent = [NSString stringWithFormat:@"%@",string];
    if ([strContent isEqualToString:@""]||[strContent isEqualToString:@"(null)"]||[strContent isEqualToString:@"<null>"]||[strContent isEqualToString:@"null"]) {
        strContent = @"";
    }
    
    return strContent;
}


+ (NSData *)getHashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( Digest_Length * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, Digest_Length);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:Digest_Length];
    if (hashBytes) free(hashBytes);
    
    return hash;
}




@end
