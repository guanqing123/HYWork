//
//  KhhfViewController.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "KhhfViewController.h"
#import "WKkhdcViewController.h"

#import "WKKhhfTool.h"

#import "KhhfSearchView.h"
#import "KhhfHeaderFooterView.h"
#import "KhhfTableViewCell.h"
#import "WKChooseAddressView.h"
#import "WKClassifyChooseView.h"

#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "LoadViewController.h"

@interface KhhfViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isAppeared;

@property (nonatomic, weak)  UITableView *tableView;
@property (nonatomic, strong)  KhhfSearchView *searchView;

@property (nonatomic, assign) int page_number;

@property (nonatomic, assign) int page_size;

@property (nonatomic, strong)  NSMutableArray *khhfArray;

@property (nonatomic, strong)  WKKhhfTableParam *tableParam;

@property (nonatomic, strong)  UIView *coverView;
@property (nonatomic, strong)  WKChooseAddressView *chooseAddressView;
@property (nonatomic, strong)  WKClassifyChooseView *chooseClassifyView;

@end

@implementation KhhfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavBar];
    
    [self setupTableView];
    
    [self setupSearchConditionView];
}

#pragma mark - 设置导航栏的内容
- (void)setupNavBar {
    // 标题 & tableView后划线不显示
    self.navigationItem.title = @"客户回访";
    
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanxuan"] style:UIBarButtonItemStyleDone target:self action:@selector(shanxuan)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shanxuan {
    if (!_isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
            _searchView.alpha = 1.0;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            _searchView.alpha = 0;
        }];
    }
    _isAppeared = !_isAppeared;
}

#pragma mark - 设置tableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 36.0f;
    tableView.showsVerticalScrollIndicator = NO;
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);//iPhoneX这里是88
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    // 分页条件
    _page_size = 20;
    _page_number = 1;
}

- (WKKhhfTableParam *)tableParam {
    if (!_tableParam) {
        _tableParam = [WKKhhfTableParam param:khhf];
    }
    return _tableParam;
}

- (void)headerRefreshing {
    self.tableParam.pageNumber = 1;
    self.tableParam.pageSize = 20;
    self.tableParam.ygbm = [LoadViewController shareInstance].emp.ygbm;
    [WKKhhfTool getKhhfList:self.tableParam success:^(WKKhhfTableResult *result) {
        if (result.error) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:result.errorMsg toView:self.view];
        }else{
            [self.khhfArray removeAllObjects];
            [self.khhfArray addObjectsFromArray:result.list];
            if (result.totalPage > 1) {
                self.tableParam.pageNumber ++;
                [self setupFooterRefreshing];
            }else{
                self.tableView.mj_footer = nil;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常" toView:self.view];
    }];
}

- (NSMutableArray *)khhfArray {
    if (!_khhfArray) {
        _khhfArray = [NSMutableArray array];
    }
    return _khhfArray;
}

- (void)setupFooterRefreshing {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
    [WKKhhfTool getKhhfList:self.tableParam success:^(WKKhhfTableResult *result) {
        if (result.error) {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:result.errorMsg toView:self.view];
        }else{
            [self.khhfArray addObjectsFromArray:result.list];
            [self.tableView reloadData];
            self.tableParam.pageNumber ++;
            NSInteger totalPage = result.totalPage;
            if (self.tableParam.pageNumber > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络异常" toView:self.view];
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.khhfArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KhhfTableViewCell *cell = [KhhfTableViewCell cellWithTableView:tableView];
    
    WKKhhf *kh = self.khhfArray[indexPath.row];
    cell.kh = kh;
    
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KhhfHeaderFooterView *headerFooterView = [KhhfHeaderFooterView sectionHeaderView:tableView];
    return headerFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKkhdcViewController *khdcVc = [[WKkhdcViewController alloc] init];
    
    WKKhhf *kh = self.khhfArray[indexPath.row];
    khdcVc.khdm = kh.khdm;
    khdcVc.zrxh = kh.zrxh;
    
    [self.navigationController pushViewController:khdcVc animated:YES];
}

#pragma mark - 初始化khSearchView
/** 初始化khSearchView */
- (void)setupSearchConditionView {
    if (_searchView == nil) {
        _searchView  = [KhhfSearchView searchView];
        _searchView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, 220);
        _searchView.tableParam = self.tableParam;
        _isAppeared = YES;
        WEAKSELF
        _searchView.searchBlock = ^{
            [weakSelf shanxuan];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        _searchView.districtBlock = ^{
            [weakSelf chooseAddress];
        };
        _searchView.classifyBlock = ^{
            [weakSelf chooseClassify];
        };
        [self.view addSubview:_searchView];
    }
}

- (void)chooseClassify {
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{} completion:^(BOOL finished) {
        weakSelf.coverView.hidden = NO;
        weakSelf.chooseClassifyView.hidden = NO;
    }];
}

- (void)chooseAddress {
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{} completion:^(BOOL finished) {
        weakSelf.coverView.hidden = NO;
        weakSelf.chooseAddressView.hidden = NO;
    }];
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_coverView addSubview:self.chooseAddressView];
        [_coverView addSubview:self.chooseClassifyView];
        [self.view addSubview:_coverView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
        [_coverView addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _coverView;
}

- (void)tapCover:(UITapGestureRecognizer *)tap {
    if (!_chooseAddressView.hidden) {
        if (_chooseAddressView.chooseFinish) {
            _chooseAddressView.chooseFinish();
        }
    }
    if (!_chooseClassifyView.hidden) {
        if(_chooseClassifyView.chooseFinish){
            _chooseClassifyView.chooseFinish();
        }
    }
}

// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (!_chooseAddressView.hidden) {
        if (CGRectContainsPoint(_chooseAddressView.frame, point)) {
            return NO;
        }
    }
    if (!_chooseClassifyView.hidden) {
        if (CGRectContainsPoint(_chooseClassifyView.frame, point)) {
            return NO;
        }
    }
    return YES;
}

- (WKChooseAddressView *)chooseAddressView {
    if (!_chooseAddressView) {
        WEAKSELF
        _chooseAddressView = [[WKChooseAddressView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 350, SCREEN_WIDTH, 350)];
        _chooseAddressView.hidden = YES;
        _chooseAddressView.chooseFinish = ^{
            weakSelf.searchView.districtField.text = weakSelf.chooseAddressView.address;
            weakSelf.tableParam.dq = weakSelf.chooseAddressView.code;
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.coverView.hidden = YES;
                weakSelf.chooseAddressView.hidden = YES;
            }];
        };
    }
    return _chooseAddressView;
}

- (WKClassifyChooseView *)chooseClassifyView {
    if(!_chooseClassifyView){
        WEAKSELF
        _chooseClassifyView = [[WKClassifyChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150)];
        _chooseClassifyView.hidden = YES;
        _chooseClassifyView.chooseFinish = ^{
            weakSelf.searchView.flField.text = weakSelf.chooseClassifyView.fl;
            weakSelf.tableParam.lb = weakSelf.chooseClassifyView.code;
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.coverView.hidden = YES;
                weakSelf.chooseClassifyView.hidden = YES;
            }];
        };
    }
    return _chooseClassifyView;
}

#pragma mark -屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
