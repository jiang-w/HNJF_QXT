//
//  YHViewNavigationImpl.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModelNavigationImpl.h"
#import <UIKit/UIKit.h>
#import "YHViewRouter.h"

@interface YHViewModelNavigationImpl()

@property(nonatomic, strong) NSMutableArray *navigationStack;

@end

@implementation YHViewModelNavigationImpl

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static YHViewModelNavigationImpl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _navigationStack = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Navigation

- (void)pushViewModel:(YHViewModel *)viewModel animated:(BOOL)animated {
    UIViewController *viewController = [[YHViewRouter sharedInstance] viewControllerForViewModel:viewModel];
    viewController.hidesBottomBarWhenPushed = YES;
    [[self topNavigationController] pushViewController:viewController animated:animated];
}

- (void)popViewModelAnimated:(BOOL)animated {
    [[self topNavigationController] popViewControllerAnimated:animated];
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    [[self topNavigationController] popToRootViewControllerAnimated:animated];
}

- (void)presentViewModel:(YHViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion {
    UINavigationController *topNavigationController = [self topNavigationController];
    
    UIViewController *viewController = [[YHViewRouter sharedInstance] viewControllerForViewModel:viewModel];
    if (![viewController isKindOfClass:UINavigationController.class]) {
        viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    [self pushNavigationController:(UINavigationController *)viewController];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [topNavigationController presentViewController:viewController animated:animated completion:completion];
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self popNavigationController];
    [[self topNavigationController] dismissViewControllerAnimated:animated completion:completion];
}

- (void)resetRootViewModel:(YHViewModel *)viewModel {
    [self.navigationStack removeAllObjects];
    
    UIViewController *viewController = [[YHViewRouter sharedInstance] viewControllerForViewModel:viewModel];
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self pushNavigationController:(UINavigationController *)viewController];
    }
    YHMainAppDelegate.window.rootViewController = viewController;
}


#pragma mark - Stack Manage

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationStack containsObject:navigationController]) return;
    [self.navigationStack addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationStack.lastObject;
    [self.navigationStack removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationStack.lastObject;
}

@end
