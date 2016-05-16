//
//  YHValidGesturePasswordVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/12.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHValidGesturePasswordVM : YHViewModel

@property (nonatomic, assign, readonly) NSInteger trialTimes;
@property (nonatomic, strong, readonly) RACCommand *validGesturePasswordCommand;

@end
