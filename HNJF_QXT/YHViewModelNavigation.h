//
//  YHViewModelNavigation.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YHViewModel;

@protocol YHViewModelNavigation <NSObject>

@required
- (void)pushViewModel:(YHViewModel *)viewModel animated:(BOOL)animated;

- (void)popViewModelAnimated:(BOOL)animated;

- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)presentViewModel:(YHViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)dismissViewModelAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)resetRootViewModel:(YHViewModel *)viewModel;

@end
