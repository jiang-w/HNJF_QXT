//
//  YHViewModelServicesImpl.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/29.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModelServicesImpl.h"
#import "YHUserServiceImpl.h"
#import "YHProductServiceImpl.h"
#import "YHAccountServiceImpl.h"

@implementation YHViewModelServicesImpl

@synthesize userService = _userService;
@synthesize productService = _productService;
@synthesize accountService = _accountService;

+ (instancetype)sharedInstance {
    static YHViewModelServicesImpl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _userService = [[YHUserServiceImpl alloc] init];
        _productService = [[YHProductServiceImpl alloc] init];
        _accountService = [[YHAccountServiceImpl alloc] init];
    }
    return self;
}


@end
