//
//  YHRechargeVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/7.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHRechargeVM : YHViewModel

@property (nonatomic, copy) NSString *bankCardNumber;
@property (nonatomic, copy) NSString *payPassword;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, strong, readonly) NSString *availableBalance;
@property (nonatomic, strong, readonly) NSString *resultBalance;
@property (nonatomic, strong, readonly) RACSignal  *validPaySignal;
@property (nonatomic, strong, readonly) RACCommand *payCommand;

@end
