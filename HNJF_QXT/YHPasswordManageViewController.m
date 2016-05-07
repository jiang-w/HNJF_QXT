//
//  YHPasswordManageViewController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHPasswordManageViewController.h"
#import "YHPasswordManageViewModel.h"

@interface YHPasswordManageViewController ()

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *changeLoginPwdGesture;
@property (nonatomic, strong) YHPasswordManageViewModel *viewModel;

@end

@implementation YHPasswordManageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindViewModel {
    @weakify(self)
    [self.changeLoginPwdGesture.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.changeLoginPasswordCommand execute:nil];
    }];
    
    
}

@end
