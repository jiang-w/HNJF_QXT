//
//  AppDelegate.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

@end

