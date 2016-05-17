//
//  YHRegisterVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/9.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHRegisterVM.h"
#import "NSString+Utility.h"

@interface YHRegisterVM ()

@property(nonatomic, strong, readwrite) RACCommand *vCodeCommand;
@property(nonatomic, strong, readwrite) RACCommand *submitCommand;
@property(nonatomic, strong, readwrite) RACSignal *validPhoneSignal;
@property(nonatomic, strong, readwrite) RACSignal *validPasswordSignal;
@property(nonatomic, strong, readwrite) RACSignal *validConfirmPwdSignal;
@property(nonatomic, strong, readwrite) RACSignal *validRegisterSignal;

@end

@implementation YHRegisterVM

- (void)initialize {
    [super initialize];
    
    self.title = @"注册";
    
    @weakify(self)
    // 验证手机号码
    self.validPhoneSignal = [RACObserve(self, phoneNumber)
                             map:^id(id value) {
                                 return @([NSString validatePhoneNumber:value]);
                             }];
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
    // 验证是否可以提交
    self.validRegisterSignal = [[RACSignal
                                 combineLatest:@[self.validPhoneSignal,
                                                 self.validPasswordSignal,
                                                 self.validConfirmPwdSignal,
                                                 [RACObserve(self, vCode)
                                                  map:^id(NSString *value) {
                                                      return @(![value isNullOrEmpty]);
                                                  }]
                                                 ]]
                                map:^id(RACTuple *value) {
                                    RACTupleUnpack(id b1, id b2, id b3, id b4) = value;
                                    return @([b1 boolValue] && [b2 boolValue] && [b3 boolValue] && [b4 boolValue]);
                                }];
    
    // 获取验证码
    self.vCodeCommand = [[RACCommand alloc]
                         initWithSignalBlock:^RACSignal *(id input) {
                             @strongify(self)
                             RACSignal *validFormSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                 @strongify(self)
                                 if (![NSString validatePhoneNumber:self.phoneNumber]) {
                                     [subscriber sendError:[NSError errorWithDomain:@"validError" code:101 userInfo:@{@"msg": @"请输入正确的手机号"}]];
                                 }
                                 
                                 [subscriber sendCompleted];
                                 return nil;
                             }];
                             
                             RACSignal *validPhoneSignal = [self.services.userService validPhoneNumber:self.phoneNumber];
                             
                             RACSignal *vCodeSignal = [self.services.userService sendVerificationCodeForPhone:self.phoneNumber];
                             
                             return [[[RACSignal concat:@[validFormSignal, validPhoneSignal, vCodeSignal]]
                                      materialize] takeUntil:self.rac_willDeallocSignal];
                         }];
    
    // 提交注册
    self.submitCommand = [[RACCommand alloc]
                          initWithEnabled:self.validRegisterSignal signalBlock:^RACSignal *(id input) {
                              @strongify(self)
                              RACSignal *validFormSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                  @strongify(self)
                                  if (![NSString validatePhoneNumber:self.phoneNumber]) {
                                      [subscriber sendError:[NSError errorWithDomain:@"validError" code:101 userInfo:@{@"msg": @"手机号码不正确"}]];
                                  }
                                  if (![NSString validatePassword:self.password]) {
                                      [subscriber sendError:[NSError errorWithDomain:@"validError" code:101 userInfo:@{@"msg": @"密码由8-16位数字与字母组成"}]];
                                  }
                                  if (![self.password isEqualToString:self.confirmPwd]) {
                                      [subscriber sendError:[NSError errorWithDomain:@"validError" code:101 userInfo:@{@"msg": @"两次输入的密码不一致"}]];
                                  }
                                  if ([self.vCode isNullOrEmpty]) {
                                      [subscriber sendError:[NSError errorWithDomain:@"validError" code:101 userInfo:@{@"msg": @"验证码不能为空"}]];
                                  }
                                  
                                  [subscriber sendCompleted];
                                  return nil;
                              }];
                              
                              RACSignal *registerSignal = [self.services.userService registerUserWithPhoneNumber:self.phoneNumber Password:self.password ValidCode:self.vCode];
                              
                              RACSignal *loginSignal = [self.services.userService loginWithUserName:self.phoneNumber password:self.password];
                              
                              return [[[RACSignal concat:@[validFormSignal, registerSignal, loginSignal]]
                                       materialize] takeUntil:self.rac_willDeallocSignal];
                          }];
}


- (void)dealloc {
    NSLog(@"RegisterViewModel dealloc");
}

@end
