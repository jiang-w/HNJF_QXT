//
//  YHMainTabBarController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/8.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHMainTabBarController.h"
#import "YHMainTabBarViewModel.h"
#import "YHHomePageViewController.h"
#import "YHHomePageViewModel.h"
#import "YHFundProductListVC.h"
#import "YHFundProductListVM.h"
#import "YHHighMarginProductListVC.h"
#import "YHHighMarginProductListVM.h"
#import "YHLoginVM.h"
#import "YHAccountCenterVC.h"
#import "YHAccountCenterVM.h"

@interface YHMainTabBarController () <UITabBarControllerDelegate>

@property(nonatomic, strong) UITabBarController *tabBarController;
@property(nonatomic, strong) YHMainTabBarViewModel *viewModel;

@end

@implementation YHMainTabBarController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.view.frame = self.view.bounds;
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabbar_normal_color, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabbar_select_color, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UIViewController *homeViewController = ({
        YHHomePageViewController *home = [[YHHomePageViewController alloc] initWithViewModel:self.viewModel.homePageViewModel];
        home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_normal"] selectedImage:[[UIImage imageNamed:@"tab_home_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        home;
    });
    
    UIViewController *fundList = ({
        YHFundProductListVC *fund = [[YHFundProductListVC alloc] initWithViewModel:self.viewModel.fundListViewModel];
        fund.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"零钱宝" image:[UIImage imageNamed:@"tab_account_normal"] selectedImage:[[UIImage imageNamed:@"tab_account_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        fund;
    });
    
    UIViewController *highMarginList = ({
        YHHighMarginProductListVC *highMargin = [[YHHighMarginProductListVC alloc] initWithViewModel:self.viewModel.highMarginListViewModel];
        highMargin.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"高收益" image:[UIImage imageNamed:@"tab_product_normal"] selectedImage:[[UIImage imageNamed:@"tab_product_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        highMargin;
    });
    
    UIViewController *accountCenter = ({
        YHAccountCenterVC *profile = [[YHAccountCenterVC alloc] initWithViewModel:self.viewModel.accountCenterViewModel];
        profile.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_more_normal"] selectedImage:[[UIImage imageNamed:@"tab_more_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        profile;
    });
    
    self.tabBarController.viewControllers = @[homeViewController,
                                              fundList,
                                              highMarginList,
                                              accountCenter];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    YHViewController *viewContr = (YHViewController *)viewController;
    if (viewContr && viewContr.viewModel.requireToken) {
        if (![YHUserProfile currentUser].identity) {
            [self.viewModel presentViewModel:[[YHLoginVM alloc] init] animated:YES completion:nil];
            return NO;
        }
    }
    self.title = viewContr.viewModel.title;
    return YES;
}

@end
