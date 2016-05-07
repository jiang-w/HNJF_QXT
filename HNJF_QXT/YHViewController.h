//
//  YHViewController.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHViewModel.h"
#import "UIViewController+Alert.h"

@interface YHViewController : UIViewController

@property(nonatomic, strong, readonly) YHViewModel *viewModel;

- (instancetype)initWithViewModel:(YHViewModel *)viewModel;

- (void)bindViewModel;

@end
