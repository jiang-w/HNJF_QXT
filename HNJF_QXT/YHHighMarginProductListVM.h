//
//  YHHighMarginProductListVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"
#import "YHHighMarginProductCellVM.h"

@interface YHHighMarginProductListVM : YHViewModel

@property (nonatomic, assign) NSInteger selectTabIndex;

@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, strong, readonly) RACCommand *refreshDataCommand;

- (YHHighMarginProductCellVM *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath;

- (void)showProductDetailAtIndexPath:(NSIndexPath *)indexPath;

@end
