//
//  YHSettingGesturePasswordVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHSettingGesturePasswordVM : YHViewModel

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPassword;
@property (nonatomic, strong, readonly) RACCommand *ignoreCommand;
@property (nonatomic, strong, readonly) RACCommand *settingGesturePasswordCommand;
@property (nonatomic, strong, readonly) RACCommand *resetPasswordCommand;

@end
