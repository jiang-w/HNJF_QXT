//
//  YHCircleProgressView.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/26.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHCircleProgressView.h"

@interface YHCircleProgressView ()

@property (nonatomic, assign) double percent;
@property (nonatomic, strong) NSMutableArray *layerArr;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YHCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _percent = 0;
        _layerArr = [NSMutableArray array];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textColor = [UIColor orangeColor];
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setPercent:(double)percent animated:(BOOL)animated {
    self.percent = percent;
    if (percent != 1) {
        self.textLabel.text = @"抢购";
    }
    else {
        self.textLabel.text = @"售罄";
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self strokeCircle];
}

- (void)strokeCircle {
    [self clearLayers];
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) > CGRectGetMidY(self.bounds) ? CGRectGetMidY(self.bounds) : CGRectGetMidX(self.bounds);
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = progress_bar_color.CGColor;
    circleLayer.lineWidth = 1.8;
    UIBezierPath *circlePath = [UIBezierPath
                                bezierPathWithArcCenter:centerPoint
                                radius:radius
                                startAngle:DEGREE_TO_RADIAN(0)
                                endAngle:DEGREE_TO_RADIAN(360)
                                clockwise:YES];
    circleLayer.path = circlePath.CGPath;
    [self.layer addSublayer:circleLayer];
    [self.layerArr addObject:circleLayer];
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor orangeColor].CGColor;
    progressLayer.lineWidth = 2.0;
    UIBezierPath *progressPath = [UIBezierPath
                bezierPathWithArcCenter:centerPoint
                radius:radius
                startAngle:DEGREE_TO_RADIAN(-90)
                endAngle:DEGREE_TO_RADIAN(360 * self.percent - 90)
                clockwise:YES];
    progressLayer.path = progressPath.CGPath;
    [self.layer addSublayer:progressLayer];
    [self.layerArr addObject:progressLayer];
    
    // 添加动画效果
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 0.8;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnimation.autoreverses = NO;
//    [progressLayer addAnimation:pathAnimation forKey:nil];
}

- (void)clearLayers {
    for (CALayer *layer in self.layerArr) {
        [layer removeFromSuperlayer];
    }
    [self.layerArr removeAllObjects];
}

@end
