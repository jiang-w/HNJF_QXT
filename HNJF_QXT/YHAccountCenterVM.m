//
//  YHAccountCenterVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHAccountCenterVM.h"
#import "YHRechargeVM.h"
#import "YHWithdrawVM.h"
#import "YHSettingViewModel.h"
#import "NSString+Utility.h"

@interface YHAccountCenterVM ()

@property (nonatomic, strong, readwrite) NSString   *totalBalance;//账户余额
@property (nonatomic, strong, readwrite) NSString   *availableBalance;//可用金额
@property (nonatomic, strong, readwrite) NSString   *blockedBalance;//冻结金额
@property (nonatomic, strong, readwrite) NSString   *receivableBalance;//应收金额
@property (nonatomic, assign, readwrite) double     availableRate;
@property (nonatomic, assign, readwrite) double     blockedRate;
@property (nonatomic, assign, readwrite) double     receivableRate;
@property (nonatomic, strong, readwrite) NSString   *totalIncome;//累计收入
@property (nonatomic, strong, readwrite) NSString   *lastIncome;//昨日收益
@property (nonatomic, strong, readwrite) RACCommand *rechargeCommand;
@property (nonatomic, strong, readwrite) RACCommand *withdrawCommand;
@property (nonatomic, strong, readwrite) RACCommand *settingCommand;
@property (nonatomic, strong, readwrite) RACCommand *fetchDataCommand;

@end

@implementation YHAccountCenterVM

- (void)initialize {
    [super initialize];
    
    self.title = @"我的";
    self.requireToken = YES;
    
    @weakify(self)
    self.rechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self pushViewModel:[[YHRechargeVM alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
    self.withdrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self pushViewModel:[[YHWithdrawVM alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
    self.settingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self pushViewModel:[[YHSettingViewModel alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
    self.fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        YHUserProfile *user = [YHUserProfile currentUser];
        return [[[self.services.accountService signalOfAccountInfoWithUserIdentity:user.identity]
                 map:^id(NSDictionary *dict) {
                     YHAccountInfo *accountInfo    = [[YHAccountInfo alloc] init];
                     accountInfo.totalBalance      = [dict[@"model"][@"total"] doubleValue];
                     accountInfo.availableBalance  = [dict[@"model"][@"useMoney"] doubleValue];
                     accountInfo.blockedBalance    = [dict[@"model"][@"noUseMoney"] doubleValue];
                     accountInfo.receivableBalance = [dict[@"model"][@"newEstcollectMoney"] doubleValue];
                     accountInfo.totalIncome       = [dict[@"model"][@"earnAmount"] doubleValue];
                     accountInfo.lastIncome        = [dict[@"model"][@"todayEarnAmount"] doubleValue];
                     return accountInfo;
                 }]
                doNext:^(YHAccountInfo *accountInfo) {
                    @strongify(self)
                    self.totalBalance      = [NSString stringFromNumber:@(accountInfo.totalBalance)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    self.availableBalance  = [NSString stringFromNumber:@(accountInfo.availableBalance)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    self.blockedBalance    = [NSString stringFromNumber:@(accountInfo.blockedBalance)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    self.receivableBalance = [NSString stringFromNumber:@(accountInfo.receivableBalance)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    self.totalIncome       = [NSString stringFromNumber:@(accountInfo.totalIncome)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    self.lastIncome        = [NSString stringFromNumber:@(accountInfo.lastIncome)
                                                              withStyle:NSNumberFormatterDecimalStyle];
                    
                    self.availableRate  = accountInfo.totalBalance != 0 ? accountInfo.availableBalance / accountInfo.totalBalance : 0;
                    self.blockedRate    = accountInfo.totalBalance != 0 ? accountInfo.blockedBalance / accountInfo.totalBalance : 0;
                    self.receivableRate = accountInfo.totalBalance != 0 ? accountInfo.receivableBalance / accountInfo.totalBalance : 0;
                }];
    }];
}

@end
