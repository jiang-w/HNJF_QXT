//
//  YHProductService.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHProductService <NSObject>

- (RACSignal *)homePageDataSignal;

- (RACSignal *)highMarginListSignalWithPage:(NSInteger)page andOrder:(NSInteger)order;

- (RACSignal *)highMarginDetailSignalWithId:(NSInteger)productId;

- (RACSignal *)bondListDataSignalWithPage:(NSInteger)page andOrder:(NSInteger)order;

@end
