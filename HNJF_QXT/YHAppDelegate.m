//
//  AppDelegate.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHAppDelegate.h"
#import "YHViewModelNavigation.h"
#import "YHViewModelNavigationImpl.h"
#import "YHViewModelServices.h"
#import "YHViewModelServicesImpl.h"
#import "YHLoginVC.h"
#import "YHGesturePasswordVM.h"
#import "YHMainTabBarViewModel.h"
#import "UIViewController+Alert.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface YHAppDelegate ()

@property(nonatomic, strong) id<YHViewModelNavigation> navigation;
@property(nonatomic, strong) id<YHViewModelServices> services;
@property(nonatomic, strong) Reachability *reachability;
@property(nonatomic, assign, readwrite) NetworkStatus networkStatus;

@end

@implementation YHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureApplication];
    [self configureReachability];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSLog(@"是第一次启动");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    self.navigation = [YHViewModelNavigationImpl sharedInstance];
    self.services = [YHViewModelServicesImpl sharedInstance];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.navigation resetRootViewModel:[[YHMainTabBarViewModel alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    @weakify(self)
    [[RACObserve(self, networkStatus) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"Network status:%@", self.reachability.currentReachabilityString);
        NetworkStatus status = [x integerValue];
        switch (status) {
            case NotReachable:
                [self.window.rootViewController showErrorWithTitle:nil andMessage:@"网络连接异常"];
                break;
            case ReachableViaWiFi:
            case ReachableViaWWAN:
                break;
            default:
                break;
        }
    }];
    
    [self presentGestureLock];
}

- (void)configureApplication {
    UINavigationBar *bar = [UINavigationBar appearance];
    // 设置导航栏颜色
    [bar setBarTintColor:RGB(41, 70, 94)];
    // 设置导航栏按钮颜色
    [bar setTintColor:[UIColor whiteColor]];
    // 设置导航栏文字属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [bar setTitleTextAttributes:barAttrs];
    // 设置状态栏文字颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置返回按钮不显示文字
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    // 解决键盘覆盖输入框问题
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)configureReachability {
    self.reachability = Reachability.reachabilityForInternetConnection;

    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                    rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                   map:^(NSNotification *notification) {
                                       return @([notification.object currentReachabilityStatus]);
                                   }]
                                  startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
}

- (void)presentGestureLock {
    [self.navigation presentViewModel:[[YHGesturePasswordVM alloc] init] animated:NO completion:nil];
}

@end
