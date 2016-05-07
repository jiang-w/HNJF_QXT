//
//  YHValidPhoneNumberVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHValidPhoneNumberVC.h"
#import "YHValidPhoneNumberVM.h"

@interface YHValidPhoneNumberVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *validCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton    *vCodeButton;
@property (weak, nonatomic) IBOutlet UIButton    *nextStepButton;
@property (nonatomic, strong) YHValidPhoneNumberVM *viewModel;

@end

@implementation YHValidPhoneNumberVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, phoneNumber) = self.phoneNumberTextField.rac_textSignal;
    RAC(self.viewModel, vCode)       = self.validCodeTextField.rac_textSignal;
    self.vCodeButton.rac_command     = self.viewModel.vCodeCommand;
    self.nextStepButton.rac_command  = self.viewModel.submitCommand;
    
    @weakify(self)
    // 根据按钮可用状态，改变背景色
    [RACObserve(self.nextStepButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            self.nextStepButton.backgroundColor = button_bg_color_1;
        }
        else {
            self.nextStepButton.backgroundColor = button_bg_color_2;
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

    // 显示错误信息
    [self.viewModel.submitCommand.errors
     subscribeNext:^(NSError *error) {
         [self.navigationController showErrorWithTitle:@"失败" andMessage:error.userInfo[@"msg"]];
     }];
    
    // 点击注册按钮后，取消文本输入框编辑状态
    [[self.viewModel.submitCommand.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [self.view endEditing:YES];
    }];
}

@end
