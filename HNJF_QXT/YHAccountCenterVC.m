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
#import "YHColorDot.h"

@interface YHAccountCenterVC ()

@property (weak, nonatomic) IBOutlet UILabel    *totalBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *blockedBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *receivableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *totalIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel    *lastIncomeLabel;
@property (weak, nonatomic) IBOutlet YHColorDot *colorDot1;
@property (weak, nonatomic) IBOutlet YHColorDot *colorDot2;
@property (weak, nonatomic) IBOutlet YHColorDot *colorDot3;
@property (weak, nonatomic) IBOutlet UIButton   *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton   *withdrawButton;
@property (weak, nonatomic) IBOutlet UIButton   *settingButton;
@property (weak, nonatomic) IBOutlet YHPercentCircleView *percentCircle;
@property (nonatomic, strong) YHAccountCenterVM   *viewModel;

@end

@implementation YHAccountCenterVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.colorDot1 updateWithColor:circle_percent_color_1];
    [self.colorDot2 updateWithColor:circle_percent_color_2];
    [self.colorDot3 updateWithColor:circle_percent_color_3];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.totalBalanceLabel, text)      = RACObserve(self.viewModel, totalBalance);
    RAC(self.availableBalanceLabel, text)  = RACObserve(self.viewModel, availableBalance);
    RAC(self.blockedBalanceLabel, text)    = RACObserve(self.viewModel, blockedBalance);
    RAC(self.receivableBalanceLabel, text) = RACObserve(self.viewModel, receivableBalance);
    RAC(self.totalIncomeLabel, text)       = RACObserve(self.viewModel, totalIncome);
    RAC(self.lastIncomeLabel, text)        = RACObserve(self.viewModel, lastIncome);
    
    self.rechargeButton.rac_command = self.viewModel.rechargeCommand;
    self.withdrawButton.rac_command = self.viewModel.withdrawCommand;
    self.settingButton.rac_command  = self.viewModel.settingCommand;
    
    @weakify(self)
    [[RACSignal zip:@[RACObserve(self.viewModel, availableRate),
                      RACObserve(self.viewModel, blockedRate),
                      RACObserve(self.viewModel, receivableRate)]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.percentCircle setPercentNumberArray:@[tuple.first, tuple.second, tuple.third]
                                        colorArray:@[circle_percent_color_1,
                                                     circle_percent_color_2,
                                                     circle_percent_color_3]
                                          animated:YES];
         [self.percentCircle startStrokePercentCircle];
     }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)]
     subscribeNext:^(id x) {
         [self.viewModel.updateAccountCommand execute:nil];
     }];
}

@end
