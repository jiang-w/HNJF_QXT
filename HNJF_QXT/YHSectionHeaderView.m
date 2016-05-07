//
//  YHHomePageSectionHeader.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSectionHeaderView.h"

@interface YHSectionHeaderView ()

@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation YHSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHue:0.07 saturation:0.18 brightness:1 alpha:1];
        
        UILabel *ico = [[UILabel alloc] init];
        ico.backgroundColor = [UIColor colorWithHue:0.07 saturation:1 brightness:0.98 alpha:1];
        [self.contentView addSubview:ico];
        [ico mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.mas_offset(3);
            make.height.mas_offset(15);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor colorWithHue:0.59 saturation:0.26 brightness:0.53 alpha:1];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
