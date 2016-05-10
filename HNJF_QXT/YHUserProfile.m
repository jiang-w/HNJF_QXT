//
//  YHUserProfile.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHUserProfile.h"

static YHUserProfile *currtUser;

@implementation YHUserProfile

+ (YHUserProfile *)currentUser {
    return currtUser;
}

+ (void)setCurrentUser:(YHUserProfile *)user {
    currtUser = user;
}

- (id)init {
    if (self = [super init]) {
        _allowGesturePassword = NO;
        _allowTouchId = NO;
        _account = [[YHAccountInfo alloc] init];
    }
    return self;
}

@end
