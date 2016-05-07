//
//  YHPasswordManageViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHPasswordManageViewModel.h"
#import "YHModifyLoginPwdViewModel.h"

@interface YHPasswordManageViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *changeLoginPasswordCommand;

@end

@implementation YHPasswordManageViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"密码管理";
    self.requireToken = YES;
    
    @weakify(self)
    self.changeLoginPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self pushViewModel:[[YHModifyLoginPwdViewModel alloc] init] animated:NO];
        return [RACSignal empty];
    }];
}

@end
