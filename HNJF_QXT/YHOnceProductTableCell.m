//
//  YHOnceProductTableCell.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHOnceProductTableCell.h"

@interface YHOnceProductTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectedRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowerAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueLimitLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBar;

@property (nonatomic, assign) float scacle;

@end

@implementation YHOnceProductTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.scacle = 0.1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithProduct:(YHProductInfo *)product {
    self.nameLabel.text = product.name == nil? @"—" : product.name;
    self.expectedRateLabel.text = [NSString stringWithFormat:@"%.2f", product.expectedRate];
    self.lowerAmountLabel.text = [NSString stringWithFormat:@"%.0f元起", product.lowestAmount];
    
    self.scacle = 0.7;
    
    self.progressBar.frame = CGRectMake(0, 0, 0, 5);
    
    [UIView animateWithDuration:3 animations:^{
        
        self.progressBar.frame = CGRectMake(0, 0, 70, 5);
    }];
}

- (void)dealloc {
    NSLog(@"YHOnceProductTableCell dealloc");
}

@end
