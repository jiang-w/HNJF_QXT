//
//  YHResetPasswordVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/4.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHResetPasswordVM : YHViewModel

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPwd;
@property (nonatomic, strong, readonly) RACSignal  *validPasswordSignal;
@property (nonatomic, strong, readonly) RACSignal  *validConfirmPwdSignal;
@property (nonatomic, strong, readonly) RACCommand *submitCommand;

@end
