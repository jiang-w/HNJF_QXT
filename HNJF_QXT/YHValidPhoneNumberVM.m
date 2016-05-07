//
//  YHValidPhoneNumberVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHValidPhoneNumberVM.h"
#import "YHResetPasswordVM.h"
#import "NSString+Utility.h"

@interface YHValidPhoneNumberVM ()

@property (nonatomic, strong, readwrite) RACCommand *vCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *submitCommand;

@end

@implementation YHValidPhoneNumberVM

- (void)initialize {
    [super initialize];
    
    self.title = @"重置密码";
    
    @weakify(self)
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
                             
                             RACSignal *vCodeSignal = [self.services.accountService sendVerificationCodeForPhone:self.phoneNumber];
                             
                             return [[[RACSignal concat:@[validFormSignal, vCodeSignal]]
                                      materialize] takeUntil:self.rac_willDeallocSignal];
                         }];
    
    RACSignal *validFormSignal = [RACSignal
                                  combineLatest:@[RACObserve(self, phoneNumber),
                                                  RACObserve(self, vCode)]
                                  reduce:^id(NSString *phone, NSString *vCode) {
                                      BOOL value = [NSString validatePhoneNumber:phone] && ![vCode isNullOrEmpty];
                                      return @(value);
                                  }];
    
    self.submitCommand = [[RACCommand alloc]
                          initWithEnabled:validFormSignal signalBlock:^RACSignal *(id input) {
                              return [[[self.services.accountService checkValidCodeWithPhoneNumber:self.phoneNumber andValidCode:self.vCode]
                                       doCompleted:^{
                                           [self popViewModelAnimated:NO];
                                           [self pushViewModel:[[YHResetPasswordVM alloc] init] animated:YES];
                                       }] takeUntil:self.rac_willDeallocSignal];
                          }];
}

@end
