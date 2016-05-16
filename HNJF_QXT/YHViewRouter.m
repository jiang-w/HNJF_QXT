//
//  YHViewRouter.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewRouter.h"

@interface YHViewRouter()

@property(nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation YHViewRouter

+ (instancetype)sharedInstance {
    static YHViewRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (YHViewController *)viewControllerForViewModel:(YHViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[YHViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"YHMainTabBarViewModel": @"YHMainTabBarController",
             @"YHHomePageViewModel": @"YHHomePageViewController",
             @"YHHighMarginProductListVM": @"YHHighMarginProductListVC",
             @"YHHighMarginProductDetailVM": @"YHHighMarginProductDetailVC",
             @"YHFundProductListVM": @"YHFundProductListVC",
             @"YHAccountCenterVM": @"YHAccountCenterVC",
             @"YHLoginVM": @"YHLoginVC",
             @"YHRegisterVM": @"YHRegisterVC",
             @"YHSettingViewModel": @"YHSettingViewController",
             @"YHValidPhoneNumberVM": @"YHValidPhoneNumberVC",
             @"YHResetPasswordVM": @"YHResetPasswordVC",
             @"YHModifyLoginPwdViewModel": @"YHModifyLoginPwdViewController",
             @"YHResetPasswordVM": @"YHResetPasswordVC",
             @"YHRechargeVM": @"YHRechargeVC",
             @"YHWithdrawVM": @"YHWithdrawVC",
             @"YHValidGesturePasswordVM": @"YHValidGesturePasswordVC"
             };
}

@end
