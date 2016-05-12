//
//  YHRechargeVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/7.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHRechargeVM.h"
#import "NSString+Utility.h"

@interface YHRechargeVM ()

@property (nonatomic, strong, readwrite) NSString   *availableBalance;
@property (nonatomic, strong, readwrite) NSString   *resultBalance;
@property (nonatomic, strong, readwrite) RACSignal  *validPaySignal;
@property (nonatomic, strong, readwrite) RACCommand *payCommand;

@end

@implementation YHRechargeVM

- (void)initialize {
    [super initialize];
    
    self.title = @"充值";
    self.requireToken = YES;
    
    @weakify(self)
    [[self.services.accountService currentAccountSignal]
     subscribeNext:^(YHAccountInfo *account) {
         @strongify(self)
         self.availableBalance = [NSString currencyStyleStringFromNumber:@(account.availableBalance)];
     }];
    
    [[RACSignal combineLatest:@[RACObserve(self, availableBalance),
                                RACObserve(self, payAmount)]]
     subscribeNext:^(RACTuple *tuple) {
         double before = [[tuple.first stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
         double add = [tuple.second doubleValue];
         self.resultBalance = [NSString currencyStyleStringFromNumber:@(before + add)];
     }];
    
    self.validPaySignal = [RACSignal
                           combineLatest:@[RACObserve(self, payAmount),
                                           RACObserve(self, payPassword)]
                           reduce:^(NSString *amount, NSString *password) {
                               return @(amount.length > 0 && password.length > 0);
                           }];
    
    self.payCommand = [[RACCommand alloc]
                       initWithEnabled:self.validPaySignal signalBlock:^RACSignal *(id input) {
                           @strongify(self)
                           double amount = [self.payAmount doubleValue];
                           return [self.services.accountService rechargeSignalWithBankCardNumber:self.bankCardNumber Password:self.payPassword Amount:amount];
                       }];
}

@end
