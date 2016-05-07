//
//  NSDictionary+Output.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Output)

- (BOOL)boolValueForKey:(NSObject *)key;

- (NSInteger)integerValueForKey:(NSObject *)key;

- (long)longValueForKey:(NSObject *)key;

- (float)floatValueForKey:(NSObject *)key;

- (NSString *)stringValueForKey:(NSObject *)key;

- (NSArray *)arrayForKey:(NSObject *)key;

- (NSDictionary *)dictionaryForKey:(NSObject *)key;
@end
