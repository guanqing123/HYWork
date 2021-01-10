//
//  WKSliderListViewController.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//
#define searchViewH 44.0f

#import "WKSliderListViewController.h"
// view
#import "WKSearchBar.h"
#import "WKSliderTableViewCell.h"
// tool
#import "MJRefresh.h"
#import "WKSliderTool.h"
// controllers
#import "WKSliderDetailViewController.h"

@interface WKSliderListViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
// 搜索条
@property (nonatomic, weak)  UIView *searchView;
// 搜索内容
@property (nonatomic, copy) NSString *searchText;
// tableView
@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong)  NSMutableArray *sliderList;

@end

@implementation WKSliderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置搜索框
    [self setupSearchBar];
    
    //2.初始化 UITableView
    [self setupTableView];
}

#pragma mark - 设置搜索框
- (void)setupSearchBar {
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, searchViewH);
    _searchView = searchView;
    [self.view addSubview:searchView];
    
    WKSearchBar *searchBar = [WKSearchBar searchBar];
    searchBar.placeholder = @"标题";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBar.layer.borderWidth = 0.2;
    searchBar.layer.cornerRadius = 4;
    searchBar.backgroundColor = GQColor(244, 244, 244);
    [searchView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(searchView).with.insets(UIEdgeInsetsMake(WKMargin*0.5, WKMargin, WKMargin*0.5, WKMargin));
    }];
    searchBar.delegate = self;
    [searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    searchBar.inputAccessoryView = [[UIView alloc] init];
    searchBar.returnKeyType = UIReturnKeySearch;
}

#pragma mark - 搜索框文本变化
- (void)textFieldDidChange:(UITextField *)textField {
    self.searchText = textField.text;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark - setupTableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = GQColor(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.tableView.mj_header beginRefreshing];
    self.pageNum = 1;
    self.pageSize = 10;
    // 电力
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        [[make leading] trailing].equalTo([self view]);

        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];

        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif

        [make top].equalTo(self.searchView.mas_bottom);
        [make bottom].equalTo(bottom);
    }];
}

- (void)headerRefreshing {
    _pageNum = 1;
    
    WKSliderListParam *sliderListParam = [[WKSliderListParam alloc] init];
    sliderListParam.isTop = 0;
    sliderListParam.limit = self.pageSize;
    sliderListParam.page  = self.pageNum;
    sliderListParam.title = self.searchText;
    
    [WKSliderTool getSliderList:sliderListParam success:^(WKSliderListResult * _Nonnull result) {
        if (result.code != 200) {
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:result.message];
        } else {
            [self.sliderList removeAllObjects];
            [self.sliderList addObjectsFromArray:result.data];
            int pages = (int)(result.code / self.pageNum);
            if (pages > 1) {
                _pageNum ++;
                [self setupFooterRefreshing];
            } else {
                self.tableView.mj_footer = nil;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败,稍后再试"];
    }];
}

- (void)setupFooterRefreshing {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
    WKSliderListParam *sliderListParam = [[WKSliderListParam alloc] init];
    sliderListParam.isTop = 0;
    sliderListParam.limit = self.pageSize;
    sliderListParam.page  = self.pageNum;
    sliderListParam.title = self.searchText;
    
    [WKSliderTool getSliderList:sliderListParam success:^(WKSliderListResult * _Nonnull result) {
        if (result.code != 200) {
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:result.message];
        } else {
            [self.sliderList addObjectsFromArray:result.data];
            [self.tableView reloadData];
            _pageNum ++;
            int pages = (int)(result.code / self.pageNum);
            if (_pageNum > pages) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败,稍后再试"];
    }];
}

#pragma mark -lazyLoad
- (NSMutableArray *)sliderList {
    if (!_sliderList) {
        _sliderList = [NSMutableArray array];
    }
    return _sliderList;
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sliderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSliderTableViewCell *sliderCell = [WKSliderTableViewCell cellWithTableView:tableView];
    WKSliderList *sliderList = [self.sliderList objectAtIndex:indexPath.row];
    sliderCell.sliderList = sliderList;
    return sliderCell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKSliderList *sliderList = [self.sliderList objectAtIndex:indexPath.row];
    WKSliderDetailViewController *sliderDetailVc = [[WKSliderDetailViewController alloc] initWithIdStr:sliderList.idStr];
    sliderDetailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sliderDetailVc animated:YES];
}

#pragma mark - 屏幕横竖屏设置
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
