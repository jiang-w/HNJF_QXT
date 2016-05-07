//
//  YHHighMarginProductCellVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductCellVM.h"
#import "NSString+Utility.h"

@interface YHHighMarginProductCellVM ()

@property (nonatomic, strong) YHProductInfo *product;

@end

@implementation YHHighMarginProductCellVM

- (instancetype)initWithProduct:(YHProductInfo *)product {
    if (self = [super init]) {
        self.product = product;
        [self bindProduct];
    }
    return self;
}

- (void)bindProduct {
    RAC(self, name) = RACObserve(self.product, name);
    RAC(self, expectedRate, @"0.00") = [RACObserve(self.product, expectedRate)
                                        map:^id(id value) {
                                            return [NSString stringWithFormat:@"%.2f", [value doubleValue]];
                                        }];
    RAC(self, closedPeriod) = [RACSignal combineLatest:@[RACObserve(self.product, timeLimit),
                                                         RACObserve(self.product, timeLimitUnit)]
                                                reduce:^id(id time, id unit) {
                                                    if ([unit intValue] == 0) {
                                                        return [NSString stringWithFormat:@"封闭期%d个月", [time intValue]];
                                                    }
                                                    else {
                                                        return [NSString stringWithFormat:@"封闭期%d天", [time intValue]];
                                                    }
                                                }];
    RAC(self, lowestAmount) = [RACObserve(self.product, lowestAmount)
                               map:^id(id value) {
                                   NSString *moneyString = [NSString stringFromNumber:value withStyle:NSNumberFormatterDecimalStyle];
                                   return [NSString stringWithFormat:@"%@元起", moneyString];
                               }];
    RAC(self, mostAmount) = [RACObserve(self.product, mostAmount)
                             map:^id(id value) {
                                 NSString *moneyString = [NSString stringFromNumber:value withStyle:NSNumberFormatterDecimalStyle];
                                 return [NSString stringWithFormat:@"限额:%@元", moneyString];
                             }];
    RAC(self, surplusAmount) = [RACSignal
                                combineLatest:@[RACObserve(self.product, totalAmount),
                                                RACObserve(self.product, soldAmount)] reduce:^id (id value1, id value2){
                                                    double surplus = [value1 doubleValue] - [value2 doubleValue];
                                                    NSString *moneyString = [NSString stringFromNumber:@(surplus) withStyle:NSNumberFormatterDecimalStyle];
                                                    return [NSString stringWithFormat:@"剩余可投:%@元", moneyString];
                                                }];
    RAC(self, saleScale) = RACObserve(self.product, saleScale);
}


//- (void)dealloc {
//    NSLog(@"YHHighIncomeCellViewModel dealloc");
//}

@end
