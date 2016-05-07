//
//  YHResetPasswordVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/4.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHResetPasswordVC.h"
#import "YHResetPasswordVM.h"

@interface YHResetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton    *submitButton;
@property (nonatomic, strong, readonly) YHResetPasswordVM *viewModel;

@end

@implementation YHResetPasswordVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, password)   = self.passwordTextField.rac_textSignal;
    RAC(self.viewModel, confirmPwd) = self.pwdConfirmTextField.rac_textSignal;
    self.submitButton.rac_command   = self.viewModel.submitCommand;
    
    @weakify(self)
    [self.viewModel.validPasswordSignal
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x boolValue] || [self.passwordTextField.text isEqualToString:@""]) {
             self.passwordTextField.superview.backgroundColor = [UIColor clearColor];
         }
         else {
             self.passwordTextField.superview.backgroundColor = RGB(250, 227, 228);
         }
     }];
    
    [self.viewModel.validConfirmPwdSignal
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x boolValue] || [self.pwdConfirmTextField.text isEqualToString:@""]) {
             self.pwdConfirmTextField.superview.backgroundColor = [UIColor clearColor];
         }
         else {
             self.pwdConfirmTextField.superview.backgroundColor = RGB(250, 227, 228);
         }
     }];
    
    // 根据按钮可用状态，改变背景色
    [RACObserve(self.submitButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            self.submitButton.backgroundColor = button_bg_color_1;
        }
        else {
            self.submitButton.backgroundColor = button_bg_color_2;
        }
    }];
    
    [[self.viewModel.submitCommand.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [self.view endEditing:YES];
    }];
}

@end
