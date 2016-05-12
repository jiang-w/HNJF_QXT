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
    YHUserProfile *profile = [self init];
    profile.allowGesturePassword = NO;
    profile.allowTouchId = NO;
    return profile;
}

@end
