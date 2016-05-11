//
//  YHAccountService.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHAccountService <NSObject>

- (RACSignal *)currentAccountSignal;

- (RACSignal *)rechargeSignalWithBankCardNumber:(NSString *)cardNumber Password:(NSString *)password Amount:(double)amount;

@end
