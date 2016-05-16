//
//  YHUserProfile.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/11.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHUserProfile.h"

@implementation YHUserProfile

+ (instancetype)defaultProfile {
    YHUserProfile *profile = [[YHUserProfile alloc] init];
    profile.allowGesturePassword = NO;
    profile.allowTouchId = NO;
    return profile;
}

+ (instancetype)currentProfile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    YHUserProfile *profile = [[YHUserProfile alloc] init];
    profile.userId = [userDefaults stringForKey:@"userId"];
    profile.allowGesturePassword = [userDefaults boolForKey:@"allowGesturePassword"];
    profile.allowTouchId = [userDefaults boolForKey:@"allowTouchId"];
    return profile;
}

@end
