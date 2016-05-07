//
//  YHHomePageViewModel.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHomePageViewModel.h"

@interface YHHomePageViewModel ()

@property(nonatomic, strong, readwrite) NSArray *bannerUrls;
@property(nonatomic, strong, readwrite) NSDictionary *responseData;
@property(nonatomic, strong, readwrite) RACCommand *refreshDataCommand;

@end

@implementation YHHomePageViewModel

- (void)initialize {
    self.title = @"首页";
    self.navigationBarHidden = YES;
    
    @weakify(self)
    self.refreshDataCommand = [[RACCommand alloc]
                               initWithSignalBlock:^RACSignal *(id input) {
                                   @strongify(self)
                                   return [[[[self.services.productService homePageDataSignal] materialize]
                                            takeUntil:self.rac_willDeallocSignal]
                                           doNext:^(RACEvent *event) {
                                               @strongify(self)
                                               if (event.eventType == RACEventTypeNext) {
                                                   self.responseData = event.value;
                                                   NSMutableArray *imgArr = [NSMutableArray array];
                                                   for (NSDictionary *item in self.responseData[@"banner"]) {
                                                       [imgArr addObject:item[@"picPath"]];
                                                   }
                                                   self.bannerUrls = imgArr;
//                                                   NSLog(@"%@", self.responseData);
                                               }
                                           }];
                               }];
}

- (NSInteger)numberOfSections {
    return [self.responseData[@"sections"] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)index {
    return [[self.responseData[@"sections"] objectAtIndex:index][@"items"] count];
}

- (NSDictionary *)sectionWithIndex:(NSInteger)index {
    return [self.responseData[@"sections"] objectAtIndex:index];
}

- (void)dealloc {
    NSLog(@"YHHomePageViewModel dealloc");
}

@end
