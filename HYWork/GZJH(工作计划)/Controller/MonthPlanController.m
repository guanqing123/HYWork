//
//  MonthPlanController.m
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "MonthPlanController.h"
#import "WeekHeaderView.h"
#import "WeekFooterView.h"
#import "LoadViewController.h"
#import "GzjhManager.h"
#import "Utils.h"
#import "MonthPlan.h"
#import "MonthPlanCell.h"
#import "MJRefresh.h"
#import "CustomActionSheet.h"
#import "MonthPlanDetailController.h"
#import "WeekPlanListController.h"
#import "SJLD.h"
#import "ZJXS.h"
#import "LYConstans.h"
#import "WeekFromMonthController.h"

@interface MonthPlanController () <UITableViewDataSource,UITableViewDelegate,weekHeaderViewDelegate,UIGestureRecognizerDelegate,monthPlanCellDelegate,weekFooterViewDelegate,CustomActionSheetDelagate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *ygxm;

@property (nonatomic, copy) NSString *currentYgbm;

@property (nonatomic, strong)  NSArray *monthPlans;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, weak) WeekHeaderView  *headerView;

@property (nonatomic, weak) WeekFooterView  *footerView;

@property (nonatomic, assign, getter=isEdit) BOOL edit;

@property (nonatomic, assign, getter=isStateType) WeekPlanStateType stateType;

@property (nonatomic, strong)  NSMutableDictionary *chooseDict;

@property (nonatomic, copy) NSString *xzzj;

@end

@implementation MonthPlanController

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
}

- (void)initFooterView {
    WeekFooterView *footerView = [WeekFooterView footerView:CGRectMake(0, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH - 45.0f, SCREEN_WIDTH, 45.0f) ly:@"month"];
    footerView.delegate = self;
    _footerView = footerView;
    [self.view addSubview:footerView];
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
    
    // tableViewCell 添加长按手势
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 1.0;
    longPressReger.delegate = self;
    [tableView addGestureRecognizer:longPressReger];
    
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
    self.footerView.hidden = ![self.currentYgbm isEqualToString:self.ygbm];
    [self.tableView.mj_header beginRefreshing];
}

/** 移除通知 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 手势长按
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (![self.ygbm isEqualToString:self.currentYgbm]) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        if (indexPath) {
            for (MonthPlan *wp in self.monthPlans) {
                wp.flag = true;
            }
            [self startEditing];
        }
    }
    
}

#pragma mark - LongTouch UIGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (!_edit) {
        //CGPoint p = [touch locationInView:self.tableView];
        return YES;
    }else{
        return NO;
    }
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
    cell.delegate = self;
    
    // 2.给cell赋值模型
    MonthPlan *monthPlan = self.monthPlans[indexPath.row];
    cell.monthPlan = monthPlan;
    
    // 3.返回cell
    return cell;
}

#pragma mark - 懒加载 dict
- (NSMutableDictionary *)chooseDict {
    if (_chooseDict == nil) {
        _chooseDict = [NSMutableDictionary dictionary];
    }
    return _chooseDict;
}

#pragma mark - weekPlanCellDelegate
- (void)monthPlanCellDidChoose:(MonthPlanCell *)monthPlanCell {
    if (monthPlanCell.monthPlan.flag == 2) {
        [self.chooseDict setObject:monthPlanCell.monthPlan forKey:monthPlanCell.monthPlan.xh];
    }else{
        [self.chooseDict removeObjectForKey:monthPlanCell.monthPlan.xh];
    }
    [self checkChooseDictWeekPlanState];
}


- (NSString *)xzzj {
    if (_xzzj == nil) {
        _xzzj = [LoadViewController shareInstance].emp.xzzj;
    }
    return _xzzj;
}

#pragma mark - 检查 chooseDict
/**
 *  chooseDict 里面的 weekPlan 来决定footerView的按钮
 */
