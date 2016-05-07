//
//  CALayer+XibConfiguration.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/4.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
