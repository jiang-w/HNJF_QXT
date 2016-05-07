//
//  YHHighMarginProductDetailVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/26.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductDetailVC.h"
#import "YHHighMarginProductDetailVM.h"
#import "YHHighMarginDetailHeader.h"
#import "YHHighMarginDetailSummary.h"
#import "YHSegmentedView.h"
#import "YHInvestAmountInput.h"

@interface YHHighMarginProductDetailVC () <YHSegmentedViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) YHHighMarginProductDetailVM *viewModel;
@property (nonatomic, strong) UIScrollView                *scrollView;
@property (nonatomic, strong) YHHighMarginDetailHeader    *header;
@property (nonatomic, strong) YHHighMarginDetailSummary   *summary;
@property (nonatomic, strong) YHSegmentedView             *segmented;
@property (nonatomic, strong) YHInvestAmountInput         *investInput;
@property (nonatomic, strong) UIView                      *containerView;
@property (nonatomic, strong) UIWebView                   *webView;
@property (nonatomic, assign) BOOL                        hasUpdatedConstraints;

@end

@implementation YHHighMarginProductDetailVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.header];
    [self.scrollView addSubview:self.summary];
    [self.scrollView addSubview:self.segmented];
    [self.scrollView addSubview:self.containerView];
    [self.view addSubview:self.investInput];
}


#pragma mark - Layout

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (!self.hasUpdatedConstraints) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
            make.bottom.equalTo(self.view).offset(-49);
        }];
        
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.width.equalTo(self.scrollView);
            make.height.mas_offset(200);
        }];
        
        [self.summary mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header.mas_bottom).offset(10);
            make.left.right.equalTo(self.scrollView);
            make.height.mas_offset(70);
        }];
        
        [self.segmented mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.summary.mas_bottom).offset(10);
            make.left.right.equalTo(self.scrollView);
            make.height.mas_offset(30);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmented.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.height.mas_greaterThanOrEqualTo(240).priorityLow();
            make.bottom.equalTo(self.scrollView);
        }];
        
        [self.investInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_offset(49);
        }];
        
        self.hasUpdatedConstraints = YES;
    }
}


#pragma mark - Bind signal

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    RAC(self.header.expectedRateLabel, text, @"0.00") = RACObserve(self.viewModel, expectedRate);
    RAC(self.header.closedPeriod, text, @"")          = RACObserve(self.viewModel, closedPeriod);
    RAC(self.header.lowestAmountLabel, text, @"")     = RACObserve(self.viewModel, lowestAmount);
    RAC(self.header.surplusAmountLabel, text, @"")    = RACObserve(self.viewModel, surplusAmount);
    RAC(self.header.totalAmountLabel, text, @"")      = RACObserve(self.viewModel, totalAmount);
    RAC(self.header, saleScale, 0)                    = RACObserve(self.viewModel, saleScale);
    self.investInput.confirmButton.rac_command        = self.viewModel.confirmInvestCommand;

    [RACObserve(self.viewModel, transferable)
     subscribeNext:^(id x) {
         self.summary.transferLabel.text = [x boolValue] ? @"起息后可转让" : @"不可转让";
     }];
    
    [[RACObserve(self.viewModel, introduction)
      filter:^BOOL(id value) {
          return value && ![value isEqualToString:@""];
      }]
     subscribeNext:^(NSString *htmlString) {
         @strongify(self)
         if (self.segmented.selectedIndex == 0) {
             [self.webView loadHTMLString:htmlString baseURL:nil];
             [self reloadContentView:self.webView];
         }
     }];
    
    // 是否可进行购买
    [self.viewModel.validInvestSignal
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x boolValue]) {
             self.investInput.confirmButton.backgroundColor = [UIColor orangeColor];
             self.investInput.textField.enabled = YES;
         }
         else {
             self.investInput.confirmButton.backgroundColor = [UIColor lightGrayColor];
             self.investInput.textField.enabled = NO;
         }
     }];
    
    // 切换产品介绍
    [[self rac_signalForSelector:@selector(segmentedView:didChangedIndex:)
                    fromProtocol:@protocol(YHSegmentedViewDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         NSInteger index = [[tuple second] integerValue];
         switch (index) {
             case 0:
                 [self reloadContentView:self.webView];
                 break;
             case 1:
                 [self reloadContentView:[[UIView alloc] init]];
                 break;
             case 2:
                 break;
             case 3:
                 break;
             default:
                 return;
         }
     }];
    
    // Web页面加载完成后，重新改变view高度
    [[self rac_signalForSelector:@selector(webViewDidFinishLoad:)
                    fromProtocol:@protocol(UIWebViewDelegate) ]
     subscribeNext:^(id x) {
         @strongify(self)
         CGFloat webViewHeight =[self.webView.scrollView contentSize].height;
         [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(webViewHeight);
         }];
     }];
    
    // 点击背景消失键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapRecognizer];
    [[tapRecognizer rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }];
}

- (void)reloadContentView:(UIView *)view {
    for (UIView *sub in self.containerView.subviews) {
        [sub removeFromSuperview];
    }
    
    [self.containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}


#pragma mark - Property

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (YHHighMarginDetailHeader *)header {
    if (!_header) {
        _header = [[[NSBundle mainBundle]
                    loadNibNamed:@"YHHighMarginDetailHeader"
                    owner:self options:nil] firstObject];
    }
    return _header;
}

- (YHHighMarginDetailSummary *)summary {
    if (!_summary) {
        _summary = [[[NSBundle mainBundle]
                     loadNibNamed:@"YHHighMarginDetailSummary"
                     owner:self options:nil] firstObject];
    }
    return _summary;
}

- (YHSegmentedView *)segmented {
    if (!_segmented) {
        _segmented = [[YHSegmentedView alloc] init];
        [_segmented setItemTitles:@[@"产品介绍", @"产品资料", @"购买记录", @"常见问题"]];
        _segmented.delegate = self;
    }
    return _segmented;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (YHInvestAmountInput *)investInput {
    if (!_investInput) {
        _investInput = [[[NSBundle mainBundle]
                             loadNibNamed:@"YHInvestAmountInput"
                             owner:self options:nil] firstObject];
    }
    return _investInput;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}


- (void)dealloc {
    NSLog(@"YHHighMarginProductDetailVC dealloc");
}

@end
