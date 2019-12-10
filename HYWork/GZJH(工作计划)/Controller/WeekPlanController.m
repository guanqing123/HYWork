//
//  WeekPlanController.m
//  HYWork
//
//  Created by information on 16/5/17.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanController.h"
#import "WeekHeaderView.h"
#import "WeekFooterView.h"
#import "LoadViewController.h"
#import "GzjhManager.h"
#import "Utils.h"
#import "WeekPlan.h"
#import "WeekPlanCell.h"
#import "MJRefresh.h"
#import "CustomActionSheet.h"
#import "WeekPlanDetailController.h"
#import "WeekPlanListController.h"
#import "WeekFromMonthController.h"
#import "SJLD.h"
#import "ZJXS.h"
#import "LYConstans.h"

@interface WeekPlanController () <UITableViewDataSource,UITableViewDelegate,weekHeaderViewDelegate,UIGestureRecognizerDelegate,weekPlanCellDelegate,weekFooterViewDelegate,CustomActionSheetDelagate>

@property (nonatomic, copy) NSString *ygbm;

@property (nonatomic, copy) NSString *ygxm;

@property (nonatomic, copy) NSString *currentYgbm;

@property (nonatomic, strong)  NSArray *weekPlans;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, weak) WeekHeaderView  *headerView;

@property (nonatomic, weak) WeekFooterView  *footerView;

@property (nonatomic, assign, getter=isEdit) BOOL edit;

@property (nonatomic, assign, getter=isStateType) WeekPlanStateType stateType;

@property (nonatomic, strong)  NSMutableDictionary *chooseDict;

@end

@implementation WeekPlanController

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
    [headerView fillBeginAndEndDateWithPickDate:[NSDate date] gzjhPlanType:GzjhPlanTypeWeek];
    _headerView = headerView;
    [self.view addSubview:headerView];
}

- (void)initFooterView {
    WeekFooterView *footerView = [WeekFooterView footerView:CGRectMake(0, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH - 45.0f, SCREEN_WIDTH, 45.0f) ly:@"week"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kWeekPlanRefreshing) name:kWeekPlanRefreshing object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kZjxsCheckCellClick:) name:kZjxsCheckCellClick object:nil];
}

