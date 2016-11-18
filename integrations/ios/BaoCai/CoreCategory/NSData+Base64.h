//
//  NSData+Base64.h
//  QMEDICAL
//
//  Created by 刘国龙 on 15/11/5.
//  Copyright © 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

- (NSData *)aes256_encrypt:(NSString *)key;

- (NSData *)aes256_decrypt:(NSString *)key;

@end
