//
//  QyryViewController.m
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//  企业荣誉

#import "QyryViewController.h"
#import "MJRefresh.h"
#import "GyhyManager.h"
#import "QyryModel.h"
#import "QyryCell.h"
#import "DtDetailController.h"

@interface QyryViewController ()
{
    int page;
    int totalPage;
}

@property (nonatomic, strong)  NSMutableArray *dataArray;
@end

@implementation QyryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业荣誉";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.rowHeight = 70.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);//iPhoneX这里是88
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    [self setupHeaderRefresh];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeaderRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing {
    page = 1;
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *pageNumber = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"need_paginate"] = @"true";
    params[@"page_number"] = pageNumber;
    params[@"page_size"] = @"10";
    [GyhyManager getQyryListWithUrl:url params:params success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [GyhyManager dictToQyryModelArray:dict];
            if (array) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
            }
            totalPage = [[dict objectForKey:@"totalPage"] intValue];
            page++;
            [self setupFooterRefresh];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupFooterRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
    if (page > totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *pageNumber = [NSString stringWithFormat:@"%d",page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"need_paginate"] = @"true";
    params[@"page_number"] = pageNumber;
    params[@"page_size"] = @"10";
    [GyhyManager getQyryListWithUrl:url params:params success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [GyhyManager dictToQyryModelArray:dict];
            if (array) {
                [_dataArray addObjectsFromArray:array];
            }
            [self.tableView reloadData];
            page++;
            totalPage = [[dict objectForKey:@"totalPage"] intValue];
            if (page > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } fail:^{
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QyryCell *cell = [QyryCell cellWithTableView:tableView];
    
    QyryModel *model = self.dataArray[indexPath.row];
    cell.qyryModel = model;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QyryModel *model = self.dataArray[indexPath.row];
    DtDetailController *detailVc = [[DtDetailController alloc] initWithTitle:model.title time:model.data content:model.content imgeUrl:nil idStr:@"0"];
    detailVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detailVc animated:YES];
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
