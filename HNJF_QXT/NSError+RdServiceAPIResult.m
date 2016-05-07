//
//  NSError+RdServiceAPIResult.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/19.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "NSError+RdServiceAPIResult.h"

@implementation NSError (RdServiceAPIResult)

+ (NSError *)initWithServiceResult:(RdServiceAPIResult *)result {
    return [NSError
            errorWithDomain:API_ERROR_DOMAIN
            code:result.code
            userInfo:@{@"msg": result.message}];
}

@end
