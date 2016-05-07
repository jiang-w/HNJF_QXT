//
//  YHHighMarginProductListVC.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/21.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHHighMarginProductListVC.h"
#import "YHHighMarginProductListVM.h"
#import "YHHighMarginProductCell.h"
#import "YHHighMarginProductCellVM.h"
#import "YHSegmentedView.h"
#import "YHSectionHeaderView.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHHighMarginProductListVC () <UITableViewDelegate, UITableViewDataSource, YHSegmentedViewDelegate>

@property (nonatomic, strong) YHHighMarginProductListVM *viewModel;
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) UIView          *tableHeaderView;
@property (nonatomic, strong) YHSegmentedView *segmentedView;

@end

@implementation YHHighMarginProductListVC

@dynamic viewModel;

static NSString *headerIdentifier = @"SectionHeader";
static NSString *cellIdentifier   = @"highMarginTableCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
        make.top.equalTo(self.view).offset(64);
    }];
    
    // 刷新数据
    @weakify(self)
    [[RACSignal
      merge:@[[self rac_signalForSelector:@selector(dropDownRefreshTableViewEvent)],
              [self rac_signalForSelector:@selector(bindViewModel)],
              [self rac_signalForSelector:@selector(segmentedView:didChangedIndex:)
                             fromProtocol:@protocol(YHSegmentedViewDelegate)]
              ]] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.selectTabIndex = self.segmentedView.selectedIndex;
        [self.viewModel.refreshDataCommand execute:nil];
    }];
}

- (void)bindViewModel {
    [super bindViewModel];

    @weakify(self)
    [[self.viewModel.refreshDataCommand executionSignals]
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

    [self.viewModel.refreshDataCommand.executing
     subscribeNext:^(id value) {
         @strongify(self)
         if (![value boolValue]) {
             [self.tableView.mj_header endRefreshing];
         }
     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.products.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = [self.viewModel.products objectAtIndex:section];
    NSArray *products = [[dict allValues] firstObject];
    return products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHHighMarginProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    YHHighMarginProductCellVM *cellViewModel = [self.viewModel cellViewModelWithIndexPath:indexPath];
    [cell configureCellWithViewModel:cellViewModel];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel showProductDetailAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YHSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    NSDictionary *dict = [self.viewModel.products objectAtIndex:section];
    NSString *sectionKey = [[dict allKeys] firstObject];
    
    if ([sectionKey isEqualToString:@"list"]) {
        [header setTitle:@"短期高收益理财 — 1-3个月"];
    }
    if ([sectionKey isEqualToString:@"listThreeMoth"]) {
        [header setTitle:@"短期高收益理财 — 3个月"];
    }
    if ([sectionKey isEqualToString:@"listSixMonth"]) {
        [header setTitle:@"短期高收益理财 — 6个月"];
    }
    return header;
}


#pragma mark - Hook

- (void)dropDownRefreshTableViewEvent {}


#pragma mark - Property

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefreshTableViewEvent)];
        
        [_tableView registerClass:[YHSectionHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YHHighMarginProductCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        UIImageView *img = [[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:2801/article/1603141799799152-89504E47/view.html", PRODUCT_SERVER_URL]]];
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        [_tableHeaderView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_tableHeaderView);
            make.height.mas_offset(150);
        }];
        
        [_tableHeaderView addSubview:self.segmentedView];
        [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableHeaderView);
            make.top.equalTo(img.mas_bottom);
            make.height.mas_equalTo(40);
        }];
    }
    return _tableHeaderView;
}


#pragma mark - Property

- (YHSegmentedView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [[YHSegmentedView alloc] init];
        [_segmentedView setItemTitles:@[@"高收益理财", @"转让专区"]];
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}


//- (void)dealloc {
//    NSLog(@"YHHighMarginProductListVC dealloc");
//}

@end
