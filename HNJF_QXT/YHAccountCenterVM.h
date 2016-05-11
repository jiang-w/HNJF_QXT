//
//  YHAccountCenterVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHAccountCenterVM : YHViewModel

@property (nonatomic, strong, readonly) NSString   *totalBalance;//账户余额
@property (nonatomic, strong, readonly) NSString   *availableBalance;//可用金额
@property (nonatomic, strong, readonly) NSString   *blockedBalance;//冻结金额
@property (nonatomic, strong, readonly) NSString   *receivableBalance;//应收金额
@property (nonatomic, assign, readonly) double     availableRate;
@property (nonatomic, assign, readonly) double     blockedRate;
@property (nonatomic, assign, readonly) double     receivableRate;
@property (nonatomic, strong, readonly) NSString   *totalIncome;//累计收入
@property (nonatomic, strong, readonly) NSString   *lastIncome;//昨日收益
@property (nonatomic, strong, readonly) RACCommand *rechargeCommand;
@property (nonatomic, strong, readonly) RACCommand *withdrawCommand;
@property (nonatomic, strong, readonly) RACCommand *settingCommand;
@property (nonatomic, strong, readonly) RACCommand *updateAccountCommand;

@end
