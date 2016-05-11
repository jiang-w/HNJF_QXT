//
//  YHRechargeVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/7.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHRechargeVM.h"

@interface YHRechargeVM ()

@property (nonatomic, strong, readwrite) RACCommand *payCommand;

@end

@implementation YHRechargeVM

- (void)initialize {
    [super initialize];
    
    self.title = @"充值";
    self.requireToken = YES;
    
    self.payCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        double amount = [self.payment doubleValue];
        return [self.services.accountService signalForRechargeWithBankNo:self.bankCardNumber Amount:amount PayPassword:self.payPassword];
    }];
}

@end
