//
//  YHAccountCenterVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHAccountCenterVM : YHViewModel

@property (nonatomic, strong, readonly) RACCommand *rechargeCommand;
@property (nonatomic, strong, readonly) RACCommand *withdrawCommand;
@property (nonatomic, strong, readonly) RACCommand *settingCommand;

@end
