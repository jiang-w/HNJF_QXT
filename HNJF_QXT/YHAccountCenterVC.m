//
//  YHAccountCenterVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/6.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHAccountCenterVC.h"
#import "YHAccountCenterVM.h"
#import "YHPercentCircleView.h"

@interface YHAccountCenterVC ()

@property (weak, nonatomic) IBOutlet YHPercentCircleView *percentCircle;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (nonatomic, strong) YHAccountCenterVM *viewModel;

@end

@implementation YHAccountCenterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.percentCircle setPercentNumberArray:@[@(0.35), @(0.25), @(0.4)]
                                   colorArray:@[circle_percent_color_1,
                                                circle_percent_color_2,
                                                circle_percent_color_3]
                                     animated:YES];
    [self.percentCircle startPercentCircleAnimation];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.rechargeButton.rac_command = self.viewModel.rechargeCommand;
    self.withdrawButton.rac_command = self.viewModel.withdrawCommand;
    self.settingButton.rac_command = self.viewModel.settingCommand;
}

@end