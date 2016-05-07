//
//  YHFundProductListVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHFundProductListVC.h"
#import "YHFundProductTableCell.h"
#import "YHFundProductListVM.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHFundProductListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YHFundProductListVM *viewModel;

@end

@implementation YHFundProductListVC

@dynamic viewModel;

static NSString *fundIdentifier = @"FundProductCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)bindViewModel {
    [super bindViewModel];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHFundProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:fundIdentifier forIndexPath:indexPath];
    YHFundCellViewModel *cellViewModel = [self.viewModel cellViewModelWithIndexPath:indexPath];
    [cell configureCellWithViewModel:cellViewModel];
    return cell;
}


#pragma mark - Property

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        _tableView.showsVerticalScrollIndicator = NO;
        
        UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:2801/article/1603140789877376-89504E47/view.html", PRODUCT_SERVER_URL]]];
        _tableView.tableHeaderView = head;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"YHFundProductTableCell" bundle:nil] forCellReuseIdentifier:fundIdentifier];
    }
    return _tableView;
}

@end
