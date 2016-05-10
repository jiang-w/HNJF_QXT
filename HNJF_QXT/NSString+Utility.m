//
//  NSString+Utility.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utility)

+ (NSString *)md5WithString:(NSString *)str {
    if (![str isNullOrEmpty]) {
        // Create pointer to the string as UTF8
        const char *ptr = [str UTF8String];
        
        // Create byte array of unsigned chars
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5(ptr, (uint)strlen(ptr), md5Buffer);
        
        // Convert MD5 value in the buffer to NSString of hex values
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x",md5Buffer[i]];
        
        return output;
    }
    else {
        return @"";
    }
}


#pragma mark - validate

- (BOOL)isNullOrEmpty {
    if (self == nil || [self isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    if ( phoneNumber.length == 0 || phoneNumber.length != 11 ) {
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(145)|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNumber];
}

+ (BOOL)validateEmailAddress:(NSString *)emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [pred evaluateWithObject:emailAddress];
}

+ (BOOL)validatePassword:(NSString *)password {
    NSString *pwdRegex = @"([A-Z]|[a-z]|[0-9]){8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pwdRegex];
    return [pred evaluateWithObject:password];
}

- (BOOL)validateStringWithRegex:(NSString *)regex {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

+ (NSString *)decimalStyleStringFromNumber:(NSNumber *)number {
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *priceStr = [numFormatter stringFromNumber:number];
    return priceStr;
}

+ (NSString *)currencyStyleStringFromNumber:(NSNumber *)number {
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *priceStr = [numFormatter stringFromNumber:number];
    return [priceStr substringFromIndex:1];
}

@end
