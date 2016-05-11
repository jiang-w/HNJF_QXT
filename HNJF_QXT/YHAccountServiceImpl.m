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

- (void)updateAccountInfoWithUserIdentity:(NSString *)userId {
    [[[RdServiceAPI sharedInstance]
      signalWithServiceAPI:RDAPI_Account_Basic
      Parameters:@{@"userId": userId}]
     subscribeNext:^(NSDictionary *dict) {
         YHAccountInfo *account    = [YHUserInfo currentUser].account;
         account.totalBalance      = [dict[@"model"][@"total"] doubleValue];
         account.availableBalance  = [dict[@"model"][@"useMoney"] doubleValue];
         account.blockedBalance    = [dict[@"model"][@"noUseMoney"] doubleValue];
         account.receivableBalance = [dict[@"model"][@"newEstcollectMoney"] doubleValue];
         account.totalIncome       = [dict[@"model"][@"earnAmount"] doubleValue];
         account.lastIncome        = [dict[@"model"][@"todayEarnAmount"] doubleValue];
     }];
}

- (RACSignal *)signalForRechargeWithBankNo:(NSString *)bankNo Amount:(double)amount PayPassword:(NSString *)payPassword {
    YHUserInfo *user = [YHUserInfo currentUser];
    NSDictionary *params = @{@"bankNo": bankNo,
                             @"money": [NSString stringWithFormat:@"%.2f", amount],
                             @"pay": @"chinaums",
                             @"payPwd": payPassword,
                             @"type": @"1",
                             @"userId": user.identity
                             };
    return [[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_Account_DoRecharge Parameters:params];
}

//---------------------
- (RACSignal *)currentAccountSignal {
    NSString *userId = [YHUserInfo currentUser].identity;
    if (userId) {
        return [[[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_Account_Basic Parameters:@{@"userId": userId}] map:^id(NSDictionary *dict) {
            YHAccountInfo *account    = [[YHAccountInfo alloc] init];
            account.userId            = userId;
            account.totalBalance      = [dict[@"model"][@"total"] doubleValue];
            account.availableBalance  = [dict[@"model"][@"useMoney"] doubleValue];
            account.blockedBalance    = [dict[@"model"][@"noUseMoney"] doubleValue];
            account.receivableBalance = [dict[@"model"][@"newEstcollectMoney"] doubleValue];
            account.totalIncome       = [dict[@"model"][@"earnAmount"] doubleValue];
            account.lastIncome        = [dict[@"model"][@"todayEarnAmount"] doubleValue];
            return account;
        }];
    }
    else {
        return [RACSignal return:nil];
    }
}

@end
