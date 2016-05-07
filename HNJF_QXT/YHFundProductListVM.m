//
//  YHFundProductListVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHFundProductListVM.h"

@interface YHFundProductListVM ()

@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation YHFundProductListVM

- (void)initialize {
    [super initialize];
    
    self.title = @"零钱宝";
}

- (YHFundCellViewModel *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (index < self.products.count) {
        return [[YHFundCellViewModel alloc] initWithProduct:self.products[index]];
    }
    else {
        return nil;
    }
}

@end
