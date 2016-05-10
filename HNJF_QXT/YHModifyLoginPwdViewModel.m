//
//  YHModifyLoginPwdViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHModifyLoginPwdViewModel.h"

@interface YHModifyLoginPwdViewModel ()

@property (nonatomic, strong, readwrite) RACSignal *validInputSignal;
@property (nonatomic, strong, readwrite) RACCommand *changePwdCommand;

@end

@implementation YHModifyLoginPwdViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"更改登录密码";
    self.requireToken = YES;
    
    @weakify(self)
    self.validInputSignal = [RACSignal
                             combineLatest:@[RACObserve(self, oldPassword),
                                             RACObserve(self, replacePassword),
                                             RACObserve(self, confirmPassword)]
                             reduce:^(NSString *old, NSString *replace, NSString *confirm){
                                 return @(old.length > 0 && replace.length > 0 && [replace isEqualToString:confirm]);
                             }];
    
    self.changePwdCommand = [[RACCommand alloc]
                             initWithEnabled:self.validInputSignal
                             signalBlock:^RACSignal *(id input) {
                                 @strongify(self)
                                 return [[self.services.userService changeLoginPassword:self.oldPassword withReplacePassword:self.replacePassword] doCompleted:^{
                                     [self popViewModelAnimated:NO];
                                 }];
                             }];
}

@end
