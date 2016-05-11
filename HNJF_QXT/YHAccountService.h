//
//  YHAccountService.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHAccountService <NSObject>

- (void)updateAccountInfoWithUserIdentity:(NSString *)userId;

- (RACSignal *)signalForRechargeWithBankNo:(NSString *)bankNo Amount:(double)amount PayPassword:(NSString *)payPassword;


- (RACSignal *)currentAccountSignal;

@end
