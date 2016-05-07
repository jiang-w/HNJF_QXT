//
//  YHModifyLoginPwdViewController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/16.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHModifyLoginPwdViewController.h"
#import "YHModifyLoginPwdViewModel.h"

@interface YHModifyLoginPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *replacePwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) YHModifyLoginPwdViewModel *viewModel;

@end

@implementation YHModifyLoginPwdViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, oldPassword) = self.oldPwdTextField.rac_textSignal;
    RAC(self.viewModel, replacePassword) = self.replacePwdTextField.rac_textSignal;
    RAC(self.viewModel, confirmPassword) = self.confirmPwdTextField.rac_textSignal;
    self.submitButton.rac_command = self.viewModel.changePwdCommand;
    
    @weakify(self)
    // 显示更改密码中
    [[self.viewModel.changePwdCommand.executing skip:1]
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText = @"正在更改密码...";
         }
         else {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
}

@end
