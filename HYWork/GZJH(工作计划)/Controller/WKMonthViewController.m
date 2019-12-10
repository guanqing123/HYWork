//
//  WKMonthViewController.m
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthViewController.h"
#import "WKMonthPlanDetailController.h"
#import "WKMonthPlanCheckController.h"
#import "WKFromMonthController.h"
#import "WeekHeaderView.h"
#import "WKMonthFooterView.h"
#import "WeekFooterView.h"
#import "LoadViewController.h"
#import "GzjhManager.h"
#import "Utils.h"
#import "MonthPlan.h"
#import "WKMonthPlanHeaderView.h"
#import "WKMonthPlanCell.h"
#import "MJRefresh.h"
#import "CustomActionSheet.h"
#import "MonthPlanDetailController.h"
#import "WeekPlanListController.h"
#import "SJLD.h"
#import "ZJXS.h"
#import "LYConstans.h"

@interface WKMonthViewController () <UITableViewDataSource,UITableViewDelegate,weekHeaderViewDelegate,weekFooterViewDelegate,CustomActionSheetDelagate,WKMonthFooterViewDelegate,WKMonthPlanHeaderViewDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *xzzj;

@property (nonatomic, copy) NSString *ygxm;

@property (nonatomic, copy) NSString *currentYgbm;

@property (nonatomic, copy) NSString *currentXzzj;

@property (nonatomic, strong)  NSArray *monthPlans;

@property (nonatomic, strong)  NSArray *wkMonthPlans;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, weak) WeekHeaderView  *headerView;

@property (nonatomic, weak) WKMonthFooterView  *footerView;

@property (nonatomic, assign, getter=isEdit) BOOL edit;

@property (nonatomic, assign, getter=isStateType) WeekPlanStateType stateType;

@property (nonatomic, strong)  NSMutableDictionary *chooseDict;

@end

@implementation WKMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 0.初始化tableView
    [self initTableView];
    
    // 1.初始化条件
    [self initHeaderView];
    
    // 2.初始化底部按钮
    [self initFooterView];
}

- (void)initHeaderView {
    WeekHeaderView *headerView = [WeekHeaderView headerView:CGRectMake(0, 0, SCREEN_WIDTH, 36.0f)];
    headerView.delegate = self;
    [headerView fillBeginAndEndDateWithPickDate:[NSDate date] gzjhPlanType:GzjhPlanTypeMonth];
    _headerView = headerView;
    [self.view addSubview:headerView];
    [self stopEditing];
}

- (void)stopEditing {
    _edit = false;
    self.headerView.edit = _edit;
}

- (void)initFooterView {
    WKMonthFooterView *footerView = [WKMonthFooterView footerView];
    footerView.frame = CGRectMake(0, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH - 45.0f, SCREEN_WIDTH, 45.0f);
    footerView.delegate = self;
    _footerView = footerView;
    [self footerState];
    [self.view addSubview:footerView];
}

- (void)footerState{
    if ([self.ygbm isEqualToString:self.currentYgbm]) {
        [self.footerView setLy:1];
    }else if (![self.ygbm isEqualToString:self.currentYgbm] && [self.currentXzzj intValue] > 2){
        [self.footerView setLy:2];
    }else{
        [self.footerView setLy:3];
    }
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36.0f, SCREEN_WIDTH, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH - 36.0f - 45.0f)];
    tableView.delegate = (id<UITableViewDelegate>)self;
    tableView.dataSource = (id<UITableViewDataSource>)self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置回调 (一旦进入刷新状态,就调用target的action,也就是调用self的headerRefreshing方法)
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kMonthPlanRefreshing) name:kMonthPlanRefreshing object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kZjxsCheckCellClick:) name:kZjxsCheckCellClick object:nil];
}

// 监听通知
- (void)kMonthPlanRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)kZjxsCheckCellClick:(NSNotification *)note {
    ZJXS *zjxs = note.userInfo[kZjxsCheckCellClick];
    _currentYgbm = zjxs.ygbm;
    _currentXzzj = zjxs.xzzj;
    [self footerState];
    [self.tableView.mj_header beginRefreshing];
}

