//
//  YHHighMarginProductDetailVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/26.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHHighMarginProductDetailVM : YHViewModel

@property (nonatomic, copy  ) NSString   *expectedRate;
@property (nonatomic, copy  ) NSString   *closedPeriod;
@property (nonatomic, copy  ) NSString   *lowestAmount;
@property (nonatomic, copy  ) NSString   *totalAmount;
@property (nonatomic, copy  ) NSString   *surplusAmount;
@property (nonatomic, assign) BOOL       transferable;
@property (nonatomic, assign) double     saleScale;
@property (nonatomic, strong) NSString   *introduction;

@property (nonatomic, strong) RACSignal  *validInvestSignal;
@property (nonatomic, strong) RACCommand *confirmInvestCommand;

- (instancetype)initWithProductId:(NSInteger)productId;

@end
