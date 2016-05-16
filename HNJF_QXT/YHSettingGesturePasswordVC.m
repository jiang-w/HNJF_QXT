//
//  YHSettingGesturePasswordVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSettingGesturePasswordVC.h"
#import "YHSettingGesturePasswordVM.h"
#import "UIViewController+Alert.h"

@interface YHSettingGesturePasswordVC ()

@property (weak, nonatomic) IBOutlet KKGestureLockView *gestureLockView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) YHSettingGesturePasswordVM *viewModel;

@end

@implementation YHSettingGesturePasswordVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gestureLockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
    self.gestureLockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    self.gestureLockView.lineColor = gesture_line_Color;
    self.gestureLockView.lineWidth = 5;
    self.gestureLockView.delegate = self;
    if (SCREEN_HEIGHT <= 568) {
        self.gestureLockView.contentInsets = UIEdgeInsetsMake(150, 30, 150, 30);
    }
    else {
        self.gestureLockView.contentInsets = UIEdgeInsetsMake(190, 70, 190, 70);
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [RACObserve(self.viewModel, password) subscribeNext:^(NSString *value) {
        @strongify(self)
        if (!value) {
            self.infoLabel.text = @"手势密码将在您开启程序时启用";
            self.resetButton.hidden = YES;
        }
        else {
            self.infoLabel.text = @"请再次绘制";
            self.resetButton.hidden = NO;
        }
    }];
    
    self.ignoreButton.rac_command = self.viewModel.ignoreCommand;
    self.resetButton.rac_command = self.viewModel.resetPasswordCommand;
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode {
    if ([passcode componentsSeparatedByString:@","].count < 4) {
        self.infoLabel.text = @"至少连接四个点";
        return;
    }
    
    if (!self.viewModel.password) {
        self.viewModel.password = passcode;
    }
    else {
        self.viewModel.confirmPassword = passcode;
        if (![self.viewModel.confirmPassword isEqualToString:self.viewModel.password]) {
            self.infoLabel.text = @"与上一次密码不一致，请重新绘制";
        }
        else {
            [self.viewModel.settingGesturePasswordCommand execute:nil];
        }
    }
}

@end
