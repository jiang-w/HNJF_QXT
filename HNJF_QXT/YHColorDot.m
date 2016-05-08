//
//  YHColorDot.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/8.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHColorDot.h"

@interface YHColorDot ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation YHColorDot

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaultParameters];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaultParameters];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (CGRectGetMidX(self.bounds) > CGRectGetMidY(self.bounds) ? CGRectGetMidY(self.bounds) : CGRectGetMidX(self.bounds));
    UIBezierPath *circlePath = [UIBezierPath
                                bezierPathWithArcCenter:centerPoint
                                radius:radius
                                startAngle:-M_PI_2
                                endAngle:M_PI * 2 - M_PI_2
                                clockwise:YES];
    self.circleLayer.path = circlePath.CGPath;
    self.circleLayer.frame = self.bounds;
}

- (void)setDefaultParameters {
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.fillColor = [UIColor blackColor].CGColor;
    self.circleLayer.strokeColor = nil;
    self.circleLayer.lineWidth = 0;
    [self.layer addSublayer:self.circleLayer];
}

- (void)updateWithColor:(UIColor *)color {
    self.circleLayer.fillColor = color.CGColor;
}

@end
