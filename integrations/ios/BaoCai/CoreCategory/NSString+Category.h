//
//  NSString+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/7.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL(url) 			[NSURL URLWithString:url]
#define string(str1, str2) 	[NSString stringWithFormat:@"%@%@", str1, str2]
#define s_Str(str1) 		[NSString stringWithFormat:@"%@", str1]
#define s_Num(num1) 		[NSString stringWithFormat:@"%d", num1]
#define s_Integer(num1) 	[NSString stringWithFormat:@"%ld", num1]

typedef NS_ENUM(NSUInteger, PasswordStrength) {
    PasswordStrengthLow,
    PasswordStrengthMiddle,
    PasswordStrengthHeight
};

@interface NSString (Category)

+ (NSString *)UUID;

//生成指定长度的的字符串
+ (NSString *)randomStringWithLength:(NSInteger)length;

//[prefix]_xxxxxxxx
+ (NSString *)randomStringWithPrefix:(NSString *)prefix;

//MD5加密
+ (NSString *)md5Encrypt:(NSString *)text;

- (void)deleteSpace;

//将字符串类型转化成指定格式的时间类型
//如果fmt为空，则默认为：yyyy-MM-dd
- (NSDate *)toDateWithFormatter:(NSString *)fmt;

//汉字转拼音:中国-->zhongguo
- (NSString *)toPinyinEntire;

//汉子转拼音:中国-->zg
- (NSString *)toPinyinFirst;

//将字符串转换为NSURL
- (NSURL *)toURL;

//如果字符串为：nil，则返回：""
- (NSString *)onSafeString;

//校验手机号码
- (BOOL)onValiMobile;

//校验邮箱
- (BOOL)onValiEmail;

//验证身份证号
- (BOOL)onValidateIDCardNumber;

- (NSString *)getIDCardBirthday;

- (NSString *)getIDCardManOrWoman;

- (NSString *)decodeString;

+ (PasswordStrength)passwordStrength:(NSString *)password;

- (NSString *)RSAEncrypt;

- (NSString *)RSADecrypt;

- (NSString *)aes256_encrypt;

- (NSString *)aes256_decrypt;

- (NSString *)sha1;

- (NSString *)md5Encrypt;


//判断网络格式
// author lishuo
// date  2016.9.1
+ (NSString *)getNetWorkStates;

- (id) cdv_JSONObject;

@end