/** 移除通知 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.currentXzzj intValue] > 2) {
        return self.wkMonthPlans.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.currentXzzj intValue] > 2) {
       WKMonthPlan *wkMonthPlan = self.wkMonthPlans[section];
        return !wkMonthPlan.extend ? wkMonthPlan.zson.count : 0;
    } else{
        return self.monthPlans.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.获取cell
    WKMonthPlanCell *cell = [WKMonthPlanCell cellWithTableView:tableView];
    
    // 2.给cell赋值模型
    if ([self.currentXzzj intValue] > 2) {
        WKMonthPlan *wkMonthPlan = self.wkMonthPlans[indexPath.section];
        cell.wkMonthPlan = wkMonthPlan.zson[indexPath.row];
    } else {
        MonthPlan *monthPlan = self.monthPlans[indexPath.row];
        cell.monthPlan = monthPlan;
    }
    
    // 3.返回cell
    return cell;
}

#pragma mark - WKMonthPlanHeaderViewDelegate
- (void)headerViewDidClickExpend:(WKMonthPlanHeaderView *)headerView {
    [self.tableView reloadData];
}

- (void)headerViewDidClickDetail:(WKMonthPlanHeaderView *)headerView {
    WKMonthPlan *monthPlan = headerView.monthPlan;
    if ([monthPlan.state intValue] >= 2) {
        WKMonthPlanCheckController *checkVc = [[WKMonthPlanCheckController alloc] initWithXh:monthPlan.xh owner:[self.ygbm isEqualToString:self.currentYgbm]];
        [self.navigationController pushViewController:checkVc animated:YES];
    } else {
        WKMonthPlanDetailController *detailVc = [[WKMonthPlanDetailController alloc] initWithXh:monthPlan.xh];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)headerViewDidClickAdd:(WKMonthPlanHeaderView *)headerView {
    WKMonthPlan *monthPlan = headerView.monthPlan;
    WKMonthPlanDetailController *detailVc = [[WKMonthPlanDetailController alloc] initWithXh:monthPlan.xh sonPlan:@"1"];
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - UITableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.currentXzzj intValue] > 2) {
        WKMonthPlanHeaderView *headerView = [WKMonthPlanHeaderView headerViewWithTableView:tableView];
        headerView.monthPlan = self.wkMonthPlans[section];
        headerView.delegate = self;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.currentXzzj intValue] > 2) {
        return [WKMonthPlanCell getCellHeight];
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.currentXzzj intValue] > 2) {
        return [WKMonthPlanCell getLdCellHeight];
    }
    return [WKMonthPlanCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentXzzj intValue] > 2) {
        WKMonthPlan *wkMonthPlan = self.wkMonthPlans[indexPath.section];
        WKMonthPlan *monthPlan = wkMonthPlan.zson[indexPath.row];
        if ([monthPlan.state intValue] >= 2) {
            WKMonthPlanCheckController *checkVc = [[WKMonthPlanCheckController alloc] initWithXh:monthPlan.xh owner:[self.ygbm isEqualToString:self.currentYgbm]];
            [self.navigationController pushViewController:checkVc animated:YES];
        } else {
            WKMonthPlanDetailController *detailVc = [[WKMonthPlanDetailController alloc] initWithXh:monthPlan.xh];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    } else {
        MonthPlan *monthPlan = self.monthPlans[indexPath.row];
        MonthPlanDetailController *detailVc = [[MonthPlanDetailController alloc] initWithMonthPlan:monthPlan beginDate:self.beginDate currentYgbm:self.currentYgbm];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - 员工编码懒加载
- (NSString *)ygbm {
    if (_ygbm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygbm = loadVc.emp.ygbm;
    }
    return _ygbm;
}

- (NSString *)xzzj {
    if (_xzzj == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _xzzj = loadVc.emp.xzzj;
    }
    return _xzzj;
}

- (NSString *)ygxm {
    if (_ygxm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygxm = loadVc.emp.ygxm;
    }
    return _ygxm;
}

- (NSString *)currentYgbm {
    if (_currentYgbm == nil) {
        _currentYgbm = [self.ygbm copy];
    }
    return _currentYgbm;
}

- (NSString *)currentXzzj {
    if (_currentXzzj == nil) {
        _currentXzzj = [self.xzzj copy];
    }
    return _currentXzzj;
}

#pragma mark - weekHeaderViewDelegate
- (void)weekHeaderFinishDateDidLoadTableData:(WeekHeaderView *)weekHeader {
    _beginDate = weekHeader.beginDate;
    _endDate  = weekHeader.endDate;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - WKMonthFooterViewDelegate
- (void)monthFooterView:(WKMonthFooterView *)footerView buttonType:(WKMonthFooterViewButtonType)buttonType {
    switch (buttonType) {
        case WKMonthFooterViewButtonTypeAdd: {
                CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"请选择操作" otherButtonTitles:@[@"新计划",@"来自月计划"]];
                sheet.delegate = self;
                [sheet show];
            }
            break;
        case WKMonthFooterViewButtonTypeBatchCommit: {
                [self batchCommit];
            }
            break;
        case WKMonthFooterViewButtonTypeBatchBack: {
                [self cancleBatchCommit];
            }
            break;
        case WKMonthFooterViewButtonTypeApprove: {
                [self approve];
            }
            break;
        case WKMonthFooterViewButtonTypeCancleApprove:{
                [self cancleApprove];
            }
            break;
        default:
            break;
    }
}


/**
 取消审核
 */
