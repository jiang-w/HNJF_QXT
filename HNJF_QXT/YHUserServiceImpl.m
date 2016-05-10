//
//  YHAccountServiceImpl.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/29.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHUserServiceImpl.h"
#import "RdServiceAPI.h"
#import "NSError+RdServiceAPIResult.h"

@implementation YHUserServiceImpl

- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password {
    return [[[[RdServiceAPI sharedInstance]
              signalWithServiceAPI:RDAPI_User_DoLogin
              Parameters:@{@"userName": username, @"pwd": password}]
             map:^id(NSDictionary *dict) {
                 YHUserProfile *userInfo = [[YHUserProfile alloc] init];
                 userInfo = [[YHUserProfile alloc] init];
                 userInfo.identity = dict[@"userId"];
                 userInfo.loginName = username;
                 userInfo.nickName = dict[@"userName"];
                 userInfo.accessToken = dict[@"oauth_token"];
                 return userInfo;
             }]
            flattenMap:^RACStream *(YHUserProfile *userInfo) {
                return [[[RdServiceAPI sharedInstance]
                         signalWithServiceAPI:RDAPI_Account_Basic
                         Parameters:@{@"userId": userInfo.identity, @"oauth_token": userInfo.accessToken}]
                        map:^id(NSDictionary *dict) {
                            userInfo.phoneNumber = dict[@"userIdentify"][@"phone"];
                            userInfo.eMail = dict[@"userIdentify"][@"email"];
                            userInfo.name = dict[@"userIdentify"][@"realName"];
                            
                            [YHUserProfile setCurrentUser:userInfo];
                            [[NSUserDefaults standardUserDefaults] setObject:userInfo.loginName forKey:@"loginName"];
                            
                            return userInfo;
                        }];
            }];
}

- (void)logout {
    [YHUserProfile setCurrentUser:nil];
}

- (RACSignal *)validPhoneNumber:(NSString *)phone {
    NSDictionary *params = @{@"pwdIdentify": phone};
    return [[[RdServiceAPI sharedInstance]
             signalWithServiceAPI:RDAPI_User_CheckUsernameAvailable Parameters:params]
            flattenMap:^RACStream *(RdServiceAPIResult *result) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    if (result.code == kRdServiceResultSuccess) {
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:[NSError initWithServiceResult:result]];
                    }
                    
                    return nil;
                }];
            }];
}

- (RACSignal *)sendVerificationCodeForPhone:(NSString *)phoneNumber {
    NSDictionary *params = @{@"noticeId": @"notice_reg",
                             @"receiveAddr": phoneNumber,
                             @"type": @"mobilePhone"};
    return [[[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_User_GetCode Parameters:params] flattenMap:^RACStream *(RdServiceAPIResult *result) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (result.code == kRdServiceResultSuccess) {
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:[NSError initWithServiceResult:result]];
            }
            
            return nil;
        }];
    }];
}

- (RACSignal *)registerUserWithPhoneNumber:(NSString *)phone andPassword:(NSString *)password {
    NSDictionary *params = @{@"registerPhone": phone,
                             @"pwd": password};
    return [[[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_User_DoRegister Parameters:params] flattenMap:^RACStream *(RdServiceAPIResult *result) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (result.code == kRdServiceResultSuccess) {
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:[NSError initWithServiceResult:result]];
            }
            
            return nil;
        }];
    }];
}

- (RACSignal *)changeLoginPassword:(NSString *)oldPassword withReplacePassword:(NSString *)replacePassword {
    NSDictionary *params = @{@"pwd": oldPassword,
                             @"newPwd": replacePassword,
                             @"type": @"userpwd"
                             };
    return [[[RdServiceAPI sharedInstance] signalWithServiceAPI:RDAPI_Account_ModifyPwd Parameters:params]
            flattenMap:^RACStream *(RdServiceAPIResult *result) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    if (result.code == kRdServiceResultSuccess) {
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:[NSError initWithServiceResult:result]];
                    }
                    
                    return nil;
                }];
            }];
}

- (RACSignal *)checkValidCodeWithPhoneNumber:(NSString *)number andValidCode:(NSString *)code {
    NSDictionary *params = @{@"receiveAddr": number,
                             @"code": code,
                             @"noticeId": @"get_pwd_phone",
                             @"type": @"mobilePhone"};
    return [[[RdServiceAPI sharedInstance]
             signalWithServiceAPI:RDAPI_User_CheckCode Parameters:params]
            map:^id(NSDictionary *responseData) {
                return responseData;
            }];
}

@end
