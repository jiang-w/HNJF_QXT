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
@property (nonatomic, strong, readwrite) NSString   *totalIncome;//累计收入
@property (nonatomic, strong, readwrite) NSString   *lastIncome;//昨日收益
@property (nonatomic, assign, readwrite) double     availableRate;
@property (nonatomic, assign, readwrite) double     blockedRate;
@property (nonatomic, assign, readwrite) double     receivableRate;
@property (nonatomic, strong, readwrite) RACCommand *rechargeCommand;
@property (nonatomic, strong, readwrite) RACCommand *withdrawCommand;
@property (nonatomic, strong, readwrite) RACCommand *settingCommand;
@property (nonatomic, strong, readwrite) RACCommand *updateAccountCommand;

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
    
    self.updateAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self.services.accountService currentAccountSignal]
                doNext:^(YHAccountInfo *account) {
                    @strongify(self)
                    self.totalBalance      = [NSString currencyStyleStringFromNumber:@(account.totalBalance)];
                    self.availableBalance  = [NSString currencyStyleStringFromNumber:@(account.availableBalance)];
                    self.blockedBalance    = [NSString currencyStyleStringFromNumber:@(account.blockedBalance)];
                    self.receivableBalance = [NSString currencyStyleStringFromNumber:@(account.receivableBalance)];
                    self.lastIncome        = [NSString currencyStyleStringFromNumber:@(account.lastIncome)];
                    self.totalIncome       = [NSString currencyStyleStringFromNumber:@(account.totalIncome)];
                    self.availableRate     = account.totalBalance != 0 ? account.availableBalance / account.totalBalance : 0;
                    self.blockedRate       = account.totalBalance != 0 ? account.blockedBalance / account.totalBalance : 0;
                    self.receivableRate    = account.totalBalance != 0 ? account.receivableBalance / account.totalBalance : 0;
                }];
    }];
}

@end
