//
//  YHAccountInfo.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHAccountInfo : NSObject

@property (nonatomic, copy  ) NSString *userId;
@property (nonatomic, assign) double   totalBalance;//账户余额
@property (nonatomic, assign) double   availableBalance;//可用金额
@property (nonatomic, assign) double   blockedBalance;//冻结金额
@property (nonatomic, assign) double   receivableBalance;//应收金额
@property (nonatomic, assign) double   totalIncome;//累计收入
@property (nonatomic, assign) double   lastIncome;//昨日收益

@end
