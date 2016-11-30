//
//  NSString+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/7.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import "NSData+Base64.h"

#define aes256_encrypt_key @"7efb64f31fc343f39778b15d938842ea"

@implementation NSString (Category)

+ (NSString *)UUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuid;
}

#pragma mark - String method

/**
 生成指定长度的字符串
 
 @param length 指定字符串长度
 
 @return 指定长度字符串
 */
+ (NSString *)randomStringWithLength:(NSInteger)length {
    NSMutableString *rand = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [rand appendFormat:@"%d", arc4random() % 10];
    }
    return rand;
}

/**
 生成带前缀的字符串
 
 @param prefix 前缀
 
 @return 带前缀的字符串
 */
+ (NSString *)randomStringWithPrefix:(NSString *)prefix {
    char hex62[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y'};
    
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:32];
    [str appendString:prefix];
    [str appendString:@"_"];
    
    while (str.length < 6) {
        [str appendString:@"0"];
    }
    
    unsigned long time = [[NSDate date] timeIntervalSince1970];
    while (time != 0) {
        int hex = time % 62;
        [str appendFormat:@"%c", hex62[hex]];
        time = time / 62;
    }
    
    int i = 0;
    while (str.length < 62 && i < 5) {
        [str appendFormat:@"%c", hex62[arc4random() % 62]];
        i++;
    }
    
    return str;
}

/**
 删除字符串内的空格
 */
