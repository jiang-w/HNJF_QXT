//
//  YHImageHeaderFooterView.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHImageHeaderFooterView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHImageHeaderFooterView ()

@property (nonatomic, strong) UIImageView *image;

@end

@implementation YHImageHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.image = [[UIImageView alloc] init];
        [self.contentView addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImageUrl:(NSString *)url {
    [self.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

@end
