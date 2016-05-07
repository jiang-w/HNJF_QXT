//
//  YHViewModelServicesImpl.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/29.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHViewModelServices.h"

@interface YHViewModelServicesImpl : NSObject <YHViewModelServices>

+ (instancetype)sharedInstance;

@end
