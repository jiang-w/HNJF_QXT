//
//  YHMainTabBarViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/8.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"
#import "YHHomePageViewModel.h"
#import "YHFundProductListVM.h"
#import "YHHighMarginProductListVM.h"
#import "YHAccountCenterVM.h"

@interface YHMainTabBarViewModel : YHViewModel

@property (nonatomic, strong, readonly) YHHomePageViewModel       *homePageViewModel;
@property (nonatomic, strong, readonly) YHFundProductListVM       *fundListViewModel;
@property (nonatomic, strong, readonly) YHHighMarginProductListVM *highMarginListViewModel;
@property (nonatomic, strong, readonly) YHAccountCenterVM         *accountCenterViewModel;

@end
