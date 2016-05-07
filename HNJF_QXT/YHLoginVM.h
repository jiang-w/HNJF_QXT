//
//  YHLoginVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHLoginVM : YHViewModel

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong, readonly) RACSignal *validLoginSignal;
@property(nonatomic, strong, readonly) RACCommand *loginCommand;
@property(nonatomic, strong, readonly) RACCommand *registerCommand;
@property(nonatomic, strong, readonly) RACCommand *resetPasswordCommand;

@end
