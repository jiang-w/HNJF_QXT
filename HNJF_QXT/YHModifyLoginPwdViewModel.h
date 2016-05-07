//
//  YHModifyLoginPwdViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHModifyLoginPwdViewModel : YHViewModel

@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *replacePassword;
@property (nonatomic, copy) NSString *confirmPassword;
@property (nonatomic, strong, readonly) RACSignal *validInputSignal;
@property (nonatomic, strong, readonly) RACCommand *changePwdCommand;

@end
