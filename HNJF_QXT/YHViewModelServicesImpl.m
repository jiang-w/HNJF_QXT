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

@implementation YHViewModelServicesImpl

@synthesize userService = _accountService;
@synthesize productService = _productService;

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
        _accountService = [[YHUserServiceImpl alloc] init];
        _productService = [[YHProductServiceImpl alloc] init];
    }
    return self;
}


@end