- (void)checkChooseDictWeekPlanState {
    BOOL del = true, pause = true , finish = true, commit = true, cancel = true;
    
    NSArray *choose = [self.chooseDict allValues];
    
    for (MonthPlan *mp in choose) {
        if (![mp.state isEqualToString:@"0"]) {
            del = false;
            commit = false;
            break;
        }
    }
    for (MonthPlan *mp in choose) {
        if (![mp.state isEqualToString:@"1"]) {
            pause = false;
            cancel = false;
            break;
        }
    }
    for (MonthPlan *mp in choose) {
        if (![mp.state isEqualToString:@"1"] && ![mp.state isEqualToString:@"3"]) {
            finish = false;
            break;
        }
    }
    
    if ([self.xzzj isEqualToString:@"1"] || [self.xzzj isEqualToString:@"2"]) {
        int  totalScore = 0;
        for (MonthPlan *mp in choose) {
            totalScore += [mp.fz intValue];
        }
        if (totalScore != 100) {
            commit = false;
            cancel = false;
        }
    }
    
    if (commit) {
        _stateType = WeekPlanStateTypeCommit;
    }else if(cancel){
        _stateType = WeekPlanStateTypeCancel;
    }else{
        _stateType = WeekPlanStateTypeDefault;
    }
    
    [self.footerView fillDel:del pause:pause finish:finish sateType:_stateType];
}


#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MonthPlanCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edit) return;
    MonthPlan *monthPlan = self.monthPlans[indexPath.row];
    MonthPlanDetailController *detailVc = [[MonthPlanDetailController alloc] initWithMonthPlan:monthPlan beginDate:self.beginDate currentYgbm:self.currentYgbm];
    detailVc.sjld = self.sjld;
    [self.navigationController pushViewController:detailVc animated:YES];
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

- (NSString *)currentYgbm {
    if (_currentYgbm == nil) {
        _currentYgbm = [self.ygbm copy];
    }
    return _currentYgbm;
}

#pragma mark - weekHeaderViewDelegate
- (void)weekHeaderFinishDateDidLoadTableData:(WeekHeaderView *)weekHeader {
    _beginDate = weekHeader.beginDate;
    _endDate  = weekHeader.endDate;
    [self.tableView.mj_header beginRefreshing];
}

- (void)weekHeaderDidClickCancelButtonLoadData:(WeekHeaderView *)weekHeader {
    _beginDate = weekHeader.beginDate;
    _endDate = weekHeader.endDate;
    [self.chooseDict removeAllObjects];
    for (MonthPlan *mp in self.monthPlans) {
        mp.flag = 0;
    }
    [self stopEditing];
    [self.tableView reloadData];
}

- (void)weekHeaderDidClickAllChooseButtonLoadData:(WeekHeaderView *)weekHeader {
    _beginDate = weekHeader.beginDate;
    _endDate = weekHeader.endDate;
    [self.chooseDict removeAllObjects];
    for (MonthPlan *mp in self.monthPlans) {
        mp.flag = 2;
        [self.chooseDict setObject:mp forKey:mp.xh];
    }
    [self checkChooseDictWeekPlanState];
    [self.tableView reloadData];
}

