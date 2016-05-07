//
//  YHSettingViewController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/10.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSettingViewController.h"
#import "YHSettingViewModel.h"

@interface YHSettingViewController ()

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *bindPhoneGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *bindEmailGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *settingPasswordGesture;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) YHSettingViewModel *viewModel;

@end

@implementation YHSettingViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.logoutButton.rac_command = self.viewModel.logoutCommand;
    
    @weakify(self)
    [self.bindPhoneGesture.rac_gestureSignal subscribeNext:^(id x) {
        NSLog(@"绑定手机");
    }];
    
    [self.bindEmailGesture.rac_gestureSignal subscribeNext:^(id x) {
        NSLog(@"绑定邮箱");
    }];
    
    [self.settingPasswordGesture.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.settingPasswordCommand execute:nil];
    }];
}

- (void)dealloc {
    NSLog(@"YHSettingViewController dealloc");
}

@end
