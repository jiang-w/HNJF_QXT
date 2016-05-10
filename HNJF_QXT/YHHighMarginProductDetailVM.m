//
//  YHHighMarginProductDetailVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/26.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductDetailVM.h"
#import "NSString+Utility.h"

@interface YHHighMarginProductDetailVM ()

@property (nonatomic, strong) YHProductInfo *product;

@end

@implementation YHHighMarginProductDetailVM

- (instancetype)initWithProductId:(NSInteger)productId {
    if (self = [super init]) {
        @weakify(self)
        [[self.services.productService highMarginDetailSignalWithId:productId]
         subscribeNext:^(NSDictionary *dict) {
             @strongify(self)
             YHProductInfo *product = [[YHProductInfo alloc] init];
             product.name          = dict[@"name"];
             product.expectedRate  = [dict[@"apr"] doubleValue];
             product.totalAmount   = [dict[@"account"] doubleValue];
             product.soldAmount    = [dict[@"accountYes"] doubleValue];
             product.lowestAmount  = [dict[@"lowestAccount"] doubleValue];
             product.timeLimit     = [dict[@"timeLimit"] intValue];
             product.timeLimitUnit = [dict[@"isDay"] intValue];
             product.holdDays      = [dict[@"holdDays"] intValue];
             product.saleScale     = [dict[@"scales"] doubleValue];
             product.transferable  = [dict[@"transferable"] intValue];
             product.startDate     = [dict[@"collectionStartTime"] longLongValue] / 1000;
             product.transferable  = [dict[@"collectionEndTime"] longLongValue] / 1000;
             self.product = product;
             
             self.introduction = dict[@"content"];
         }];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self)
    [[RACObserve(self, product) filter:^BOOL(id value) {
        return value != nil;
    }] subscribeNext:^(YHProductInfo *product) {
        @strongify(self)
        self.title = product.name;
        
        self.expectedRate = [NSString stringWithFormat:@"%.2f", product.expectedRate];
        
        if (product.timeLimitUnit == 1) {
            self.closedPeriod = [NSString stringWithFormat:@"项目期限%d天", product.timeLimit];
        }
        else {
            self.closedPeriod = [NSString stringWithFormat:@"项目期限%d个月", product.timeLimit];
        }
        
        self.lowestAmount = [NSString stringWithFormat:@"起投金额%@元", [NSString decimalStyleStringFromNumber:@(product.lowestAmount)]];
        
        self.surplusAmount = [NSString stringWithFormat:@"可投金额%@元", [NSString decimalStyleStringFromNumber:@(product.totalAmount - product.soldAmount)]];
        
        self.totalAmount = [NSString stringWithFormat:@"项目总额%@元", [NSString decimalStyleStringFromNumber:@(product.totalAmount)]];
        
        self.saleScale = product.saleScale;
    }];
    
    self.validInvestSignal = [RACObserve(self, product)
                              map:^id(YHProductInfo *value) {
                                  NSTimeInterval now= [[NSDate date] timeIntervalSince1970];
                                  if (now >= value.startDate) {
                                      return @(NO);
                                  }
                                  else {
                                      return @(YES);
                                  }
                              }];
    
    self.confirmInvestCommand = [[RACCommand alloc]
                                 initWithEnabled:self.validInvestSignal
                                 signalBlock:^RACSignal *(id input) {
                                     return [RACSignal empty];
                                 }];
}


- (void)dealloc {
    NSLog(@"YHHighMarginProductDetailVM dealloc");
}

@end
