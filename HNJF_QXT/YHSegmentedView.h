//
//  YHSegmentedView.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHSegmentedView;
@protocol YHSegmentedViewDelegate <NSObject>

@optional
- (void)segmentedView:(YHSegmentedView *)view didChangedIndex:(NSUInteger)index;

@end

@interface YHSegmentedView : UIView

@property (nonatomic, assign, readonly) NSInteger selectedIndex;// -1 is defalut value

@property (nonatomic, weak) id <YHSegmentedViewDelegate> delegate;

- (void)setItemTitles:(NSArray *)titles;

@end
