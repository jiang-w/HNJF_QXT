//
//  YHProductServiceImpl.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHProductServiceImpl.h"
#import "RdServiceAPI.h"
#import "NSError+RdServiceAPIResult.h"

@implementation YHProductServiceImpl

- (RACSignal *)homePageDataSignal {
    RACSignal *bannerSignal = [[RdServiceAPI sharedInstance]
                               signalWithServiceApi:RDAPI_Index_Banner andParamters:nil];
    RACSignal *onceProductSignal = [[RdServiceAPI sharedInstance]
                                    signalWithServiceApi:RDAPI_Index_NewHand andParamters:nil];
    RACSignal *highYieldSignal = [[RdServiceAPI sharedInstance]
                                  signalWithServiceApi:RDAPI_Index_BorrowIndex andParamters:nil];
    
    return [RACSignal combineLatest:@[bannerSignal, onceProductSignal, highYieldSignal]
                             reduce:^id (NSDictionary *s1, NSDictionary *s2, NSDictionary *s3) {
                                 NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                                 // 表头图片
                                 [resultDict setValue:s1[@"banner_map"][@"app_banner"] forKey:@"banner"];
                                 NSMutableArray *sections = [NSMutableArray array];
                                 NSDictionary *section;
                                 // 新手专享
                                 if (s2[@"data"]) {
                                     NSDictionary *item = @{@"name": s2[@"data"][@"name"],
                                                            @"totalAmount": s2[@"data"][@"totalCopies"],
                                                            @"expectedRate": s2[@"data"][@"apr"],
                                                            @"lowerAmount": s2[@"data"][@"startCopies"],
                                                            @"upperAmount": s2[@"data"][@"endCopies"],
                                                            @"dueDays": s2[@"data"][@"isDay"],
                                                            @"saleScale": s2[@"data"][@"scales"]
                                                            };
                                     section = @{@"title": @"",
                                                 @"items": @[item],
                                                 @"headerImage": @""
                                                 };
                                     [sections addObject:section];
                                 }
                                 
                                 // 零钱宝
                                 section = @{@"title": @"零钱宝",
                                             @"items": @[@{}],
                                             @"headerImage": @""
                                             };
                                 [sections addObject:section];
                                 
                                 // 高收益理财
                                 NSMutableArray *items = [NSMutableArray array];
                                 for (NSDictionary *dataItem in s3[@"borrowData"]) {
                                     NSDictionary *item = @{@"name": dataItem[@"name"],
                                                            @"totalAmount": dataItem[@"mostAccount"], //产品总额
                                                            @"expectedRate": dataItem[@"apr"], //年化收益
                                                            @"lowerAmount": dataItem[@"lowestAccount"], //起购金额
                                                            @"saleScale": dataItem[@"scales"], //销售比率
                                                            @"timeLimitTip": dataItem[@"timeLimitTip"],
                                                            @"timeLimit": dataItem[@"timeLimit"], //产品期限
                                                            @"isday": dataItem[@"isday"], //产品期限单位（1:天 0:月）
                                                            @"holdDays": dataItem[@"holdDays"], //持有天数
                                                            @"transferable": dataItem[@"transferable"] //是否可转
                                                            };
                                     [items addObject:item];
                                 }

                                 NSString *imageUrl = [NSString stringWithFormat:@"%@", s1[@"banner_map"][@"app_mid_banner"][0][@"picPath"]];
                                 section = @{@"title": @"高收益",
                                             @"items": items,
                                             @"headerImage": imageUrl
                                             };
                                 [sections addObject:section];
                                 
                                 [resultDict setValue:sections forKey:@"sections"];
                                 return resultDict;
                             }];
}

- (RACSignal *)highMarginListSignalWithPage:(NSInteger)page andOrder:(NSInteger)order {
    NSDictionary *params = @{@"page": @(page), @"order": @(order)};
    return [[[RdServiceAPI sharedInstance]
             signalWithServiceApi:RDAPI_Invest_InvestList andParamters:params]
            map:^id(NSDictionary *responseData) {
                return responseData;
            }];
}

- (RACSignal *)highMarginDetailSignalWithId:(NSInteger)productId {
    NSDictionary *params = @{@"borrowId": @(productId)};
    return [[[RdServiceAPI sharedInstance]
             signalWithServiceApi:RDAPI_Invest_Detail andParamters:params]
            map:^id(NSDictionary *responseData) {
                NSDictionary *dict = responseData[@"date"][@"content"];
                return dict;
            }];
}

- (RACSignal *)bondListDataSignalWithPage:(NSInteger)page andOrder:(NSInteger)order {
    NSDictionary *params = @{@"page": @(page), @"order": @(order)};
    return [[[RdServiceAPI sharedInstance]
             signalWithServiceApi:RDAPI_Bond_List andParamters:params]
            map:^id(NSDictionary *responseData) {
                return responseData;
            }];
}

@end
