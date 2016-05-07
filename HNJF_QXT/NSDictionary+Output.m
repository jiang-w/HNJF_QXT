//
//  NSDictionary+Output.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "NSDictionary+Output.h"

@implementation NSDictionary (Output)

- (BOOL)boolValueForKey:(NSObject *)key {
    return [self objectForKey:key] != nil ? [[self objectForKey:key] boolValue] : 0;
}

- (NSInteger)integerValueForKey:(NSObject *)key {
    return [self objectForKey:key] != nil ? [[self objectForKey:key] integerValue] : 0;
}

- (long)longValueForKey:(NSObject *)key {
    return [self objectForKey:key] != nil ? [[self objectForKey:key] longValue] : 0;
}

- (float)floatValueForKey:(NSObject *)key {
    return [self objectForKey:key] != nil ? [[self objectForKey:key] floatValue] : 0;
}

- (NSString *)stringValueForKey:(NSObject *)key {
    return [self objectForKey:key] != nil ? [NSString stringWithFormat:@"%@", [self objectForKey:key]] : @"";
}

- (NSArray *)arrayForKey:(NSObject *)key {
    NSArray *arr = [self objectForKey:key];
    if ([arr isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithArray:[self objectForKey:key]];
    }
    else {
        return @[];
    }
}

- (NSDictionary *)dictionaryForKey:(NSObject *)key {
    NSDictionary *dict = [self objectForKey:key];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithDictionary:[self objectForKey:key]];
    }
    else {
        return @{};
    }
}

@end
