//
//  UIViewController+Alert.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <JFMinimalNotifications/JFMinimalNotification.h>

@implementation UIViewController (Alert)

- (void)showInfoWithTitle:(NSString *)title andMessage:(NSString *)message {
    __block JFMinimalNotification *prompt = [JFMinimalNotification
                                             notificationWithStyle:JFMinimalNotificationStyleInfo
                                             title:title
                                             subTitle:message
                                             dismissalDelay:1.2
                                             touchHandler:^{
                                                 [prompt dismiss];
                                             }];
    
    [prompt setTitleFont:[UIFont systemFontOfSize:16]];
    [prompt setSubTitleFont:[UIFont systemFontOfSize:14]];
    
    [self.view addSubview:prompt];
    prompt.presentFromTop = YES;
    [prompt show];
}

- (void)showErrorWithTitle:(NSString *)title andMessage:(NSString *)message {
    __block JFMinimalNotification *prompt = [JFMinimalNotification
                                             notificationWithStyle:JFMinimalNotificationStyleError
                                             title:title
                                             subTitle:message
                                             dismissalDelay:1.2
                                             touchHandler:^{
                                                 [prompt dismiss];
                                             }];
    
    [prompt setTitleFont:[UIFont systemFontOfSize:16]];
    [prompt setSubTitleFont:[UIFont systemFontOfSize:14]];
    
    [self.view addSubview:prompt];
    prompt.presentFromTop = YES;
    [prompt show];
}

- (void)showWarningWithTitle:(NSString *)title andMessage:(NSString *)message {
    __block JFMinimalNotification *prompt = [JFMinimalNotification
                                             notificationWithStyle:JFMinimalNotificationStyleWarning
                                             title:title
                                             subTitle:message
                                             dismissalDelay:1.2
                                             touchHandler:^{
                                                 [prompt dismiss];
                                             }];
    
    [prompt setTitleFont:[UIFont systemFontOfSize:16]];
    [prompt setSubTitleFont:[UIFont systemFontOfSize:14]];
    
    [self.view addSubview:prompt];
    prompt.presentFromTop = YES;
    [prompt show];
}

- (void)showSuccessWithTitle:(NSString *)title andMessage:(NSString *)message {
    __block JFMinimalNotification *prompt = [JFMinimalNotification
                                             notificationWithStyle:JFMinimalNotificationStyleSuccess
                                             title:title
                                             subTitle:message
                                             dismissalDelay:1.2
                                             touchHandler:^{
                                                 [prompt dismiss];
                                             }];
    
    [prompt setTitleFont:[UIFont systemFontOfSize:16]];
    [prompt setSubTitleFont:[UIFont systemFontOfSize:14]];
    
    [self.view addSubview:prompt];
    prompt.presentFromTop = YES;
    [prompt show];
}

@end
