//
//  RjhBpcSearchViewController.m
//  HYWork
//
//  Created by information on 2017/6/6.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhBpcSearchViewController.h"
#import "BpcSearchTableCell.h"
#import "BpcSearchHeaderView.h"
#import "RjhBPC.h"
#import "RjhManager.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "Utils.h"
#import "MJExtension.h"


@interface RjhBpcSearchViewController () <UITableViewDataSource,UITableViewDelegate,BpcHistoryCheckViewDelegate>

@property (nonatomic, assign) BOOL isAppeared;

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, assign) int page_number;

@property (nonatomic, assign) int page_size;

@property (nonatomic, strong)  NSMutableArray *bpcArray;
@end

@implementation RjhBpcSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏的内容
    [self setupNavBar];
    
    // 2.设置tableView
    [self setupTableView];
    
    // 2.初始化historyView
    [self setupHistoryView];
}

#pragma mark - 设置导航栏的内容
- (void)setupNavBar {
    // 标题 & tableView后划线不显示
    self.navigationItem.title = @"搜索客户";
    
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"]
            style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanxuan"]
            style:UIBarButtonItemStyleDone target:self action:@selector(shanxuan)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shanxuan {
    if (!_isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
            _historyView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            _historyView.frame = CGRectMake(0, HWTopNavH - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
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
    
    // 分页条件
    _page_size = 20;
    _page_number = 1;
}

- (void)headerRefreshing {
    _page_number = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_size"] = @(self.page_size);
    params[@"page_number"] = @(self.page_number);
    params[@"khdm"] = self.bpc.khdm;
    params[@"khmc"] = self.bpc.khmc;
    [RjhManager getBpcListWithParameters:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            [self.bpcArray removeAllObjects];
            NSArray *tempArray = [RjhBPC mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            [self.bpcArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
            int totalPage = [[data objectForKey:@"totalPage"] intValue];
            if (totalPage > 1) {
                [self setupFooterRefresh];
            }
            _page_number ++;
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"获取客户列表失败"];
    }];
}

- (void)setupFooterRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)footerRefreshing {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_size"] = @(self.page_size);
    params[@"page_number"] = @(self.page_number);
    params[@"khdm"] = self.bpc.khdm;
    params[@"khmc"] = self.bpc.khmc;
    [RjhManager getBpcListWithParameters:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            NSArray *tempArray = [RjhBPC mj_objectArrayWithKeyValuesArray:[data objectForKey:@"list"]];
            [self.bpcArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
            int totalPage = [[data objectForKey:@"totalPage"] intValue];
            _page_number ++;
            if (_page_number > totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } fail:^{
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"获取客户列表失败"];
    }];
}

#pragma mark - bpcArray 懒加载
- (NSMutableArray *)bpcArray {
    if (_bpcArray == nil) {
        _bpcArray = [NSMutableArray array];
    }
    return _bpcArray;
}

#pragma mark - bpc 懒加载
- (RjhBPC *)bpc {
    if (_bpc == nil) {
        _bpc = [[RjhBPC alloc] init];
    }
    return _bpc;
}

#pragma mark - 初始化historyView
/** 初始化historyView */
- (void)setupHistoryView {
    if (_historyView == nil) {
        _historyView = [[BpcHistoryCheckView alloc] initWithFrame:CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH)];
        _historyView.delegate = self;
        _isAppeared = YES;
        [self.view addSubview:_historyView];
    }
}

#pragma mark - BpcHistoryCheckViewDelegate
- (void)historyCheckViewDidSearchBpcByCondition:(BpcHistoryCheckView *)historyCheckView {
    [self shanxuan];
    self.bpc.khdm = historyCheckView.conditionBpc.khdm;
    self.bpc.khmc = historyCheckView.conditionBpc.khmc;
    [self.tableView.mj_header beginRefreshing];
}

- (void)historyCheckViewDidSelectHistoryTableCell:(BpcHistoryCheckView *)historyCheckView {
    self.bpc.khdm = historyCheckView.conditionBpc.khdm;
    self.bpc.khmc = historyCheckView.conditionBpc.khmc;
    if ([self.delegate respondsToSelector:@selector(rjhBpcSearchViewControllerDidSelectBpc:)]) {
        [self.delegate rjhBpcSearchViewControllerDidSelectBpc:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    return self.bpcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BpcSearchTableCell *cell = [BpcSearchTableCell cellWithTableView:tableView];
    RjhBPC *bpc = self.bpcArray[indexPath.row];
    cell.bpc = bpc;
    return cell;
}

#pragma mark - tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BpcSearchHeaderView *headerView = [BpcSearchHeaderView headerView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RjhBPC *selectBpc = self.bpcArray[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"rjhBpc"];
    if ([data isKindOfClass:[NSNull class]] || !data) {
        NSMutableArray *historyArray = [NSMutableArray array];
        selectBpc.bpcId = 1;
        [historyArray addObject:selectBpc];
        NSData *historyArrayData = [NSKeyedArchiver archivedDataWithRootObject:historyArray];
        [defaults setObject:historyArrayData forKey:@"rjhBpc"];
        [defaults synchronize];
    }else{
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        BOOL flag = true;
        for (RjhBPC *b in array) {
            if ([b.khdm isEqualToString:selectBpc.khdm]) {
                flag = false;
                break;
            }
        }
        if (flag) {
            if ([array count] == 10) {
                [array removeObjectAtIndex:0];
            }
            for (RjhBPC *b in array) {
                b.bpcId = b.bpcId + 1;
            }
            selectBpc.bpcId = 1;
            [array addObject:selectBpc];
        }
        NSData *historyArrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
        [defaults setObject:historyArrayData forKey:@"rjhBpc"];
        [defaults synchronize];
    }
    self.bpc.khdm = selectBpc.khdm;
    self.bpc.khmc = selectBpc.khmc;
    if ([self.delegate respondsToSelector:@selector(rjhBpcSearchViewControllerDidSelectBpc:)]) {
        [self.delegate rjhBpcSearchViewControllerDidSelectBpc:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
