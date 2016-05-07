//
//  YHFundCellViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHFundCellViewModel : NSObject

@property (nonatomic, assign) double   saleScale;

- (instancetype)initWithProduct:(YHProductInfo *)product;

@end
