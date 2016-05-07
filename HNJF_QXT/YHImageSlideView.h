//
//  YHImageSlideView.h
//  YHImageSlideView
//
//  Created by 江伟 on 15/12/18.
//  Copyright © 2015年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHImageSlideView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) NSArray<NSString *> *imgUrls;

@end
