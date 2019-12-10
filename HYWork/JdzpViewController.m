//
//  JdzpViewController.m
//  HYWork
//
//  Created by information on 16/6/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "JdzpViewController.h"
#import "MJRefresh.h"
#import "JdzpManager.h"
#import "JdzpModel.h"
#import "JdzpView.h"
#import "JdzpDetailViewController.h"

#define BUTTONWIDTH  self.view.frame.size.width / 3
#define BUTTONX self.view.frame.size.width / 16

@interface JdzpViewController ()
{
    int page;
    int totalPage;
}
@property (nonatomic, strong)  NSMutableArray *dataArray;
@end

@implementation JdzpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 0;
    _dataArray = [NSMutableArray array];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
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
    [JdzpManager postJSONWithUrl:url need_paginate:@"true" page_number:pageNumber page_size:@"20" success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [JdzpManager jdzpWithDict:dict];
            if (array.count > 0) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
            }
            totalPage = [[dict objectForKey:@"totalPage"] intValue];
            page = page + 1;
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
    [JdzpManager postJSONWithUrl:url need_paginate:@"true" page_number:pageNumber page_size:@"20" success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]]) {
            NSArray *array = [JdzpManager jdzpWithDict:dict];
            if (array.count > 0) {
                [_dataArray addObjectsFromArray:array];
            }
            page = page + 1;
            if (page > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (_dataArray.count / 3 + 1) * (BUTTONWIDTH / 3.0 * 2 + 40.0f);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    for (int i = 0; i < _dataArray.count; i++)
    {
        JdzpModel  *model = [_dataArray objectAtIndex:i];
        
        JdzpView *jdzpView = [[JdzpView alloc] initWithFrame:CGRectMake(BUTTONWIDTH * (i % 3), 10.0f + (BUTTONWIDTH / 3.0 * 2 + 40.0f) * (i / 3 ), BUTTONWIDTH, BUTTONWIDTH / 3.0 * 2 + 30.0f)];
        [jdzpView createView:model.imageUrl titleStr:model.title];
        jdzpView.tag = i;
        [cell addSubview:jdzpView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
        [jdzpView addGestureRecognizer:tapGesture];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tapItem:(UITapGestureRecognizer *)recognizer {
    JdzpView *jdzpView = (JdzpView *)recognizer.view;
    NSInteger i = jdzpView.tag;
    JdzpModel *model = [_dataArray objectAtIndex:i];
    JdzpDetailViewController *detailVc = [[JdzpDetailViewController alloc] initWithUrl:model.path];
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
