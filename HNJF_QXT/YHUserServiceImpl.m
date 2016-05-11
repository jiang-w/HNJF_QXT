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
                 YHUserProfile *user = [YHUserProfile currentUser];
                 user.identity = dict[@"userId"];
                 user.loginName = username;
                 user.nickName = dict[@"userName"];
                 user.accessToken = dict[@"oauth_token"];
                 return user;
             }]
            flattenMap:^RACStream *(YHUserProfile *user) {
                return [[[RdServiceAPI sharedInstance]
                         signalWithServiceAPI:RDAPI_Account_Basic
                         Parameters:@{@"userId": user.identity, @"oauth_token": user.accessToken}]
                        map:^id(NSDictionary *dict) {
                            user.phoneNumber = dict[@"userIdentify"][@"phone"];
                            user.eMail = dict[@"userIdentify"][@"email"];
                            user.name = dict[@"userIdentify"][@"realName"];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:user.loginName forKey:@"loginName"];
                            
                            return user;
                        }];
            }];
}

- (void)logout {
    YHUserProfile *user = [YHUserProfile currentUser];
    user.identity = nil;
    user.loginName = nil;
    user.nickName = nil;
    user.accessToken = nil;
    user.phoneNumber = nil;
    user.eMail = nil;
    user.name = nil;
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
