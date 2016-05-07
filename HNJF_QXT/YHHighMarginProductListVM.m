//
//  YHHighMarginProductListVM.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductListVM.h"
#import "YHHighMarginProductDetailVM.h"

@interface YHHighMarginProductListVM ()

@property (nonatomic, strong, readwrite) RACCommand *refreshDataCommand;

@end

@implementation YHHighMarginProductListVM

- (void)initialize {
    [super initialize];
    
    self.title = @"高收益";
    self.products = [NSMutableArray array];
    
    @weakify(self)
    self.refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        if (self.selectTabIndex == 0) {
            return [[[[self.services.productService highMarginListSignalWithPage:1 andOrder:0]
                      doNext:^(NSDictionary *responseData) {
                          @strongify(self)
                          [self.products removeAllObjects];
                          
                          NSArray *keys = @[@"list", @"listThreeMoth", @"listSixMonth"];
                          for (NSString *key in keys) {
                              NSArray *productData = responseData[key];
                              if (productData.count > 0) {
                                  [self.products addObject:@{key: productData}];
                              }
                          }
                      }] materialize] takeUntil:self.rac_willDeallocSignal];
        }
        else {
            return [[[[self.services.productService bondListDataSignalWithPage:1 andOrder:0]
                      doNext:^(NSDictionary *responseData) {
                          @strongify(self)
                          [self.products removeAllObjects];
                      }] materialize] takeUntil:self.rac_willDeallocSignal];
        }
    }];
}

- (YHHighMarginProductCellVM *)cellViewModelWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSDictionary *dict = [self.products objectAtIndex:section];
    NSArray *products = [[dict allValues] firstObject];
    
    NSInteger row = indexPath.row;
    if (row < products.count) {
        NSDictionary *dict = products[row];
        YHProductInfo *product = [[YHProductInfo alloc] init];
        product.name = dict[@"borrowName"];
        product.totalAmount = [dict[@"account"] doubleValue];
        product.soldAmount = [dict[@"accountYes"] doubleValue];
        product.expectedRate = [dict[@"apr"] doubleValue];
        product.timeLimit = [dict[@"timeLimit"] intValue];
        product.timeLimitUnit = [dict[@"isDay"] intValue];
//        product.saleScale = [dict[@"scales"] doubleValue] / 100;
        product.saleScale = product.soldAmount / product.totalAmount;
        product.transferable = [dict[@"transferable"] boolValue];
        return [[YHHighMarginProductCellVM alloc] initWithProduct:product];
    }
    else {
        return nil;
    }
}

- (void)showProductDetailAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSDictionary *dict = [self.products objectAtIndex:section];
    NSArray *products = [[dict allValues] firstObject];
    NSInteger row = indexPath.row;
    if (row < products.count) {
        NSDictionary *dict = products[row];
        double totalAmout = [dict[@"account"] doubleValue];
        double soldAmount = [dict[@"accountYes"] doubleValue];
        if (totalAmout > soldAmount) {
            NSInteger productId = [dict[@"id"] integerValue];
            [self pushViewModel:[[YHHighMarginProductDetailVM alloc] initWithProductId:productId] animated:YES];
        }
    }
}


//- (void)dealloc {
//    NSLog(@"YHHighMarginProductListViewModel dealloc");
//}

@end
