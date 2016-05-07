//
//  RdServiceAPI.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  服务请求结果
 */
@interface RdServiceAPIResult : NSObject

@property (nonatomic,assign) NSInteger    code;
@property (nonatomic,strong) NSString     *message;
@property (nonatomic,strong) NSDictionary *responseData;

+ (RdServiceAPIResult *)resultWithDictionary:(NSDictionary *)dict;

+ (RdServiceAPIResult *)resultWithJsonString:(NSString *)jsonString;

+ (RdServiceAPIResult *)resultWithError:(NSError *)error;

@end

/**
 *  融都服务接口
 */
@interface RdServiceAPI : NSObject

+ (instancetype)sharedInstance;

- (NSString*)urlStringWithAPI:(NSString*)api;

- (RACSignal *)signalWithServiceAPI:(NSString *)apiName parameters:(NSDictionary *)params;

- (RACSignal *)signalWithServiceApi:(NSString *)apiName andParamters:(NSDictionary *)params;

@end
