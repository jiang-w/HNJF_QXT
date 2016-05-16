//
//  YHGesturePasswordVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/12.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHGesturePasswordVM.h"
#import "YHLoginVM.h"

@interface YHGesturePasswordVM ()

@property (nonatomic, assign, readwrite) NSInteger trialTimes;
@property (nonatomic, strong, readwrite) RACCommand *validGesturePasswordCommand;

@end

@implementation YHGesturePasswordVM

- (void)initialize {
    [super initialize];
    
    self.navigationBarHidden = YES;
    self.trialTimes = 5;
    
    @weakify(self)
    self.validGesturePasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            if ([input isEqualToString:@"0,3,6,7,8"]) {
                [subscriber sendNext:@(YES)];
                [self dismissViewModelAnimated:YES completion:nil];
            }
            else {
                self.trialTimes -= 1;
                if (self.trialTimes == 0) {
                    [self dismissViewModelAnimated:NO completion:nil];
                    [self presentViewModel:[[YHLoginVM alloc] init] animated:YES completion:nil];
                }
            }
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
}

@end
