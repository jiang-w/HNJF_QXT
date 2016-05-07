//
//  YHAccountCenterVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHAccountCenterVM.h"
#import "YHRechargeVM.h"
#import "YHWithdrawVM.h"
#import "YHSettingViewModel.h"

@interface YHAccountCenterVM ()

@property (nonatomic, strong, readwrite) RACCommand *rechargeCommand;
@property (nonatomic, strong, readwrite) RACCommand *withdrawCommand;
@property (nonatomic, strong, readwrite) RACCommand *settingCommand;

@end

@implementation YHAccountCenterVM

- (void)initialize {
    [super initialize];
    
    self.title = @"我的";
    self.requireToken = YES;
    
    self.rechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self pushViewModel:[[YHRechargeVM alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
    self.withdrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self pushViewModel:[[YHWithdrawVM alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
    self.settingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self pushViewModel:[[YHSettingViewModel alloc] init] animated:YES];
        return [RACSignal empty];
    }];
    
}

@end
