//
//  YHViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHViewModelNavigation.h"
#import "YHViewModelServices.h"

@interface YHViewModel : NSObject <YHViewModelNavigation>

@property (nonatomic, strong) id<YHViewModelServices> services;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, assign) BOOL     navigationBarHidden;

@property (nonatomic, assign) BOOL     requireToken;

- (void)initialize;

@end
