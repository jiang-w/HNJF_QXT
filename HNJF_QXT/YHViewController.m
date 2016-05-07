//
//  YHViewController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHViewController.h"

@implementation YHViewController

- (instancetype)initWithViewModel:(YHViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self)
            [self bindViewModel];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 244);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = self.viewModel.navigationBarHidden;
}

- (void)bindViewModel {
    RAC(self, title) = RACObserve(self.viewModel, title);
}

@end