- (void)cancleApprove {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"ygbm"] = self.currentYgbm;
    params[@"xz"] = @"3";
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"取消审核..." toView:self.view];
    [GzjhManager cancleApproveNewMonthPlan:params success:^(WKBaseAppResult *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result.code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"取消成功"];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [MBProgressHUD showError:result.message];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

/**
 审核
 */
- (void)approve {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"ygbm"] = self.currentYgbm;
    params[@"xz"] = @"3";
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"审核..." toView:self.view];
    [GzjhManager approveNewMonthPlan:params success:^(WKBaseAppResult *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result.code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"审核成功"];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [MBProgressHUD showError:result.message];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

/**
 提交
 */
- (void)batchCommit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"ygbm"] = self.ygbm;
    params[@"xz"] = @"3";
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"提交..." toView:self.view];
    [GzjhManager commitNewMonthPlan:params success:^(WKBaseAppResult *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result.code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [MBProgressHUD showError:result.message];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

/**
 取消提交
 */
- (void)cancleBatchCommit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"ygbm"] =  self.ygbm;
    params[@"xz"] = @"3";
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"取消提交..." toView:self.view];
    [GzjhManager cancleCommitNewMonthPlan:params success:^(WKBaseAppResult *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result.code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"撤回成功"];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [MBProgressHUD showError:result.message];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - CustomActionSheetDelagate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            WKMonthPlanDetailController *detailVc = [[WKMonthPlanDetailController alloc] initWithXh:@""];
            [self.navigationController pushViewController:detailVc animated:YES];
            break;
        }
        case 1: {
            WKFromMonthController *fromMonthVc = [[WKFromMonthController alloc] init];
            [self.navigationController pushViewController:fromMonthVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark 下拉刷新
- (void)headerRefreshing {
    if ([self.currentXzzj intValue] > 2) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cbr"] = self.currentYgbm;
        params[@"xz"] = @"3";
        params[@"kssj"] = _beginDate;
        params[@"zjxj"] = @([self.ygbm isEqualToString:self.currentYgbm]);
        [GzjhManager getNewMonthPlanList:params success:^(WKMonthPlanResult *result) {
            if ([result.code isEqualToString:@"200"]) {
                self.wkMonthPlans = result.data.list;
                [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:result.message];
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:@"网络异常"];
        }];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cbr"] = self.currentYgbm;
        params[@"xz"] = @"2";
        params[@"kssj"] = _beginDate;
        params[@"zjxj"] = @([self.ygbm isEqualToString:self.currentYgbm]);
        [GzjhManager getWeekPlansWithParams:params success:^(id json) {
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            } else {
                NSDictionary *data = [json objectForKey:@"data"];
                self.monthPlans = [[GzjhManager monthPlansArrayToModelArray:[data objectForKey:@"list"]] copy];
                [self.tableView reloadData];
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:@"网络异常"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