#pragma mark - weekFooterViewDelegate
- (void)weekFooterViewDidClickAddBtn:(WeekFooterView *)footerView {
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"请选择操作" otherButtonTitles:@[@"新计划",@"来自月计划",@"来自年计划"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)weekFooterView:(WeekFooterView *)footerView didClickButton:(WeekFooterViewButtonType)buttonType {
    switch (buttonType) {
        case WeekFooterViewButtonTypeDelete:
            [self monthPlanDoAction:@"0" changeState:@"0"];
            break;
        case WeekFooterViewButtonTypePause:
            [self monthPlanDoAction:@"1" changeState:@"3"];
            break;
        case WeekFooterViewButtonTypeFinish:
            [self monthPlanDoAction:@"1" changeState:@"2"];
            break;
        case WeekFooterViewButtonTypeCommit:
            if (_stateType == WeekPlanStateTypeCommit) {
                [self monthPlanDoAction:@"1" changeState:@"1"];
            } else {
                [self monthPlanDoAction:@"1" changeState:@"0"];
            }
            break;
        default:
            break;
    }
}

/**
 *  根据不同按钮,把计划改成不同的状态
 *
 *  @param state 目标状态
 */
- (void)monthPlanDoAction:(NSString *)action changeState:(NSString *)state {
    
    NSArray *chooseMonthPlans = [self.chooseDict allValues];
    if (chooseMonthPlans.count < 1) {
        [MBProgressHUD showError:@"当前未选中计划"];
        return;
    }
    NSMutableString *xh = [NSMutableString string];
    for (int i = 0; i < [chooseMonthPlans count]; i++) {
        MonthPlan *mp = chooseMonthPlans[i];
        if (i == [chooseMonthPlans count] - 1) {
            [xh appendString:[NSString stringWithFormat:@"%@",mp.xh]];
        }else{
            [xh appendString:[NSString stringWithFormat:@"%@",mp.xh]];
            [xh appendString:@","];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xz"] = @"2";
    params[@"action"] = action;
    params[@"state"] = state;
    params[@"fbxh"] = xh;
    params[@"kssj"] = self.beginDate;
    
    [MBProgressHUD showMessage:@"正在更新中..." toView:self.view];
    [GzjhManager updateOrDeletePlanWithParams:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD showSuccess:@"操作成功"];
        }
        [self.tableView.mj_header beginRefreshing];
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}

#pragma mark - CustomActionSheetDelagate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            MonthPlan *monthPlan = [self monthPlan];
            MonthPlanDetailController *detailVc = [[MonthPlanDetailController alloc] initWithMonthPlan:monthPlan beginDate:self.beginDate currentYgbm:self.ygbm];
            detailVc.sjld = self.sjld;
            [self.navigationController pushViewController:detailVc animated:YES];
            break;
        }
        case 1: {
            WeekFromMonthController *wfmVc = [[WeekFromMonthController alloc] initWithBeginDate:self.beginDate endDate:self.endDate planOriginalType:PlanOriginalTypeMonthFromMonth];
            wfmVc.sjld = self.sjld;
            [self.navigationController pushViewController:wfmVc animated:YES];
            break;
        }
        case 2: {
            WeekFromMonthController *wfmVc = [[WeekFromMonthController alloc] initWithBeginDate:self.beginDate endDate:self.endDate planOriginalType:PlanOriginalTypeMonthFromYear];
            wfmVc.sjld = self.sjld;
            [self.navigationController pushViewController:wfmVc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (MonthPlan *)monthPlan {
    MonthPlan *monthPlan = [[MonthPlan alloc] init];
    /** 1.指标类型 */
    monthPlan.zblx = @"3";
    /** 2.衡量指标 */
    monthPlan.hlzb = @"";
    /** 3.年度目标值 */
    monthPlan.gznr = @"";
    /** 4.月度目标值 */
    monthPlan.ygznr = @"";
    /** 5.考核标准 */
    monthPlan.khbz = @"";
    /** 6.行动方案 */
    monthPlan.xdfa = @"";
    /** 7.权重(目标分值) */
    monthPlan.fz = @"0";
    /** 8.预计完成时间 */
    monthPlan.yjwc = self.endDate;
    /** 9.主办人 */
    monthPlan.cbr = self.ygbm;
    monthPlan.n_cbr = self.ygxm;
    /** 10.交办人 */
    monthPlan.fbr = self.ygbm;
    monthPlan.n_fbr = self.ygxm;
    /** 11.协办人 */
    monthPlan.xbr = @"";
    monthPlan.n_xbr = @"";
    /** 12.打分领导 */
    for (SJLD *sjld in self.sjld) {
        if ([sjld.mr isEqualToString:@"1"]) {
            monthPlan.dfld = sjld.ygbm;
            monthPlan.n_dfld = sjld.ygxm;
            break;
        }
    }
    /** 13.开始日期 */
    monthPlan.kssj = self.beginDate;
    
    return monthPlan;
}

#pragma mark - 给edit赋值
- (void)startEditing {
    _edit = true;
    self.headerView.edit = _edit;
    self.footerView.edit = _edit;
    [self.footerView fillDel:true pause:true finish:true sateType:WeekPlanStateTypeCommit];
    [self.tableView reloadData];
}

- (void)stopEditing {
    _edit = false;
    self.headerView.edit = _edit;
    self.footerView.edit = _edit;
    [self.footerView fillDel:false pause:false finish:false sateType:WeekPlanStateTypeDefault];
    [self.chooseDict removeAllObjects];
}

#pragma mark 下拉刷新
- (void)headerRefreshing {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cbr"] = self.currentYgbm;
    params[@"xz"] = @"2";
    params[@"kssj"] = _beginDate;
    [GzjhManager getWeekPlansWithParams:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            self.monthPlans = [[GzjhManager monthPlansArrayToModelArray:[data objectForKey:@"list"]] copy];
            [self.tableView reloadData];
            [self stopEditing];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
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

