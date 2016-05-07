//
//  YHFundProductTableCell.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHFundProductTableCell.h"
#import "YHCircleProgressView.h"

@interface YHFundProductTableCell ()

@property (nonatomic, strong) YHFundCellViewModel  *viewModel;
@property (nonatomic, strong) YHCircleProgressView *progressView;
@property (nonatomic, assign) BOOL   didSetupConstraints;

@end

@implementation YHFundProductTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.progressView = [[YHCircleProgressView alloc] init];
    [self addSubview:self.progressView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateConstraints {
    if (!self.didSetupConstraints) {
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.width.mas_equalTo(60);
            make.right.equalTo(self).offset(-20);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)configureCellWithViewModel:(YHFundCellViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self)
    [RACObserve(viewModel, saleScale) subscribeNext:^(id value) {
        @strongify(self)
        [self.progressView setPercent:[value doubleValue] animated:YES];
    }];
}


- (void)dealloc {
    NSLog(@"YHFundProductTableCell dealloc");
}

@end
