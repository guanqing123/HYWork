//
//  WeekFromMonthController.m
//  HYWork
//
//  Created by information on 16/6/8.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekFromMonthController.h"
#import "MJRefresh.h"
#import "GzjhManager.h"
#import "LoadViewController.h"
#import "Utils.h"
#import "MonthPlanCell.h"
#import "WeekFromMonthFooterView.h"
#import "NSDate+Extension.h"
#import "WeekPlan.h"
#import "WeekPlanDetailController.h"
#import "MonthPlanDetailController.h"
#import "SJLD.h"

@interface WeekFromMonthController()<UITableViewDataSource,UITableViewDelegate,WeekFromMonthFooterViewDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, strong)  NSArray *monthPlans;

@end

@implementation WeekFromMonthController

- (instancetype)initWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate planOriginalType:(PlanOriginalType)planOriginalType{
    if (self = [super init]) {
        NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
        [sdf setDateFormat:@"yyyy-MM-dd"];
        NSString *tempDate = [NSDate getMonthBeginAndEndWithNSdate:[sdf dateFromString:beginDate]][0];
        _beginDate = [beginDate copy];
        _beginSDate = [tempDate copy];
        _endDate = [endDate copy];
        _planOriginalType = planOriginalType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化 navigation
    [self initNavigation];
    
    // 2.初始tableView
    [self initTableView];
    
    // 2.初始化footerView
    [self initFooterView];
}

#pragma mark 初始化 navigation
- (void)initNavigation {
    // 1.初始化标题和背景色
    switch (_planOriginalType) {
        case PlanOriginalTypeWeekFromMonth:
            self.title = @"月计划";
            break;
        case PlanOriginalTypeMonthFromMonth:
            self.title = @"月计划";
            break;
        case PlanOriginalTypeMonthFromYear:
            self.title = @"年计划";
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.初始化返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始tableView
- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45.0f);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
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

// 员工编码懒加载
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

- (void)headerRefreshing {
    switch (_planOriginalType) {
        case PlanOriginalTypeWeekFromMonth:
            [self loadMonthPlans];
            break;
        case PlanOriginalTypeMonthFromMonth:
            [self loadMonthPlans];
            break;
        case PlanOriginalTypeMonthFromYear:
            [self loadYearPlans];
            break;
        default:
            break;
    }
}

/** 加载来自月计划 */
- (void)loadMonthPlans {
    // 三级经理来自月计划
    if ([[LoadViewController shareInstance].emp.xzzj intValue] > 2) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cbr"] = self.ygbm;
        params[@"xz"] = @"3";
        params[@"kssj"] = _beginSDate;
        [GzjhManager fromMonthPlanList:params success:^(WKMonthPlanResult *result) {
            if ([result.code isEqualToString:@"200"]) {
                self.monthPlans = result.data.list;
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
        params[@"cbr"] = self.ygbm;
        params[@"xz"] = @"2";
        params[@"kssj"] = _beginSDate;
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

/** 加载来自年计划 */
- (void)loadYearPlans {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cbr"] = self.ygbm;
    params[@"xz"] = @"0";
    params[@"lb"] = @"0";
    params[@"kssj"] = _beginSDate;
    params[@"jssj"] = _beginDate;
    [GzjhManager getWeekPlanListWithParams:params success:^(id json) {
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

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.monthPlans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获取cell
    MonthPlanCell *cell = [MonthPlanCell cellWithTableView:tableView];
    
    if (_planOriginalType == PlanOriginalTypeWeekFromMonth && [[LoadViewController shareInstance].emp.xzzj intValue] > 2) {
        // 2.给cell赋值模型
        WKMonthPlan *wkMonthPlan = self.monthPlans[indexPath.row];
        cell.wkMonthPlan = wkMonthPlan;
    } else {
        // 2.给cell赋值模型
        MonthPlan *monthPlan = self.monthPlans[indexPath.row];
        cell.monthPlan = monthPlan;
    }
    
    // 3.返回cell
    return cell;
}

#pragma mark - tableView delegat
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MonthPlanCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_planOriginalType) {
        case PlanOriginalTypeWeekFromMonth: {
            if ([[LoadViewController shareInstance].emp.xzzj intValue] > 2) {
                WKMonthPlan *monthPlan = self.monthPlans[indexPath.row];
                WeekPlan *weekPlan = [[WeekPlan alloc] init];
                weekPlan.yjhxh = monthPlan.xh;
                weekPlan.jhlb = @"1";
                weekPlan.state = @"0";
                weekPlan.yjwc = self.endDate;
                for (SJLD *sjld in self.sjld) {
                    if ([sjld.mr isEqualToString:@"1"]) {
                        weekPlan.dfld = sjld.ygbm;
                        weekPlan.n_dfld = sjld.ygxm;
                        break;
                    }
                }
                weekPlan.cbr = self.ygbm;
                weekPlan.n_cbr = self.ygxm;
                weekPlan.fbr = self.ygbm;
                weekPlan.n_fbr = self.ygxm;
                weekPlan.xbr = @"";
                weekPlan.n_xbr = @"";
                weekPlan.mbz = monthPlan.hlzb;
                weekPlan.gkmb = monthPlan.xdfa;
                weekPlan.gznr = monthPlan.ygznr;
                WeekPlanDetailController *detailVc = [[WeekPlanDetailController alloc] initWithWeekPlan:weekPlan beginDate:self.beginDate currentYgbm:self.ygbm];
                detailVc.sjld = self.sjld;
                [self.navigationController pushViewController:detailVc animated:YES];
            } else {
                MonthPlan *monthPlan = self.monthPlans[indexPath.row];
                WeekPlan *weekPlan = [[WeekPlan alloc] init];
                weekPlan.yjhxh = monthPlan.xh;
                weekPlan.jhlb = @"1";
                weekPlan.state = @"0";
                weekPlan.yjwc = self.endDate;
                for (SJLD *sjld in self.sjld) {
                    if ([sjld.mr isEqualToString:@"1"]) {
                        weekPlan.dfld = sjld.ygbm;
                        weekPlan.n_dfld = sjld.ygxm;
                        break;
                    }
                }
                weekPlan.cbr = self.ygbm;
                weekPlan.n_cbr = self.ygxm;
                weekPlan.fbr = self.ygbm;
                weekPlan.n_fbr = self.ygxm;
                weekPlan.xbr = @"";
                weekPlan.n_xbr = @"";
                weekPlan.mbz = monthPlan.hlzb;
                weekPlan.gkmb = monthPlan.xdfa;
                weekPlan.gznr = monthPlan.ygznr;
                WeekPlanDetailController *detailVc = [[WeekPlanDetailController alloc] initWithWeekPlan:weekPlan beginDate:self.beginDate currentYgbm:self.ygbm];
                detailVc.sjld = self.sjld;
                [self.navigationController pushViewController:detailVc animated:YES];
            }
            break;
        }
        case PlanOriginalTypeMonthFromMonth: {
            MonthPlan *monthPlan = self.monthPlans[indexPath.row];
            monthPlan.sjxh = [NSString stringWithFormat:@"/%@/",monthPlan.xh];
            monthPlan.xh = @"";
            monthPlan.zbxh = @"";
            monthPlan.yjwc = self.endDate;
            monthPlan.state = @"0";
            monthPlan.kssj = self.beginDate;
            for (SJLD *sjld in self.sjld) {
                if ([sjld.mr isEqualToString:@"1"]) {
                    monthPlan.dfld = sjld.ygbm;
                    monthPlan.n_dfld = sjld.ygxm;
                    break;
                }
            }
            MonthPlanDetailController *detailVc = [[MonthPlanDetailController alloc] initWithMonthPlan:monthPlan beginDate:self.beginDate currentYgbm:self.ygbm];
            detailVc.sjld = self.sjld;
            [self.navigationController pushViewController:detailVc animated:YES];
            break;
        }
        case PlanOriginalTypeMonthFromYear: {
            MonthPlan *monthPlan = self.monthPlans[indexPath.row];
            monthPlan.sjxh = [NSString stringWithFormat:@"/%@/",monthPlan.xh];
            monthPlan.xh = @"";
            monthPlan.zbxh = @"";
            monthPlan.yjwc = self.endDate;
            monthPlan.state = @"0";
            monthPlan.kssj = self.beginDate;
            for (SJLD *sjld in self.sjld) {
                if ([sjld.mr isEqualToString:@"1"]) {
                    monthPlan.dfld = sjld.ygbm;
                    monthPlan.n_dfld = sjld.ygxm;
                    break;
                }
            }
            MonthPlanDetailController *detailVc = [[MonthPlanDetailController alloc] initWithMonthPlan:monthPlan beginDate:self.beginDate currentYgbm:self.ygbm];
            detailVc.sjld = self.sjld;
            [self.navigationController pushViewController:detailVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - initFooterView
- (void)initFooterView {
    WeekFromMonthFooterView  *footerView = [WeekFromMonthFooterView footerView];
    footerView.frame = CGRectMake(0, SCREEN_HEIGHT - 45.0f, SCREEN_WIDTH, 45.0f);
    footerView.beginDate = self.beginSDate;
    footerView.delegate = self;
    [self.view addSubview:footerView];
}

- (void)WeekFromMonthFooterViewDidClickDateBtn:(WeekFromMonthFooterView *)footerView {
    _beginSDate = footerView.beginDate;
}

- (void)WeekFromMonthFooterViewDidClickSureBtn:(WeekFromMonthFooterView *)footerView {
    [self.tableView.mj_header beginRefreshing];
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
