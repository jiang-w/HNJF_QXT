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
@property (nonatomic, strong, readwrite) RACCommand *updateAccountCommand;

@end

@implementation YHAccountCenterVM

- (void)initialize {
    [super initialize];
    
    self.title = @"我的";
    self.requireToken = YES;
    
    @weakify(self)
    YHAccountInfo *account = [YHUserProfile currentUser].account;
    RAC(self, totalBalance, @"0.00") = [[RACObserve(account, totalBalance) distinctUntilChanged]
                                        map:^id(id value) {
                                            return [NSString currencyStyleStringFromNumber:value];
                                        }];
    
    RAC(self, availableBalance, @"0.00") = [[RACObserve(account, availableBalance) distinctUntilChanged]
                                            map:^id(id value) {
                                                return [NSString currencyStyleStringFromNumber:value];
                                            }];
    
    RAC(self, blockedBalance, @"0.00") = [[RACObserve(account, blockedBalance) distinctUntilChanged]
                                          map:^id(id value) {
                                              return [NSString currencyStyleStringFromNumber:value];
                                          }];
    
    RAC(self, receivableBalance, @"0.00") = [[RACObserve(account, receivableBalance) distinctUntilChanged]
                                             map:^id(id value) {
                                                 return [NSString currencyStyleStringFromNumber:value];
                                             }];
    
    RAC(self, totalIncome, @"0.00") = [[RACObserve(account, totalIncome) distinctUntilChanged]
                                       map:^id(id value) {
                                           return [NSString currencyStyleStringFromNumber:value];
                                       }];
    
    RAC(self, lastIncome, @"0.00") = [[RACObserve(account, lastIncome) distinctUntilChanged]
                                      map:^id(id value) {
                                          return [NSString currencyStyleStringFromNumber:value];
                                      }];
    
    [[RACSignal zip:@[[RACObserve(account, availableBalance) distinctUntilChanged],
                      [RACObserve(account, blockedBalance) distinctUntilChanged],
                      [RACObserve(account, receivableBalance) distinctUntilChanged],
                      [RACObserve(account, totalBalance) distinctUntilChanged]]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         double total = [tuple.fourth doubleValue];
         if (total != 0) {
             self.availableRate  = [tuple.first doubleValue] / total;
             self.blockedRate    = [tuple.second doubleValue] / total;
             self.receivableRate = [tuple.third doubleValue] / total;
         }
     }];
    
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
        YHUserProfile *user = [YHUserProfile currentUser];
        [self.services.accountService updateAccountInfoWithUserIdentity:user.identity];
        return [RACSignal empty];
    }];
}

@end
