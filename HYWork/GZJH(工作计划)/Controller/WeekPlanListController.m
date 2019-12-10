//
//  WeekPlanListController.m
//  HYWork
//
//  Created by information on 16/6/2.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanListController.h"
#import "WeekPlanListFooterView.h"
#import "MJRefresh.h"
#import "LoadViewController.h"
#import "GzjhManager.h"
#import "Utils.h"
#import "SJLD.h"
#import "WeekPlan.h"
#import "WeekPlanListCell.h"
#import "WeekPlanDetailController.h"

@interface WeekPlanListController()<UITableViewDataSource,UITableViewDelegate,WeekPlanListFooterViewDelegate>

@property (nonatomic, strong)  NSArray *weekList;

@property (nonatomic, weak) UITableView  *tableView;

@end

@implementation WeekPlanListController

- (instancetype)initWithLb:(NSString *)lb beginDate:(NSString *)beginDate endDate:(NSString *)endDate {
    if (self = [super init]) {
        _lb = lb;
        _beginDate = [beginDate copy];
        _endDate = [endDate copy];
        _beginSDate = [beginDate copy];
        _endSDate = [endDate copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0.初始化导航栏
    [self initNavigation];
    
    // 1.初始化tableView
    [self initTableView];
    
    // 2.初始化footerView
    [self initFooterView];
}

#pragma mark - 初始化导航栏
- (void)initNavigation {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45.0f);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0,*)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);
        tableView.scrollIndicatorInsets = tableView.contentInset;
    }
    
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [tableView.mj_header beginRefreshing];
    
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - 初始化footerView
- (void)initFooterView {
    WeekPlanListFooterView  *footerView = [WeekPlanListFooterView footerView];
    footerView.frame = CGRectMake(0, SCREEN_HEIGHT - 45.0f, SCREEN_WIDTH, 45.0f);
    footerView.beginDate = self.beginSDate;
    footerView.endDate = self.endSDate;
    footerView.delegate = self;
    [self.view addSubview:footerView];
}

#pragma mark - WeekPlanListFooterViewDelegate
- (void)weekPlanListFooterViewDidClickSureBtn:(WeekPlanListFooterView *)footerView {
    [self.tableView.mj_header beginRefreshing];
}

- (void)weekPlanListFooterViewDidClickDateBtn:(WeekPlanListFooterView *)footerView {
    _beginSDate = footerView.beginDate;
    _endSDate = footerView.endDate;
}

#pragma mark - 员工编码懒加载
- (NSString *)ygbm {
    if (_ygbm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygbm = loadVc.emp.ygbm;
    }
    return _ygbm;
}

- (NSString *)ygxm {
    if (_ygxm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygxm = loadVc.emp.ygxm;
    }
    return _ygxm;
}


#pragma mark - 下拉刷新方法
- (void)headerRefreshing {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cbr"] = self.ygbm;
    params[@"xz"] = @"1";
    params[@"lb"] = self.lb;
    params[@"kssj"] = self.beginSDate;
    params[@"jssj"] = self.endSDate;
    [GzjhManager getWeekPlanListWithParams:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            self.weekList = [GzjhManager weekListToModel:[data objectForKey:@"list"]];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - tableView dataSourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weekList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获取cell
    WeekPlanListCell *cell = [WeekPlanListCell cellWithTableView:tableView];
    
    // 2.给cell赋值
    WeekPlan *weekPlan = self.weekList[indexPath.row];
    cell.weekPlan = weekPlan;
    
    // 3.返回cell
    return cell;
}

#pragma mark - tableView delegat
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WeekPlanListCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekPlan *weekPlan = self.weekList[indexPath.row];
    weekPlan.zjhxh = weekPlan.xh;
    weekPlan.xh = @"";
    weekPlan.zbxh = @"";
    weekPlan.state = @"0";
    weekPlan.fbr = self.ygbm;
    weekPlan.n_fbr = self.ygxm;
    weekPlan.cbr = self.ygbm;
    weekPlan.n_cbr = self.ygxm;
    weekPlan.xbr = @"";
    weekPlan.n_xbr = @"";
    weekPlan.yjwc = self.endDate;
    if([weekPlan.jhlb isKindOfClass:[NSNull class]]){
        weekPlan.jhlb = @"1";
    }
    for (SJLD *sjld in self.sjld) {
        if ([sjld.mr isEqualToString:@"1"]) {
            weekPlan.dfld = sjld.ygbm;
            weekPlan.n_dfld = sjld.ygxm;
            break;
        }
    }
    WeekPlanDetailController *detailVc = [[WeekPlanDetailController alloc] initWithWeekPlan:weekPlan beginDate:self.beginDate currentYgbm:self.ygbm];
    detailVc.sjld = self.sjld;
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
