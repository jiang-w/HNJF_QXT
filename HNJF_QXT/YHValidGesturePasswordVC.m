//
//  YHValidGesturePasswordVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/12.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHValidGesturePasswordVC.h"
#import "YHValidGesturePasswordVM.h"
#import "YHLoginVM.h"

@interface YHValidGesturePasswordVC ()

@property (weak, nonatomic) IBOutlet KKGestureLockView *gestureLockView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginAgainButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) YHValidGesturePasswordVM *viewModel;

@end

@implementation YHValidGesturePasswordVC

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
    [[RACObserve(self.viewModel, trialTimes) skip:1]
     subscribeNext:^(id x) {
         @strongify(self)
         self.infoLabel.text = [NSString stringWithFormat:@"密码不正确，还可以尝试%@次", x];
     }];
    
    [[RACSignal merge:@[[self.forgetPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside],
                        [self.loginAgainButton rac_signalForControlEvents:UIControlEventTouchUpInside]
                        ]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel dismissViewModelAnimated:NO completion:nil];
         [self.viewModel presentViewModel:[[YHLoginVM alloc] init] animated:YES completion:nil];
     }];
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode {
    [self.viewModel.validGesturePasswordCommand execute:passcode];
}

@end
