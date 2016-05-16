//
//  YHLoginVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHLoginVM.h"
#import "YHRegisterVM.h"
#import "YHValidPhoneNumberVM.h"
#import "YHSettingGesturePasswordVM.h"

@interface YHLoginVM ()

@property(nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property(nonatomic, strong, readwrite) RACCommand *loginCommand;
@property(nonatomic, strong, readwrite) RACCommand *registerCommand;
@property(nonatomic, strong, readwrite) RACCommand *resetPasswordCommand;
@property(nonatomic, assign) BOOL isRemember;

@end

@implementation YHLoginVM

- (void)initialize {
    [super initialize];
    
    self.title = @"登录";
    
    @weakify(self)
    self.validLoginSignal = [RACSignal
                             combineLatest:@[RACObserve(self, username),
                                             RACObserve(self, password)]
                             reduce:^(NSString *username, NSString *password) {
                                 return @(username.length > 0 && password.length > 0);
                             }];
    
    self.loginCommand = [[RACCommand alloc]
                         initWithEnabled:self.validLoginSignal
                         signalBlock:^RACSignal *(id input) {
                             @strongify(self)
                             YHUserProfile *profile = [YHUserProfile currentProfile];
                             return [[[[self.services.userService loginWithUserName:self.username password:self.password] takeUntil:self.rac_willDeallocSignal]
                                      doNext:^(YHUserInfo *user) {
                                          profile.userId = user.identity;
                                      }]
                                     doCompleted:^{
                                         [self dismissViewModelAnimated:NO completion:nil];
                                         if (profile.allowGesturePassword == -1) {
                                             [self presentViewModel:[[YHSettingGesturePasswordVM alloc] init] animated:NO completion:nil];
                                         }
                                     }];
                         }];
    
    self.registerCommand = [[RACCommand alloc]
                            initWithSignalBlock:^RACSignal *(id input) {
                                @strongify(self)
                                [self pushViewModel:[[YHRegisterVM alloc] init] animated:YES];
                                return [RACSignal empty];
                            }];
    
    self.resetPasswordCommand = [[RACCommand alloc]
                                 initWithSignalBlock:^RACSignal *(id input) {
                                     @strongify(self)
                                     [self pushViewModel:[[YHValidPhoneNumberVM alloc] init] animated:YES];
                                     return [RACSignal empty];
                                 }];
}

- (void)dealloc {
    NSLog(@"YHLoginViewModel dealloc");
}

@end
