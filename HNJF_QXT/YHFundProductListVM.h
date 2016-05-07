//
//  YHFundProductListVM.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"
#import "YHFundCellViewModel.h"

@interface YHFundProductListVM : YHViewModel

- (YHFundCellViewModel *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath;

@end
