//
//  YHPercentCircleView.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/5.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHPercentCircleView.h"

@interface YHPercentCircleView ()

@property (nonatomic, strong) NSMutableArray *numbers;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *layerArr;
@property (nonatomic, assign) BOOL           isAnimation;

@end

@implementation YHPercentCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _layerArr = [NSMutableArray arrayWithCapacity:0];
        _numbers  = [NSMutableArray arrayWithCapacity:0];
        _colors   = [NSMutableArray arrayWithCapacity:0];
        _circleLineWidth = 20;
        _backgroundCircleLineWidth = 20;
        _backgroundStrokeColor = [UIColor whiteColor];
        _durationTime = 0.8;
        _isAnimation = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _layerArr = [NSMutableArray arrayWithCapacity:0];
        _numbers  = [NSMutableArray arrayWithCapacity:0];
        _colors   = [NSMutableArray arrayWithCapacity:0];
        _circleLineWidth = 20;
        _backgroundCircleLineWidth = 20;
        _backgroundStrokeColor = [UIColor whiteColor];
        _durationTime = 0.8;
        _isAnimation = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self strokeCircle];
}

- (void)strokeCircle {
    [self clearLayers];
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (CGRectGetMidX(self.bounds) > CGRectGetMidY(self.bounds) ? CGRectGetMidY(self.bounds) : CGRectGetMidX(self.bounds)) - self.circleLineWidth / 2;
    UIBezierPath *percentagePath = [UIBezierPath
                                    bezierPathWithArcCenter:centerPoint
                                    radius:radius
                                    startAngle:-M_PI / 2
                                    endAngle:M_PI * 2 - M_PI / 2
                                    clockwise:YES];
    
    if (self.backgroundStrokeColor && !CGColorEqualToColor(self.backgroundStrokeColor.CGColor, [UIColor clearColor].CGColor)) {
        CAShapeLayer *background = [CAShapeLayer layer];
        background.path = percentagePath.CGPath;
        background.frame = self.bounds;
        background.fillColor = nil;
        background.strokeColor = self.backgroundStrokeColor.CGColor;
        background.lineWidth = self.backgroundCircleLineWidth;
        [self.layer addSublayer:background];
        [self.layerArr addObject:background];
    }
    
    float start = 0;
    for (int i = 0; i < self.numbers.count; i++) {
        float num = [self.numbers[i] floatValue];
        num = num * (1 - self.numbers.count * 0.005);
        UIColor *color = (UIColor *)self.colors[i];
        CAShapeLayer *percentage = [CAShapeLayer layer];
        percentage.path = percentagePath.CGPath;
        percentage.frame = self.bounds;
        percentage.fillColor = nil;
        percentage.strokeColor = color.CGColor;
        percentage.lineWidth = self.circleLineWidth;
        percentage.strokeStart = start;
        percentage.strokeEnd = start + num;
        [self.layer addSublayer:percentage];
        [self.layerArr addObject:percentage];
        // 动画
        if (self.isAnimation && self.durationTime != 0) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0];
            pathAnimation.toValue = [NSNumber numberWithFloat:start + num];
            pathAnimation.duration = self.durationTime * (start + num);
            pathAnimation.speed = 1.0;
            [percentage addAnimation:pathAnimation forKey:nil];
        }
        
        start += num + 0.005;
    }
}

- (void)clearLayers {
    for (CALayer *layer in self.layerArr) {
        [layer removeFromSuperlayer];
    }
    [self.layerArr removeAllObjects];
}


#pragma mark - Public method

- (void)setPercentNumberArray:(NSArray *)numberArray colorArray:(NSArray *)colorArray animated:(BOOL)animated {
    [self.numbers removeAllObjects];
    [self.colors removeAllObjects];
    
    for (int i = 0; i < numberArray.count; i++) {
        if ([numberArray[i] floatValue] != 0) {
            [self.numbers addObject:numberArray[i]];
            [self.colors addObject:colorArray[i]];
        }
    }
    self.isAnimation = animated;
}

- (void)startPercentCircleAnimation {
    [self setNeedsLayout];
}

@end
