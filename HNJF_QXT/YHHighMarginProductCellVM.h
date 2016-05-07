//
//  YHHighMarginProductCellVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHHighMarginProductCellVM : NSObject

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, strong) NSArray  *tags;
@property (nonatomic, copy  ) NSString *expectedRate;
@property (nonatomic, copy  ) NSString *closedPeriod;
@property (nonatomic, copy  ) NSString *lowestAmount;
@property (nonatomic, copy  ) NSString *mostAmount;
@property (nonatomic, copy  ) NSString *totalAmount;
@property (nonatomic, copy  ) NSString *surplusAmount;
@property (nonatomic, assign) BOOL     transferable;
@property (nonatomic, assign) double   saleScale;

- (instancetype)initWithProduct:(YHProductInfo *)product;

@end
