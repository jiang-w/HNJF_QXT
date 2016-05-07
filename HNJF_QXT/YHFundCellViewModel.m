//
//  YHFundCellViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHFundCellViewModel.h"

@interface YHFundCellViewModel ()

@property (nonatomic, strong) YHProductInfo *product;

@end

@implementation YHFundCellViewModel

- (instancetype)initWithProduct:(YHProductInfo *)product {
    if (self = [super init]) {
        self.product = product;
        [self bindProduct];
    }
    return self;
}

- (void)bindProduct {
}

@end
