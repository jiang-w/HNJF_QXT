//
//  YHUserInfo.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHUserInfo.h"

static YHUserInfo *currtUser = nil;

@implementation YHUserInfo

+ (YHUserInfo *)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currtUser = [[self alloc] init];
    });
    return currtUser;
}

+ (void)setCurrentUser:(YHUserInfo *)user {
    currtUser = user;
}

- (id)init {
    if (self = [super init]) {
        _account = [[YHAccountInfo alloc] init];
    }
    return self;
}

@end
