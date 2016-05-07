//
//  YHHighMarginProductCell.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductCell.h"
#import "YHCircleProgressView.h"

@interface YHHighMarginProductCell ()

@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *expectedRateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *closedPeriod;
@property (weak, nonatomic) IBOutlet UILabel     *lowestAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel     *mostAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel     *surplusAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *transferImg;
@property (nonatomic, strong) YHHighMarginProductCellVM *viewModel;
@property (nonatomic, strong) YHCircleProgressView *progressView;
@property (nonatomic, assign) BOOL   didSetupConstraints;

@end

@implementation YHHighMarginProductCell

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


- (void)configureCellWithViewModel:(YHHighMarginProductCellVM *)viewModel {
    self.viewModel = viewModel;
    @weakify(self)
    RAC(self.nameLabel, text)         = RACObserve(viewModel, name);
    RAC(self.expectedRateLabel, text) = RACObserve(viewModel, expectedRate);
    RAC(self.closedPeriod, text)      = RACObserve(viewModel, closedPeriod);
    RAC(self.lowestAmountLabel, text) = RACObserve(viewModel, lowestAmount);
    RAC(self.mostAmountLabel, text)   = RACObserve(viewModel, mostAmount);
    RAC(self.surplusAmountLabel, text) = RACObserve(viewModel, surplusAmount);
    
    RAC(self.transferImg, hidden) = [RACObserve(viewModel, transferable)
                                     map:^id(id value) {
                                         return @(![value boolValue]);
                                     }];
    
    [RACObserve(viewModel, saleScale) subscribeNext:^(id value) {
        @strongify(self)
        [self.progressView setPercent:[value doubleValue] animated:YES];
    }];
    
    // 进度条
//    [[[RACObserve(viewModel, saleScale) deliverOnMainThread] delay:0.01]
//     subscribeNext:^(id value) {
//         @strongify(self)
//         CGFloat progressBarHigh = self.progressView.frame.size.height;
//         CGFloat progressBarWidth = self.progressView.frame.size.width * [value doubleValue];
//         
//         self.progressBar.frame = CGRectMake(0, 0, 0, progressBarHigh);
//         [UIView animateWithDuration:0.6 animations:^{
//             self.progressBar.frame = CGRectMake(0, 0, progressBarWidth, progressBarHigh);
//         }];
//     }];
    
}

//- (void)dealloc {
//    NSLog(@"YHHighIncomeTableCell dealoc");
//}

@end
