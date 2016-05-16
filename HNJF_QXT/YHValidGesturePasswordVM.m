//
//  YHValidGesturePasswordVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/12.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHValidGesturePasswordVM.h"
#import "YHLoginVM.h"
#import <SSKeychain/SSKeychain.h>

@interface YHValidGesturePasswordVM ()

@property (nonatomic, assign, readwrite) NSInteger trialTimes;
@property (nonatomic, strong, readwrite) RACCommand *validGesturePasswordCommand;

@end

@implementation YHValidGesturePasswordVM

- (void)initialize {
    [super initialize];
    
    self.navigationBarHidden = YES;
    self.trialTimes = 5;
    
    @weakify(self)
    self.validGesturePasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        YHUserProfile *profile = [YHUserProfile currentProfile];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSString *gesturePwd = [SSKeychain passwordForService:@"QXT_GesturePassword" account:profile.userId];
            if ([input isEqualToString:gesturePwd]) {
                [subscriber sendNext:@(YES)];
                [self dismissViewModelAnimated:YES completion:nil];
            }
            else {
                self.trialTimes -= 1;
                if (self.trialTimes == 0) {
                    [self dismissViewModelAnimated:NO completion:nil];
                    [self presentViewModel:[[YHLoginVM alloc] init] animated:NO completion:nil];
                }
            }
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
}

@end
