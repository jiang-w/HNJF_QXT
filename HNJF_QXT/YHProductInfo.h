//
//  YHProductInfo.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHProductInfo : NSObject

@property (nonatomic, copy  ) NSString       *name;
@property (nonatomic, assign) double         totalAmount;// 产品总额
@property (nonatomic, assign) double         soldAmount;// 已售金额
@property (nonatomic, assign) double         expectedRate;// 预期年化收益率
@property (nonatomic, assign) double         mostAmount;// 最大金额
@property (nonatomic, assign) double         lowestAmount;// 起购金额
@property (nonatomic, assign) int            timeLimit;// 期限
@property (nonatomic, assign) int            timeLimitUnit;// 期限单位（1:天  0:月）
@property (nonatomic, assign) int            holdDays;// 持有天数
@property (nonatomic, assign) BOOL           transferable;// 是否可转
@property (nonatomic, assign) double         saleScale;// 销售比率
@property (nonatomic, assign) NSTimeInterval startDate;// 起息日
@property (nonatomic, assign) NSTimeInterval endDate;// 赎回日

@end
