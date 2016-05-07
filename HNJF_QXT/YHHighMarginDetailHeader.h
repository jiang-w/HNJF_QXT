//
//  YHHighMarginDetailHeader.h
//  HNJF_QXT
//
//  Created by 江伟 on 16/5/1.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHHighMarginDetailHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *expectedRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *closedPeriod;
@property (weak, nonatomic) IBOutlet UILabel *lowestAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, assign) double saleScale;

@end
