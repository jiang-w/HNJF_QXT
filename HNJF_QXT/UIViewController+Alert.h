//
//  UIViewController+Alert.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showInfoWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)showErrorWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)showWarningWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)showSuccessWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
