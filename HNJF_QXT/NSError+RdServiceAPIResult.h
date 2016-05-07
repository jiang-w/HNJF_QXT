//
//  NSError+RdServiceAPIResult.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/19.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RdServiceAPI.h"

@interface NSError (RdServiceAPIResult)

+ (NSError *)initWithServiceResult:(RdServiceAPIResult *)result;

@end
