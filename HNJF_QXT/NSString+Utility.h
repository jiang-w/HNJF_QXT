//
//  NSString+Utility.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

/**
 *  返回字符串的MD5值
 *
 *  @param str 原字符串
 *
 *  @return 返回MD5
 */
+ (NSString *)md5WithString:(NSString *)str;

/**
 *  校验字符串是否为空
 *
 *  @return 为空返回YES
 */
- (BOOL)isNullOrEmpty;

/**
 * 校验手机号码字符串格式
 *
 * @param phoneNumber 被校验的字符串
 * @return 校验通过返回YES
 */
+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber;

/**
 * 校验电子邮件地址字符串格式
 *
 * @param emailAddress 被校验的字符串
 * @return 校验通过返回YES
 */
+ (BOOL)validateEmailAddress:(NSString *)emailAddress;

/**
 *  校验密码强度
 *
 *  @param password 被校验的字符串
 *
 *  @return 校验通过返回YES
 */
+ (BOOL)validatePassword:(NSString *)password;

/**
 *  校验字符串是否匹配给定的正则表达
 *
 *  @param regex 模式字符串
 *
 *  @return 匹配返回YES
 */
- (BOOL)validateStringWithRegex:(NSString *)regex;

/**
 *  数字格式化为数值样式字符串
 *
 *  @param number 数值
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)decimalStyleStringFromNumber:(NSNumber *)number;

/**
 *  数字格式化为货币样式字符串（不带货币符号）
 *
 *  @param number 数值
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)currencyStyleStringFromNumber:(NSNumber *)number;

@end
