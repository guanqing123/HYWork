//
//  XpssViewController.m
//  HYWork
//  新品上市
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "XpssViewController.h"
#import "MJRefresh.h"
#import "XpssManager.h"
#import "XpssCell.h"
#import "XpssModel.h"
#import "DtDetailController.h"

@interface XpssViewController ()
{
    int page;
    int totalPage;
}
@property (nonatomic, strong)  DtDetailController *detailVc;
@end

@implementation XpssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 0;
    
    _dataArry = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- MJRefresh
- (void)setupHeaderRefresh {
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing {
    page = 1;
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *pageNumber = [NSString stringWithFormat:@"%d", page];
    [XpssManager postJSONWithUrl:url loginName:@"" typeStr:@"" need_paginate:@"true" page_number:pageNumber page_size:@"20" cpdmStr:@"" success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [XpssManager xpssWithDict:dict];
            if (array.count > 0) {
                [_dataArry removeAllObjects];
                [_dataArry addObjectsFromArray:array];
            }
            page ++;
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
    NSString *pageNumber = [NSString stringWithFormat:@"%d", page];
    [XpssManager postJSONWithUrl:url loginName:@"" typeStr:@"" need_paginate:@"true" page_number:pageNumber page_size:@"20" cpdmStr:@"" success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [XpssManager xpssWithDict:dict];
            if (array.count > 0) {
                [_dataArry addObjectsFromArray:array];
            }
            page = page + 1;
            if (page > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    } fail:^{
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XpssCell *cell = [XpssCell cellWithTableView:tableView];
    
    XpssModel *model = self.dataArry[indexPath.row];
    cell.xpssModel = model;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XpssModel *model = [self.dataArry objectAtIndex:indexPath.row];
    _detailVc = [[DtDetailController alloc] initWithTitle:model.title time:model.submit_date content:model.content imgeUrl:model.imgUrl idStr:@"0"];
    _detailVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:_detailVc animated:YES];
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