// 监听通知
- (void)kWeekPlanRefreshing {
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
            for (WeekPlan *wp in self.weekPlans) {
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
    return self.weekPlans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获取cell
    WeekPlanCell *cell = [WeekPlanCell cellWithTableView:tableView];
    cell.delegate = self;
    
    // 2.给cell赋值模型
    WeekPlan *weekPlan = self.weekPlans[indexPath.row];
    cell.weekPlan = weekPlan;
    
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
- (void)weekPlanCellDidChoose:(WeekPlanCell *)weekPlanCell {
    if (weekPlanCell.weekPlan.flag == 2) {
        [self.chooseDict setObject:weekPlanCell.weekPlan forKey:weekPlanCell.weekPlan.xh];
    }else{
        [self.chooseDict removeObjectForKey:weekPlanCell.weekPlan.xh];
    }
    [self checkChooseDictWeekPlanState];
}


#pragma mark - 检查 chooseDict 
/**
 *  chooseDict 里面的 weekPlan 来决定footerView的按钮
 */
- (void)checkChooseDictWeekPlanState {
    BOOL del = true, pause = true , finish = true, commit = true, cancel = true;
    
    NSArray *choose = [self.chooseDict allValues];
    
    for (WeekPlan *wp in choose) {
        if (![wp.state isEqualToString:@"0"]) {
            del = false;
            commit = false;
            break;
        }
    }
    for (WeekPlan *wp in choose) {
        if (![wp.state isEqualToString:@"1"]) {
            pause = false;
            cancel = false;
            break;
        }
    }
    for (WeekPlan *wp in choose) {
        if (![wp.state isEqualToString:@"1"] && ![wp.state isEqualToString:@"3"]) {
            finish = false;
            break;
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
    return [WeekPlanCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edit) return;
    WeekPlan *weekPlan = self.weekPlans[indexPath.row];
    WeekPlanDetailController *detailVc = [[WeekPlanDetailController alloc] initWithWeekPlan:weekPlan beginDate:self.beginDate currentYgbm:self.currentYgbm];
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
    for (WeekPlan *wp in self.weekPlans) {
        wp.flag = 0;
    }
    [self stopEditing];
    [self.tableView reloadData];
}

- (void)weekHeaderDidClickAllChooseButtonLoadData:(WeekHeaderView *)weekHeader {
    _beginDate = weekHeader.beginDate;
    _endDate = weekHeader.endDate;
    [self.chooseDict removeAllObjects];
    for (WeekPlan *wp in self.weekPlans) {
        wp.flag = 2;
        [self.chooseDict setObject:wp forKey:wp.xh];
    }
    [self checkChooseDictWeekPlanState];
    [self.tableView reloadData];
}

#pragma mark - weekFooterViewDelegate
- (void)weekFooterViewDidClickAddBtn:(WeekFooterView *)footerView {
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"请选择操作" otherButtonTitles:@[@"新计划",@"来自他人交办",@"来自协办",@"来自未办结计划",@"来自月计划"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)weekFooterView:(WeekFooterView *)footerView didClickButton:(WeekFooterViewButtonType)buttonType {
    switch (buttonType) {
        case WeekFooterViewButtonTypeDelete:
            [self weekPlanDoAction:@"0" changeState:@"0"];
            break;
        case WeekFooterViewButtonTypePause:
            [self weekPlanDoAction:@"1" changeState:@"3"];
            break;
        case WeekFooterViewButtonTypeFinish:
            [self weekPlanDoAction:@"1" changeState:@"2"];
            break;
        case WeekFooterViewButtonTypeCommit:
            if (_stateType == WeekPlanStateTypeCommit) {
                [self weekPlanDoAction:@"1" changeState:@"1"];
            } else {
                [self weekPlanDoAction:@"1" changeState:@"0"];
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
- (void)weekPlanDoAction:(NSString *)action changeState:(NSString *)state {
    
    NSArray *chooseWeekPlans = [self.chooseDict allValues];
    if (chooseWeekPlans.count < 1) {
        [MBProgressHUD showError:@"当前未选中计划"];
        return;
    }
    NSMutableString *xh = [NSMutableString string];
    for (int i = 0; i < [chooseWeekPlans count]; i++) {
        WeekPlan *wp = chooseWeekPlans[i];
        if (i == [chooseWeekPlans count] - 1) {
            [xh appendString:[NSString stringWithFormat:@"%@",wp.xh]];
        }else{
            [xh appendString:[NSString stringWithFormat:@"%@",wp.xh]];
            [xh appendString:@","];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xz"] = @"1";
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
            WeekPlan *weekPlan = [self weekPlan];
            WeekPlanDetailController *detailVc = [[WeekPlanDetailController alloc] initWithWeekPlan:weekPlan beginDate:self.beginDate currentYgbm:self.ygbm];
            detailVc.sjld = self.sjld;
            [self.navigationController pushViewController:detailVc animated:YES];
            break;
        }
        case 1: {
            NSString *lb = [NSString stringWithFormat:@"%ld",(long)buttonIndex];
            WeekPlanListController *listVc = [[WeekPlanListController alloc] initWithLb:lb beginDate:self.beginDate endDate:self.endDate];
            listVc.sjld = self.sjld;
            listVc.title = @"交办";
            [self.navigationController pushViewController:listVc animated:YES];
            break;
        }
        case 2: {
            NSString *lb = [NSString stringWithFormat:@"%ld",(long)buttonIndex];
            WeekPlanListController *listVc = [[WeekPlanListController alloc] initWithLb:lb beginDate:self.beginDate endDate:self.endDate];
            listVc.sjld = self.sjld;
            listVc.title = @"协办";
            [self.navigationController pushViewController:listVc animated:YES];
            break;
        }
        case 3: {
            NSString *lb = [NSString stringWithFormat:@"%ld",(long)buttonIndex];
            WeekPlanListController *listVc = [[WeekPlanListController alloc] initWithLb:lb beginDate:self.beginDate endDate:self.endDate];
            listVc.sjld = self.sjld;
            listVc.title = @"未办结";
            [self.navigationController pushViewController:listVc animated:YES];
            break;
        }
        case 4: {
            WeekFromMonthController *wfmVc = [[WeekFromMonthController alloc] initWithBeginDate:self.beginDate endDate:self.endDate planOriginalType:PlanOriginalTypeWeekFromMonth];
            wfmVc.sjld = self.sjld;
            [self.navigationController pushViewController:wfmVc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (WeekPlan *)weekPlan {
    WeekPlan *weekPlan = [[WeekPlan alloc] init];
    weekPlan.jhlb = @"1";
    weekPlan.yjwc = self.endDate;
    weekPlan.cbr = self.ygbm;
    weekPlan.n_cbr = self.ygxm;
    weekPlan.fbr = self.ygbm;
    weekPlan.n_fbr = self.ygxm;
    weekPlan.mbz = @"";
    weekPlan.gkmb = @"";
    weekPlan.gznr = @"";
    for (SJLD *sjld in self.sjld) {
        if ([sjld.mr isEqualToString:@"1"]) {
            weekPlan.dfld = sjld.ygbm;
            weekPlan.n_dfld = sjld.ygxm;
            break;
        }
    }
    return weekPlan;
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
    params[@"xz"] = @"1";
    params[@"kssj"] = _beginDate;
    [GzjhManager getWeekPlansWithParams:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            self.weekPlans = [[GzjhManager weekPlansArrayToModelArray:[data objectForKey:@"list"]] copy];
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
