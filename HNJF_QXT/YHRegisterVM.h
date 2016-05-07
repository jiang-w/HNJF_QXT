//
//  YHRegisterVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/9.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHRegisterVM : YHViewModel

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPwd;
@property (nonatomic, copy) NSString *vCode;
@property (nonatomic, strong, readonly) RACCommand *vCodeCommand;
@property (nonatomic, strong, readonly) RACCommand *submitCommand;
@property (nonatomic, strong, readonly) RACSignal  *validPhoneSignal;
@property (nonatomic, strong, readonly) RACSignal  *validPasswordSignal;
@property (nonatomic, strong, readonly) RACSignal  *validConfirmPwdSignal;

@end
