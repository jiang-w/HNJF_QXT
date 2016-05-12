//
//  YHRechargeVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/7.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHRechargeVC.h"
#import "YHRechargeVM.h"

@interface YHRechargeVC ()

@property (weak, nonatomic) IBOutlet UITextField *paymentTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic, copy) NSString *bankCardNumber;
@property (nonatomic, strong) YHRechargeVM *viewModel;

@end

@implementation YHRechargeVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, payAmount)        = self.paymentTextField.rac_textSignal;
    RAC(self.viewModel, payPassword)      = self.payPasswordTextField.rac_textSignal;
    RAC(self.viewModel, bankCardNumber)   = RACObserve(self, bankCardNumber);
    RAC(self.resultBalanceLabel, text)    = RACObserve(self.viewModel, resultBalance);
    RAC(self.availableBalanceLabel, text) = RACObserve(self.viewModel, availableBalance);
 
    self.payButton.rac_command = self.viewModel.payCommand;
    
    @weakify(self)
    // 根据按钮可用状态，改变背景色
    [self.viewModel.validPaySignal subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            self.payButton.backgroundColor = button_bg_color_1;
        }
        else {
            self.payButton.backgroundColor = button_bg_color_2;
        }
    }];
}

@end
