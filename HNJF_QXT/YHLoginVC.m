//
//  YHLoginVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/3/28.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHLoginVC.h"
#import "YHLoginVM.h"

@interface YHLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;
@property (weak, nonatomic) IBOutlet UIButton    *registerButton;
@property (weak, nonatomic) IBOutlet UIButton    *resetPasswordButton;
@property (nonatomic, strong, readonly) YHLoginVM *viewModel;

@end

@implementation YHLoginVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"details_back"] style:UIBarButtonItemStyleDone target:self action:@selector(tapBackButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, username)        = self.userTextField.rac_textSignal;
    RAC(self.viewModel, password)        = self.pwdTextField.rac_textSignal;
    self.loginButton.rac_command         = self.viewModel.loginCommand;
    self.registerButton.rac_command      = self.viewModel.registerCommand;
    self.resetPasswordButton.rac_command = self.viewModel.resetPasswordCommand;
    
    [[[self.viewModel.loginCommand.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] merge:[self rac_signalForSelector:@selector(viewWillDisappear:)]]
     subscribeNext:^(id x) {
         [self.view endEditing:YES];
     }];

    @weakify(self)
    // 显示用户登录中
    [[self.viewModel.loginCommand.executing skip:1]
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在登录...";
         }
         else {
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }
     }];
    
    // 显示登录失败信息
    [self.viewModel.loginCommand.errors
     subscribeNext:^(NSError *error) {
         [self.navigationController showErrorWithTitle:@"登录失败" andMessage:error.userInfo[@"msg"]];
     }];
    
    // 根据按钮可用状态，改变背景色
    [RACObserve(self.loginButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            self.loginButton.backgroundColor = button_bg_color_1;
        }
        else {
            self.loginButton.backgroundColor = button_bg_color_2;
        }
    }];
}

- (void)tapBackButton:(UIBarButtonItem *)button {
    [self.viewModel dismissViewModelAnimated:YES completion:nil];
}


- (void)dealloc {
    NSLog(@"YHLoginViewController dealloc");
}

@end
