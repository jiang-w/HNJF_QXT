//
//  YHValidPhoneNumberVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHValidPhoneNumberVM : YHViewModel

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *vCode;
@property (nonatomic, strong, readonly) RACCommand *vCodeCommand;
@property (nonatomic, strong, readonly) RACCommand *submitCommand;

@end
