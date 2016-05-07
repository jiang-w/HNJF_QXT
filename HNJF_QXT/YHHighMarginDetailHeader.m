//
//  YHHighMarginDetailHeader.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/1.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginDetailHeader.h"

@interface YHHighMarginDetailHeader ()

@property (weak, nonatomic) IBOutlet UILabel *saleScaleLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBar;

@end

@implementation YHHighMarginDetailHeader

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[[RACObserve(self, saleScale) distinctUntilChanged] deliverOnMainThread]
         subscribeNext:^(id value) {
             double scale = [value doubleValue];
             self.saleScaleLabel.text = [NSString stringWithFormat:@"%.2f%%", scale];
             
             [self.progressBar mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.width.equalTo(self.progressView).multipliedBy(scale / 100);
             }];
             [self.progressBar setNeedsLayout];
             [UIView animateWithDuration:0.8 animations:^{
                 [self.progressBar layoutIfNeeded];
             }];
             
         }];
    }
    return self;
}

@end
