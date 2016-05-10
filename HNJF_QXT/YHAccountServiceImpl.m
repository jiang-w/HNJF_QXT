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
//            map:^id(NSDictionary *dict) {
//                YHAccountInfo *account    = [[YHAccountInfo alloc] init];
//                account.totalBalance      = [dict[@"model"][@"total"] doubleValue];
//                account.availableBalance  = [dict[@"model"][@"useMoney"] doubleValue];
//                account.blockedBalance    = [dict[@"model"][@"noUseMoney"] doubleValue];
//                account.receivableBalance = [dict[@"model"][@"newEstcollectMoney"] doubleValue];
//                account.totalIncome       = [dict[@"model"][@"earnAmount"] doubleValue];
//                account.lastIncome        = [dict[@"model"][@"todayEarnAmount"] doubleValue];
//                return account;
//            }];
}

@end
