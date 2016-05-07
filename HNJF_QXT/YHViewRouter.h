//
//  YHViewRouter.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHViewController.h"
#import "YHViewModel.h"

@interface YHViewRouter : NSObject

+ (instancetype)sharedInstance;

- (YHViewController *)viewControllerForViewModel:(YHViewModel *)viewModel;

@end
