//
//  YHRegisterVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/9.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHRegisterVC.h"
#import "YHRegisterVM.h"

@interface YHRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *vCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton    *vCodeButton;
@property (weak, nonatomic) IBOutlet UIButton    *submitButton;
@property (nonatomic, strong, readonly) YHRegisterVM *viewModel;

@end

@implementation YHRegisterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, phoneNumber) = self.phoneNumberTextField.rac_textSignal;
    RAC(self.viewModel, password)    = self.passwordTextField.rac_textSignal;
    RAC(self.viewModel, confirmPwd)  = self.confirmPwdTextField.rac_textSignal;
    RAC(self.viewModel, vCode)       = self.vCodeTextField.rac_textSignal;
    self.vCodeButton.rac_command     = self.viewModel.vCodeCommand;
    self.submitButton.rac_command    = self.viewModel.submitCommand;
    
    @weakify(self)
    [self.viewModel.validPhoneSignal
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x boolValue] || [self.phoneNumberTextField.text isEqualToString:@""]) {
             self.phoneNumberTextField.superview.backgroundColor = [UIColor clearColor];
         }
         else {
             self.phoneNumberTextField.superview.backgroundColor = RGB(250, 227, 228);
         }
    }];
    
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
         if ([x boolValue] || [self.confirmPwdTextField.text isEqualToString:@""]) {
             self.confirmPwdTextField.superview.backgroundColor = [UIColor clearColor];
         }
         else {
             self.confirmPwdTextField.superview.backgroundColor = RGB(250, 227, 228);
         }
     }];
    
    // 验证码倒计时显示
    [self.viewModel.vCodeCommand.executionSignals
     subscribeNext:^(RACSignal* signal) {
        [[[signal dematerialize] deliverOnMainThread]
         subscribeError:^(NSError *error) {
             @strongify(self)
             [self.navigationController showErrorWithTitle:@"错误" andMessage:error.userInfo[@"msg"]];
         }
         completed:^ {
             __block NSInteger currentSeconds = 60;
             [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]
              subscribeNext:^(id x) {
                  @strongify(self)
                  NSString *btnText;
                  if (currentSeconds > 0) {
                      btnText = [NSString stringWithFormat:@"%d秒后重试", (int)currentSeconds];
                      currentSeconds = currentSeconds - 1;
                  }
                  else {
                      btnText = @"获取验证码";
                  }
                  
                  self.vCodeButton.titleLabel.text = btnText;
                  [self.vCodeButton setTitle:btnText forState:UIControlStateNormal];
              }];
         }];
    }];
    
    // 注册
    [self.viewModel.submitCommand.executionSignals
     subscribeNext:^(RACSignal* signal) {
         [[[signal dematerialize] deliverOnMainThread]
          subscribeError:^(NSError *error) {
              @strongify(self)
              [self.navigationController showErrorWithTitle:@"错误" andMessage:error.userInfo[@"msg"]];
          }];
     }];
    
    // 点击注册按钮后，取消文本输入框编辑状态
    [[self.viewModel.submitCommand.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [self.view endEditing:YES];
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
}


- (void)dealloc {
    NSLog(@"RegisterViewController dealloc");
}

@end
