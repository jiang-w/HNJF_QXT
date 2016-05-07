//
//  YHResetPasswordVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/4.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHResetPasswordVM.h"
#import "NSString+Utility.h"

@interface YHResetPasswordVM ()

@property (nonatomic, strong, readwrite) RACSignal  *validPasswordSignal;
@property (nonatomic, strong, readwrite) RACSignal  *validConfirmPwdSignal;
@property (nonatomic, strong, readwrite) RACCommand *submitCommand;

@end

@implementation YHResetPasswordVM

- (void)initialize {
    [super initialize];
    
    self.title = @"重置密码";
    
    @weakify(self)
    // 密码强度验证
    self.validPasswordSignal = [RACObserve(self, password)
                                map:^id(NSString *value) {
                                    NSString *regex = @"([A-Z]|[a-z]|[0-9]){8,16}";
                                    return @([value validateStringWithRegex:regex]);
                                }];
    // 验证密码输入是否相同
    self.validConfirmPwdSignal = [RACSignal
                                  combineLatest:@[RACObserve(self, password),
                                                  RACObserve(self, confirmPwd)]
                                  reduce:^(NSString *pwd1, NSString *pwd2){
                                      return @([pwd1 isEqualToString:pwd2]);
                                  }];

    RACSignal *validFormSignal = [RACSignal
                                  combineLatest:@[RACObserve(self, password),
                                                  RACObserve(self, confirmPwd)]
                                  reduce:^id(NSString *p1, NSString *p2) {
                                      BOOL value = [NSString validatePassword:p1] && [p1 isEqualToString:p2];
                                      return @(value);
                                  }];
    
    self.submitCommand = [[RACCommand alloc]
                          initWithEnabled:validFormSignal signalBlock:^RACSignal *(id input) {
                              return [[RACSignal empty] doCompleted:^{
                                  NSLog(@"重设密码");
                              }];
                          }];
}

@end
