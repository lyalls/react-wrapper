//
//  NSString+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/7.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define URL(url) [NSURL URLWithString:url]
#define STRING_FORMAT(str1, str2) [NSString stringWithFormat:@"%@%@", str1, str2]

typedef NS_ENUM(NSUInteger, PasswordStrength) {
    PasswordStrengthLow,
    PasswordStrengthMiddle,
    PasswordStrengthHeight
};

@interface NSString (Category)

+ (NSString *)UUID;

#pragma mark - String method

/**
 生成指定长度的字符串

 @param length 指定字符串长度

 @return 指定长度字符串
 */
+ (NSString *)randomStringWithLength:(NSInteger)length;

/**
 生成带前缀的字符串

 @param prefix 前缀

 @return 带前缀的字符串
 */
+ (NSString *)randomStringWithPrefix:(NSString *)prefix;


/**
 删除字符串内的空格
 */
- (void)deleteSpace;

/**
 将字符串转为URL

 @return 转换后的URL
 */
- (NSURL *)toURL;

/**
 获取身份证中的生日

 @return 生日
 */
- (NSString *)getIDCardBirthday;

/**
 获取身份证中的性别

 @return 性别，男，女
 */
- (NSString *)getIDCardGender;

#pragma mark - Pinyin

/**
 汉字转拼音，全拼

 @return 返回汉字拼音全拼
 */
- (NSString *)toPinyinEntire;

/**
 汉字转拼音，简拼
 
 @return 返回汉字拼音简拼
 */
- (NSString *)toPinyinFirst;

#pragma mark - Validate

/**
 验证手机号码

 @return YES:正确;NO:错误
 */
- (BOOL)onValidateMobile;

/**
 验证邮箱
 
 @return YES:正确;NO:错误
 */
- (BOOL)onValidateEmail;

/**
 验证身份证号码
 
 @return YES:正确;NO:错误
 */
- (BOOL)onValidateIDCardNumber;

#pragma mark - Encrypt

- (NSString *)md5Encrypt;

- (NSString *)sha1Encrypt;

- (NSString *)rsaEncrypt NS_DEPRECATED_IOS(2_0, 4_0, "");

- (NSString *)rsaDecrypt NS_DEPRECATED_IOS(2_0, 4_0, "");

- (NSString *)aes256Encrypt;

- (NSString *)aes256Decrypt;

#pragma mark - Other

- (id)toJSONObject;

/**
 将字符串类型转化成指定格式的时间类型

 @param fmt 格式化字符串，fmt为空，则默认为：yyyy-MM-dd

 @return 返回时间格式
 */
- (NSDate *)toDateWithFormatter:(NSString *)fmt;

/**
 反编码

 @return 反编码后的字符串
 */
- (NSString *)decodeString;

/**
 获取字符串大小

 @param maxSize 最大尺寸
 @param font    字体大小

 @return 返回尺寸
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;

/**
 判断密码强度

 @param password 密码

 @return 强度枚举
 */
+ (PasswordStrength)passwordStrength:(NSString *)password;

/**
 获取网络状态

 @return 无网络,2G,3G,4G,WIFI
 */
+ (NSString *)getNetWorkStates;

@end
