//
//  YHHomePageViewModel.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewModel.h"

@interface YHHomePageViewModel : YHViewModel

@property(nonatomic, strong, readonly) NSArray *bannerUrls;
@property(nonatomic, strong, readonly) RACCommand *refreshDataCommand;

@property(nonatomic, assign, readonly) NSInteger numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)index;

- (NSDictionary *)sectionWithIndex:(NSInteger)index;

@end
