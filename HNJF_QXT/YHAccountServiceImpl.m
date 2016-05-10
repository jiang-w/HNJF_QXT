//
//  YHAccountServiceImpl.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHAccountServiceImpl.h"
#import "RdServiceAPI.h"
#import "NSError+RdServiceAPIResult.h"

@implementation YHAccountServiceImpl

- (RACSignal *)signalOfAccountInfoWithUserIdentity:(NSString *)userId {
    return [[RdServiceAPI sharedInstance]
            signalWithServiceAPI:RDAPI_Account_Basic
            Parameters:@{@"userId": userId}];
}

@end
