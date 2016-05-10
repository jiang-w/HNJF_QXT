//
//  YHUserService.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/29.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHUserService <NSObject>

// 登录
- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password;

// 登出
- (void)logout;

// 验证手机号
- (RACSignal *)validPhoneNumber:(NSString *)phone;

// 发送验证码
- (RACSignal *)sendVerificationCodeForPhone:(NSString *)phoneNumber;

/**
 *  检查短信验证码
 *
 *  @param number 手机号码
 *  @param code   验证码
 *
 *  @return 返回成功与否信号
 */
- (RACSignal *)checkValidCodeWithPhoneNumber:(NSString *)number andValidCode:(NSString *)code;

// 注册
- (RACSignal *)registerUserWithPhoneNumber:(NSString *)phone andPassword:(NSString *)password;

- (RACSignal *)changeLoginPassword:(NSString *)oldPassword withReplacePassword:(NSString *)replacePassword;

@end
