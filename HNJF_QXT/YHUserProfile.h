//
//  YHUserProfile.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/11.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHUserProfile : NSObject

@property (nonatomic, copy  ) NSString  *userId;
@property (nonatomic, assign) NSInteger allowGesturePassword;
@property (nonatomic, assign) NSInteger allowTouchId;

+ (instancetype)currentProfile;

@end
