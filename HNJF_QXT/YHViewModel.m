//
//  YHViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"
#import "YHViewModelNavigationImpl.h"
#import "YHViewModelServicesImpl.h"
#import "YHLoginVM.h"

@interface YHViewModel()

@property(nonatomic, strong) id<YHViewModelNavigation> navigation;

@end

@implementation YHViewModel

- (instancetype)init {
    if (self = [super init]) {
        _navigation = [YHViewModelNavigationImpl sharedInstance];
        _services = [YHViewModelServicesImpl sharedInstance];
        _navigationBarHidden = NO;
        _requireToken = NO;
        
        [self initialize];
    }
    return self;
}

- (void)pushViewModel:(YHViewModel *)viewModel animated:(BOOL)animated {
    if (viewModel.requireToken) {
        if (![YHUserInfo currentUser].identity) {
            YHLoginVM *loginViewModel = [[YHLoginVM alloc] init];
            [self presentViewModel:loginViewModel animated:YES completion:nil];
            return;
        }
    }
    
    [self.navigation pushViewModel:viewModel animated:animated];
}

- (void)popViewModelAnimated:(BOOL)animated {
    [self.navigation popViewModelAnimated:animated];
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    [self.navigation popToRootViewModelAnimated:animated];
}

- (void)presentViewModel:(YHViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion {
    [self.navigation presentViewModel:viewModel animated:animated completion:completion];
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self.navigation dismissViewModelAnimated:animated completion:completion];
}

- (void)resetRootViewModel:(YHViewModel *)viewModel {
    [self.navigation resetRootViewModel:viewModel];
}

- (void)initialize {}

@end
