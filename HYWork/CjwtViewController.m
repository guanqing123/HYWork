//
//  CjwtViewController.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "CjwtViewController.h"
#import "QuestionModel.h"
#import "CjwtManager.h"
#import "CjwtHeaderView.h"
#import "CjwtCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"

@interface CjwtViewController () <UISearchResultsUpdating,UISearchBarDelegate,CjwtHeaderViewDelegate>
@property (nonatomic, strong) UISearchController  *searchController;

@property (nonatomic, strong)  NSMutableArray *searchArray;
@property (nonatomic, strong)  NSMutableArray *modelArray;
@property (nonatomic, strong)  NSMutableArray *questionArray;
@property (strong, nonatomic) NSMutableArray *searchedModelArray;
@property (nonatomic, strong)  NSDictionary *dict;
@end

@implementation CjwtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupHeaderRefresh];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7f9ce3921fb0>)
    //[_searchController loadViewIfNeeded]; 9.0 这句话可以解决这个问题,但是要求 9.0
    _searchController.view.backgroundColor = [UIColor clearColor]; // 用这句话也可以解决
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"关键字搜索";
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;
    
    if(@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [_searchController.presentingViewController removeFromParentViewController];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)modelArray {
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)questionArray {
    if (_questionArray == nil) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}

- (NSMutableArray *)searchedModelArray {
    if (_searchedModelArray == nil) {
        _searchedModelArray = [NSMutableArray array];
    }
    return _searchedModelArray;
}

- (void)setupHeaderRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCjwtArray)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getCjwtArray {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    [CjwtManager getCjwtWithUrl:url success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            self.modelArray = [CjwtManager jsonArrayToModelArray:[json objectForKey:@"data"]];
            [self.questionArray removeAllObjects];
            for (QuestionModel *model in self.modelArray) {
                [self.questionArray addObject:model.question];
            }
            _dict = [[NSDictionary alloc] initWithObjects:self.modelArray forKeys:self.questionArray];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常,请下拉刷新"];
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchController.active) {
        return _searchArray.count;
    }else{
        return _modelArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        QuestionModel *model = [_searchedModelArray objectAtIndex:section];
        return model.isOpened ? 1 : 0;
    }else{
        QuestionModel *model = [_modelArray objectAtIndex:section];
        return model.isOpened ? 1 : 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CjwtCell *cell = [CjwtCell cellWithTableView:tableView];
    if (_searchController.active) {
        QuestionModel *model = [_searchedModelArray objectAtIndex:indexPath.section];
        cell.model = model;
    }else{
        QuestionModel *model = self.modelArray[indexPath.section];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CjwtHeaderView *header = [CjwtHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    if (_searchController.active) {
        QuestionModel *model = self.searchedModelArray[section];
        header.model = model;
    }else{
        QuestionModel *model = self.modelArray[section];
        header.model = model;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 345.0f;
}

#pragma mark - CjwtHeaderViewDelegate
- (void)headerViewDidClickedNameView:(CjwtHeaderView *)headerView {
    [self.tableView reloadData];
}

#pragma mark - searchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
    if (_searchArray != nil) {
        [_searchArray removeAllObjects];
    }
    if (self.searchedModelArray.count > 0) {
        [self.searchedModelArray removeAllObjects];
    }
    _searchArray = [NSMutableArray arrayWithArray:[_questionArray filteredArrayUsingPredicate:predicate]];
    for (int i = 0; i < _searchArray.count; i++) {
        [self.searchedModelArray addObject:[_dict objectForKey:_searchArray[i]]];
    }
    [self.tableView reloadData];
}

@end
