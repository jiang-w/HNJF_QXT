//
//  RdServiceAPI.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/14.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "RdServiceAPI.h"
#import "NSString+Utility.h"
#import "NSDictionary+Output.h"

@implementation RdServiceAPIResult

+ (instancetype)resultWithDictionary:(NSDictionary *)dict {
    return [[RdServiceAPIResult alloc] initWithDictionary:dict];
}

+ (instancetype)resultWithJsonString:(NSString *)jsonString {
    return [[RdServiceAPIResult alloc] initWithJsonString:jsonString];
}

+ (instancetype)resultWithError:(NSError *)error {
    return [[RdServiceAPIResult alloc] initWithError:error];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _code = [dict integerValueForKey:@"res_code"];
        _message = [dict stringValueForKey:@"res_msg"];
        _responseData = [dict dictionaryForKey:@"res_data"];
    }
    return self;
}

- (id)initWithJsonString:(NSString *)jsonString {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if(dict) {
        return [self initWithDictionary:dict];
    }
    else {
        NSLog(@"%s: Invalid jsonString! jsonString = \"%@\"", __func__, jsonString);
    }
    return nil;
}

- (id)initWithError:(NSError*)error {
    if (self = [super init]) {
        _code = kRdServiceNetworkingFailure;
        _message = @"网络传输失败";
        _responseData = @{};
    }
    return self;
}

@end


@interface RdServiceAPI ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation RdServiceAPI

+ (instancetype)sharedInstance {
    static RdServiceAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:PRODUCT_SERVER_URL]];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/x-json", @"text/plain", nil];
        [self.sessionManager.requestSerializer setTimeoutInterval:15];
    }
    return self;
}

- (RACSignal *)signalWithServiceAPI:(NSString *)apiName Parameters:(NSDictionary *)params {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSDictionary *requestParams = [self getRequsetParameters:params];
        NSURLSessionDataTask *task = [self.sessionManager
                                      GET:apiName
                                      parameters:requestParams
                                      progress:nil
                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                          RdServiceAPIResult *result = [RdServiceAPIResult resultWithDictionary:responseObject];
                                          if (result.code == kRdServiceResultSuccess || result.code == kRdServiceResultNoData) {
                                              [subscriber sendNext:result.responseData];
                                              [subscriber sendCompleted];
                                          }
                                          else {
                                              NSError *error = [NSError
                                                                errorWithDomain:API_ERROR_DOMAIN
                                                                code:result.code
                                                                userInfo:@{@"msg": result.message}];
                                              [subscriber sendError:error];
                                          }
                                      }
                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                          NSError *resetError = [NSError
                                                                 errorWithDomain:API_ERROR_DOMAIN
                                                                 code:kRdServiceNetworkingFailure
                                                                 userInfo:@{@"msg": @"服务请求出错"}];
                                          [subscriber sendError:resetError];
                                      }];
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
                NSLog(@"Service network signal disposed!");
            }
        }];
    }];
}

- (NSString *)currentTimeStamp {
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    return timeSp;
}

- (NSString *)sginaWithTimeStamp:(NSString*)timeStamp {
    NSString * tmpStr = [NSString stringWithFormat:@"%@%@", APP_SECRET, timeStamp];
    tmpStr = [[NSString md5WithString:tmpStr] stringByAppendingString:APP_KEY];
    tmpStr = [[NSString md5WithString:tmpStr] uppercaseString];//将所有小写字母转成大写
    return tmpStr;
}

- (NSDictionary *)getRequsetParameters:(NSDictionary *)params {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([dic objectForKey:@"appkey"] == nil) {
        [dic setObject:APP_KEY forKey:@"appkey"];
    }
    if ([dic objectForKey:@"ts"] == nil) {
        [dic setObject:[self currentTimeStamp] forKey:@"ts"];
    }
    if( [dic objectForKey:@"signa"] == nil ){
        [dic setObject:[self sginaWithTimeStamp:dic[@"ts"]] forKey:@"signa"];
    }
    
    if ([YHUserProfile currentUser]) {
        [dic setObject:[YHUserProfile currentUser].identity forKey:@"userId"];
        [dic setObject:[YHUserProfile currentUser].accessToken forKey:@"oauth_token"];
    }
    return dic;
}

@end
