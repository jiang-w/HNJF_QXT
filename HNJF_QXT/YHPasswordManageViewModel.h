//
//  YHPasswordManageViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHPasswordManageViewModel : YHViewModel

@property(nonatomic, strong, readonly) RACCommand *changeLoginPasswordCommand;

@end
