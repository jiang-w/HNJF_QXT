//
//  YHMainTabBarViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/8.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHMainTabBarViewModel.h"

@interface YHMainTabBarViewModel ()

@property (nonatomic, strong, readwrite) YHHomePageViewModel       *homePageViewModel;
@property (nonatomic, strong, readwrite) YHFundProductListVM       *fundListViewModel;
@property (nonatomic, strong, readwrite) YHHighMarginProductListVM *highMarginListViewModel;
@property (nonatomic, strong, readwrite) YHAccountCenterVM         *accountCenterViewModel;

@end

@implementation YHMainTabBarViewModel

- (void)initialize {
    [super initialize];
    
    self.homePageViewModel       = [[YHHomePageViewModel alloc] init];
    self.fundListViewModel       = [[YHFundProductListVM alloc] init];
    self.highMarginListViewModel = [[YHHighMarginProductListVM alloc] init];
    self.accountCenterViewModel = [[YHAccountCenterVM alloc] init];
}

@end
