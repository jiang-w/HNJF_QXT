//
//  YHHomePageViewController.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/20.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHomePageViewController.h"
#import "YHHomePageViewModel.h"
#import "YHImageSlideView.h"
#import "YHSectionHeaderView.h"
#import "YHImageHeaderFooterView.h"
#import "YHOnceProductTableCell.h"
#import "YHFundProductTableCell.h"
#import "YHHighMarginProductCell.h"
#import <MJRefresh/MJRefresh.h>

@interface YHHomePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) YHImageSlideView *slideView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) YHHomePageViewModel *viewModel;

@end


@implementation YHHomePageViewController

@dynamic viewModel;

static NSString *headerIdentifier      = @"HomePageHeader";
static NSString *footerIdentifier      = @"ImageFooter";
static NSString *onceProductIdentifier = @"OnceProductCell";
static NSString *fundProductIdentifier = @"FundProductCell";
static NSString *highMarginIdentifier  = @"highMarginTableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
}

- (void)bindViewModel {
    [super bindViewModel];

    RAC(self.slideView, imgUrls) = RACObserve(self.viewModel, bannerUrls);
    
    @weakify(self)
    [[self.viewModel.refreshDataCommand.executing skip:1]
     subscribeNext:^(id x) {
         @strongify(self)
         if (![x boolValue]) {
             [self.tableView.mj_header endRefreshing];
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }
         else {
             [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"数据加载中...";
         }
     }];
    
    [self.viewModel.refreshDataCommand.executionSignals
     subscribeNext:^(RACSignal* signal) {
         [[[signal dematerialize] deliverOnMainThread]
          subscribeError:^(NSError *error) {
              @strongify(self)
              [self.navigationController showErrorWithTitle:@"错误" andMessage:error.userInfo[@"msg"]];
          }
          completed:^{
              @strongify(self)
              [self.tableView reloadData];
          }];
     }];
    
    [[self rac_signalForSelector:@selector(loadTableViewData)]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.refreshDataCommand execute:nil];
     }];
    
    [self.viewModel.refreshDataCommand execute:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = [self.viewModel sectionWithIndex:indexPath.section];
    NSDictionary *productDict = section[@"items"][indexPath.row];
    YHProductInfo *productInfo = [[YHProductInfo alloc] init];
    productInfo.name = productDict[@"name"];
    productInfo.totalAmount = [productDict[@"totalAmount"] doubleValue];
    productInfo.lowestAmount = [productDict[@"lowerAmount"] doubleValue];
    productInfo.mostAmount = [productDict[@"upperAmount"] doubleValue];
    productInfo.timeLimit = [productDict[@"dueDays"] intValue];
    productInfo.expectedRate = [productDict[@"expectedRate"] doubleValue];
    productInfo.saleScale = [productDict[@"saleScale"] doubleValue] / 100;
    
    if (indexPath.section == 0) {
        YHOnceProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:onceProductIdentifier forIndexPath:indexPath];
        [cell setCellWithProduct:productInfo];
        return cell;
    }
    else if (indexPath.section == 1) {
        YHFundProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:fundProductIdentifier forIndexPath:indexPath];
        return cell;
    }
    else {
        YHHighMarginProductCell *cell = [tableView dequeueReusableCellWithIdentifier:highMarginIdentifier forIndexPath:indexPath];
        YHHighMarginProductCellVM *cellViewModel = [[YHHighMarginProductCellVM alloc] initWithProduct:productInfo];
        [cell configureCellWithViewModel:cellViewModel];
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YHSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    if (section == 1) {
        [header setTitle:@"零钱宝"];
    }
    else {
        [header setTitle:@"高收益"];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 150;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        YHImageHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
        [footer setImageUrl:@"http://120.27.164.104:2801/article/1603141799799152-89504E47/view.html"];
        return footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = [self.viewModel sectionWithIndex:indexPath.section];
    NSDictionary *productDict = section[@"items"][indexPath.row];
    NSLog(@"%@", productDict);
}


#pragma mark - Hook

- (void)loadTableViewData {}


#pragma mark - Property

- (YHImageSlideView *)slideView {
    if (!_slideView) {
        _slideView = [[YHImageSlideView alloc]
                      initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _slideView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.slideView;
        
        /* 设置下拉刷新 */
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTableViewData)];
        /* 注册cell */
        [_tableView registerClass:[YHSectionHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentifier];
        [_tableView registerClass:[YHImageHeaderFooterView class] forHeaderFooterViewReuseIdentifier:footerIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YHOnceProductTableCell" bundle:nil] forCellReuseIdentifier:onceProductIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YHFundProductTableCell" bundle:nil] forCellReuseIdentifier:fundProductIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YHHighMarginProductCell" bundle:nil] forCellReuseIdentifier:highMarginIdentifier];
    }
    return _tableView;
}

- (void)dealloc {
    NSLog(@"YHHomePageViewController dealloc");
}

@end
