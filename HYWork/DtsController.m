//
//  DtsController.m
//  HYWork
//
//  Created by information on 16/3/9.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtsController.h"
#import "DtViewCell.h"
#import "MJRefresh.h"

@interface DtsController ()<UISearchResultsUpdating,UISearchBarDelegate>
{
    int page;
    int totalPage;
}
@end

@implementation DtsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    [self setUp];
}

- (void)setUp {
    page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    
    //初始化左侧返回箭头
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    //初始化 tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0.0f, 0.0f, 0.0f);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    [self.view addSubview:_tableView];
    
    [self setupHeaderRefresh];
    
    //搜索条
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.view.backgroundColor = [UIColor clearColor];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"关键字搜索";
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;
}

#pragma mark -- MJRefresh
- (void)setupHeaderRefresh {
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing {
//    if (_isSearching) {
//        [self.tableView.mj_header endRefreshing];
//        return;
//    }else{
//        self.tableView.mj_header.hidden = NO;
//    }
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self getdataList];
    //});
}

- (void)getdataList {
    page = 1;
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *pageNumber = [NSString stringWithFormat:@"%d",page];
    RequestData *requestData = [RequestData requestWithDataNeedPaginate:@"true" pageNumber:pageNumber pageSize:@"10"];
    [DtManager postJSONWithUrl:url RequestData:requestData success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        NSArray *array = [ModelList getModelList:dict].dataArray;
        if (array.count > 0) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:array];
        }
        page ++;
        [self setupFooterRefresh];
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupFooterRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
//    if (_isSearching) {
//        [self.tableView.mj_footer endRefreshing];
//        return;
//    }else{
//        self.tableView.mj_footer.hidden = NO;
//    }
//    if (page > totalPage) {
//        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        return;
//    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getModelList];
        // (最好在刷新表格后调用)调用endRefreshing 可以结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        // 刷新表格
//    });
}

- (void)getModelList {
    if (page > totalPage) {
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *pageNumber = [NSString stringWithFormat:@"%d",page];
    RequestData *requestData = [RequestData requestWithDataNeedPaginate:@"true" pageNumber:pageNumber pageSize:@"10"];
    [DtManager postJSONWithUrl:url RequestData:requestData success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        NSArray *arry = [ModelList getModelList:dict].dataArray;
        if (arry.count > 0) {
            [_dataArray addObjectsFromArray:arry];
        }
        [self.tableView reloadData];

        totalPage = [[dict objectForKey:@"totalPage"] intValue];
        page ++;
        if (page > totalPage) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^{
        
    }];
}

#pragma mark - Nav leftBarButtonItem
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        return _searchArray.count;
    }else{
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DtViewCell *dtCell = [DtViewCell cellWithTableView:tableView];
    if (_searchController.active) {
        DtCellModel *model = [_resultArray objectAtIndex:indexPath.row];
        
        [dtCell setDtCellModel:model];
    }else{
        DtCellModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        [dtCell setDtCellModel:model];
    }
    
    return dtCell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchController.active) {
        DtCellModel *model = [_resultArray objectAtIndex:indexPath.row];
        if (_dtDetailController != nil) {
            _dtDetailController = nil;
        }
        if (_dtDetailController == nil) {
            _dtDetailController = [[DtDetailController alloc] initWithTitle:model.title time:model.time content:model.content imgeUrl:model.imgUrl idStr:model.idStr];
            _dtDetailController.view.backgroundColor = [UIColor whiteColor];
        }
        [self.navigationController pushViewController:_dtDetailController animated:YES];
    }else{
        DtCellModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (_dtDetailController != nil) {
            _dtDetailController = nil;
        }
        if (_dtDetailController == nil) {
            _dtDetailController = [[DtDetailController alloc] initWithTitle:model.title time:model.time content:model.content imgeUrl:model.imgUrl idStr:model.idStr];
            _dtDetailController.view.backgroundColor = [UIColor whiteColor];
        }
        [self.navigationController pushViewController:_dtDetailController animated:YES];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (_resultArray) {
        [_resultArray removeAllObjects];
        _resultArray = nil;
    }
    _resultArray = [[NSMutableArray alloc] init];
    if (_beSearchArrar) {
        [_beSearchArrar removeAllObjects];
        _beSearchArrar = nil;
    }
    _beSearchArrar = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; i++) {
        DtCellModel *model = [_dataArray objectAtIndex:i];
        [_beSearchArrar addObject:model.title];
        [dict setObject:model forKey:model.title];
    }
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
    if (_searchArray != nil) {
        [_searchArray removeAllObjects];
    }
    _searchArray = [NSMutableArray arrayWithArray:[_beSearchArrar filteredArrayUsingPredicate:predicate]];
    for (int i = 0; i < _searchArray.count; i++) {
        NSString *result = [_searchArray objectAtIndex:i];
        [_resultArray addObject:[dict objectForKey:result]];
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isSearching = YES;
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = NO;
    _isSearching = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
