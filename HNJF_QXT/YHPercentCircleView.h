//
//  YHPercentCircleView.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHPercentCircleView : UIView

//前景圆的线条宽度
@property (nonatomic, assign) CGFloat circleLineWidth;
//背景圆的线条宽度
@property (nonatomic, assign) CGFloat backgroundCircleLineWidth;
//背景圆的颜色
@property (nonatomic, strong) UIColor *backgroundStrokeColor;
//动画执行时间
@property (nonatomic, assign) CGFloat durationTime;


/**
 *  给定每个数的百分比和对应颜色画圆，numberArray数组中的数值加和必须是1
 *
 *  @param numberArray 包含每个种类的百分比
 *  @param colorArray  每个种类对应的显示颜色
 *  @param animated    是否需要动画
 */
- (void)setPercentNumberArray:(NSArray *)numberArray colorArray:(NSArray *)colorArray animated:(BOOL)animated;

/**
 *  开始绘制
 */
- (void)startStrokePercentCircle;

@end
