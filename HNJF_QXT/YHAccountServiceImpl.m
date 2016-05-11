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

- (RACSignal *)rechargeSignalWithBankCardNumber:(NSString *)cardNumber Password:(NSString *)password Amount:(double)amount {
    NSString *userId = [YHUserInfo currentUser].identity;
    NSDictionary *params = @{@"bankNo": cardNumber,
                             @"money": [NSString stringWithFormat:@"%.2f", amount],
                             @"pay": @"chinaums",
                             @"payPwd": password,
                             @"type": @"1",
                             @"userId": userId
                             };
    return [[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_Account_DoRecharge Parameters:params];
}

@end
