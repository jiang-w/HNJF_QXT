//
//  YHSettingGesturePasswordVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSettingGesturePasswordVM.h"

@interface YHSettingGesturePasswordVM ()

@property (nonatomic, strong, readwrite) RACCommand *ignoreCommand;
@property (nonatomic, strong, readwrite) RACCommand *settingGesturePasswordCommand;
@property (nonatomic, strong, readwrite) RACCommand *resetPasswordCommand;

@end

@implementation YHSettingGesturePasswordVM

- (void)initialize {
    [super initialize];
    
    self.navigationBarHidden = YES;
    
    @weakify(self)
    self.ignoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        YHUserProfile *profile = [YHUserProfile currentProfile];
        if (profile.allowGesturePassword == -1) {
            profile.allowGesturePassword = 0;
        }
        [self dismissViewModelAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    
    self.settingGesturePasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        if (self.password && [self.confirmPassword isEqualToString:self.password]) {
            YHUserProfile *profile = [YHUserProfile currentProfile];
            profile.allowGesturePassword = 1;
            [self dismissViewModelAnimated:YES completion:nil];
        }
        return [RACSignal empty];
    }];
    
    self.resetPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.password = nil;
        self.confirmPassword = nil;
        return [RACSignal empty];
    }];
}

@end
