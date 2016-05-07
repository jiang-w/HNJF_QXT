//
//  YHUserInfo.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHUserProfile : NSObject

@property(nonatomic, copy) NSString *identity;
@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, copy) NSString *eMail;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *loginName;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL allowGesturePassword;
@property(nonatomic, assign) BOOL allowTouchId;
@property(nonatomic, copy) NSString *accessToken;

+ (YHUserProfile *)currentUser;

+ (void)setCurrentUser:(YHUserProfile *)user;

@end
