//
//  YHSettingViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSettingViewModel.h"
#import "YHPasswordManageViewModel.h"

@interface YHSettingViewModel ()

@property(nonatomic, strong, readwrite) RACCommand *settingPasswordCommand;
@property(nonatomic, strong, readwrite) RACCommand *logoutCommand;

@end

@implementation YHSettingViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"个人中心";
    self.requireToken = YES;
    
    @weakify(self)
    self.settingPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self pushViewModel:[[YHPasswordManageViewModel alloc] init] animated:NO];
        return [RACSignal empty];
    }];
    
    self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [YHUserProfile setCurrentUser:nil];
        [self popToRootViewModelAnimated:NO];
        return [RACSignal empty];
    }];
}

- (void)dealloc {
    NSLog(@"YHSettingViewModel dealloc");
}

@end
