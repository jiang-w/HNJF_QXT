//
//  YHViewModelServices.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/29.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHAccountService.h"
#import "YHProductService.h"

@protocol YHViewModelServices <NSObject>

@property(nonatomic, strong, readonly) id<YHAccountService> accountService;
@property(nonatomic, strong, readonly) id<YHProductService> productService;

@end
