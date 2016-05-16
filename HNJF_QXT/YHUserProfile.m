//
//  YHUserProfile.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/11.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHUserProfile.h"

@implementation YHUserProfile

+ (instancetype)currentProfile {
    static YHUserProfile *profile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profile = [[self alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        profile.userId = [userDefaults stringForKey:@"userId"];
        profile.allowGesturePassword = [userDefaults objectForKey:@"allowGesturePassword"]? [userDefaults integerForKey:@"allowGesturePassword"] : -1;
        profile.allowTouchId = [userDefaults objectForKey:@"allowTouchId"]? [userDefaults integerForKey:@"allowTouchId"] : -1;
    });
    return profile;
}

- (void)synchronize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userId forKey:@"userId"];
    [userDefaults setInteger:self.allowGesturePassword forKey:@"allowGesturePassword"];
    [userDefaults setInteger:self.allowTouchId forKey:@"allowTouchId"];
    [userDefaults synchronize];
}

@end