- (void)deleteSpace {
    [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 将字符串转为URL
 
 @return 转换后的URL
 */
- (NSURL *)toURL {
    if (self && self.length > 0) {
        return [NSURL URLWithString:self];
    } else {
        return nil;
    }
}

/**
 获取身份证中的生日
 
 @return 生日
 */
- (NSString *)getIDCardBirthday {
    if ([self onValidateIDCardNumber]) {
        if (self.length == 15)
            return [NSString stringWithFormat:@"19%@", [self substringWithRange:NSMakeRange(6, 6)]];
        else
            return [self substringWithRange:NSMakeRange(6, 8)];
    }
    return @"";
}

/**
 获取身份证中的性别
 
 @return 性别，男，女
 */
- (NSString *)getIDCardGender {
    if ([self onValidateIDCardNumber]) {
        NSString *str = @"";
        if (self.length == 15) {
            str = [self substringFromIndex:self.length - 1];
        } else {
            str = [self substringWithRange:NSMakeRange(self.length - 2, 1)];
        }
        
        if (str.integerValue % 2 == 0) {
            return @"女";
        } else {
            return @"男";
        }
    }
    return @"";
}

#pragma mark - Pinyin

/**
 汉字转拼音，全拼
 
 @return 返回汉字拼音全拼
 */
- (NSString *)toPinyinEntire {
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return [source stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 汉字转拼音，简拼
 
 @return 返回汉字拼音简拼
 */
- (NSString *)toPinyinFirst {
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSArray *array = [source componentsSeparatedByString:@" "];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < array.count; i++) {
        NSString *tmp = array[i];
        [result appendString:[tmp substringToIndex:1]];
    }
    return result;
}

#pragma mark - Validate

/**
 验证手机号码
 
 @return YES:正确;NO:错误
 */
- (BOOL)onValidateMobile {
    NSString *phoneReg = @"^1[3|4|5|7|8][0-9]\\d{8}]$";
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneReg];
    return [regextestPhone evaluateWithObject:self];
}

/**
 验证邮箱
 
 @return YES:正确;NO:错误
 */
- (BOOL)onValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 验证身份证号码
 
 @return YES:正确;NO:错误
 */
- (BOOL)onValidateIDCardNumber {
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length = 0;
    if (!value) {
        return NO;
    } else {
        length = value.length;
        
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;
            
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            
            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            
            if (numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue +
                         [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 +
                ([value substringWithRange:NSMakeRange(1, 1)].intValue +
                 [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 +
                ([value substringWithRange:NSMakeRange(2, 1)].intValue +
                 [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 +
                ([value substringWithRange:NSMakeRange(3, 1)].intValue +
                 [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 +
                ([value substringWithRange:NSMakeRange(4, 1)].intValue +
                 [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 +
                ([value substringWithRange:NSMakeRange(5, 1)].intValue +
                 [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 +
                ([value substringWithRange:NSMakeRange(6, 1)].intValue +
                 [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 +
                [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 +
                [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 +
                [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y, 1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return false;
    }
}

#pragma mark - Encryption area

- (NSString *)md5Encrypt {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString *)sha1Encrypt {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)rsaEncrypt {
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"der"];
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate, myPolicy, &myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef publicKey = SecTrustCopyPublicKey(myTrust);
    
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0 * 0, cipherBufferSize);
    
    NSData *plainTextBytes = [self dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = (int)cipherBufferSize - 11;
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i = 0; i < numBlock; i++) {
        int bufferSize = (int)MIN(blockSize, [plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr) {
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        } else {
            return nil;
        }
    }
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@", [encryptedData base64EncodedString]];
    return encrypotoResult;
}

- (NSString *)rsaDecrypt {
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"root" ofType:@"p12"];
    NSData *p12Data = [[NSData alloc] initWithContentsOfFile:certPath];
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:@"kyjkliuguolong" forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef)p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    SecKeyRef key = privateKeyRef;
    NSData* data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key) - 12;
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
    
    if (status != noErr) {
        return nil;
    }
    
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    NSString* result = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)aes256Encrypt {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:aes256_encrypt_key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        Byte *datas = (Byte *)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for (int i = 0; i < result.length; i++) {
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

- (NSString *)aes256Decrypt {
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0', '\0', '\0'};
    for (int i = 0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i * 2];
        byte_chars[1] = [self characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData *result = [data aes256_decrypt:aes256_encrypt_key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - Other

- (id)toJSONObject {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        DLog(@"NSString JSONObject error: %@", [error localizedDescription]);
    }
    
    return object;
}

/**
 将字符串类型转化成指定格式的时间类型
 
 @param fmt 格式化字符串，fmt为空，则默认为：yyyy-MM-dd
 
 @return 返回时间格式
 */
- (NSDate *)toDateWithFormatter:(NSString *)fmt {
    if (fmt == nil || fmt.length == 0) {
        fmt = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter dateFromString:self];
}

/**
 反编码
 
 @return 反编码后的字符串
 */
- (NSString *)decodeString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 获取字符串大小
 
 @param maxSize 最大尺寸
 @param font    字体大小
 
 @return 返回尺寸
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

/**
 判断密码强度
 
 @param password 密码
 
 @return 强度枚举
 */
+ (PasswordStrength)passwordStrength:(NSString *)password {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSArray *termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray *termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray *termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray *termArray4 = [[NSArray alloc] initWithObjects:@"_", nil];
    //    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString *result1 = [NSString stringWithFormat:@"%d", [self judgeRange:termArray1 password:password]];
    NSString *result2 = [NSString stringWithFormat:@"%d", [self judgeRange:termArray2 password:password]];
    NSString *result3 = [NSString stringWithFormat:@"%d", [self judgeRange:termArray3 password:password]];
    NSString *result4 = [NSString stringWithFormat:@"%d", [self judgeRange:termArray4 password:password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@", result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@", result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@", result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@", result4]];
    
    int intResult = 0;
    for (int j = 0; j < resultArray.count; j++) {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"]) {
            intResult++;
        }
    }
    if (intResult < 2) {
        return PasswordStrengthLow;
    } else if (intResult == 2 && [password length] >= 8) {
        return PasswordStrengthMiddle;
    } else if (intResult > 2 && [password length] >= 8) {
        return PasswordStrengthHeight;
    }
    return PasswordStrengthLow;
}

+ (BOOL)judgeRange:(NSArray *)termArray password:(NSString *)password {
    NSRange range;
    BOOL result = NO;
    for(int i = 0; i < [termArray count]; i++) {
        range = [password rangeOfString:[termArray objectAtIndex:i]];
        if (range.location != NSNotFound) {
            result = YES;
        }
    }
    return result;
}

+ (NSString *)getNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                    state =  @"wifi";
                    break;
            }
            //根据状态选择
            return state;
        }
    }
    return @"";
}

@end
