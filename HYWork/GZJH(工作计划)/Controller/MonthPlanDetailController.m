//
//  MonthPlanDetailController.m
//  HYWork
//
//  Created by information on 16/6/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//
#import "MonthPlanDetailController.h"
#import "MonthPlanDetailCell.h"
#import "MonthDetailFooterView.h"
#import "MonthDetailHeaderView.h"
#import "CustomActionSheet.h"
#import "WeekPlan.h"
#import "GzjhManager.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "SelectPickerView.h"
#import "BrowseController.h"
#import "BrowseMultiController.h"
#import "LYConstans.h"
#import "MJExtension.h"
#import "LoadViewController.h"

@interface MonthPlanDetailController()<MonthPlanDetailCellDelegate,CustomActionSheetDelagate,MonthDetailFooterViewDelegate,BrowseMultiControllerDelegate>

@end

@implementation MonthPlanDetailController

- (instancetype)initWithMonthPlan:(MonthPlan *)monthPlan beginDate:(NSString *)beginDate currentYgbm:(NSString *)currentYgbm{
    if (self = [super init]) {
        _monthPlan = monthPlan;
        _currentYgbm = currentYgbm;
        _beginDate = beginDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (@available(iOS 11.0,*)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 20, 0);
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    }
    
    // 0.初始化导航栏
    [self initNavigation];
}

#pragma mark - 初始化导航栏
- (void)initNavigation {
    // 0.设置背景和标题
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详细月计划";
    
    // 1.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 监听 browse cell click
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(browseCellClick:) name:kBrowseCellClick object:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - kBrowseCellClickNote
- (void)browseCellClick:(NSNotification *)note {
    NSDictionary *dict = note.userInfo[kBrowseCellClick];
    self.monthPlan.cbr = dict[@"ygbm"];
    self.monthPlan.n_cbr = dict[@"ygxm"];
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MonthPlanDetailCell *cell = [MonthPlanDetailCell cellWithTableView:tableView rowIndex:indexPath.row];
    cell.monthPlan = self.monthPlan;
    cell.sjld = self.sjld;
    cell.delegate = self;
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MonthPlanDetailCell cellHeight:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.ygbm isEqualToString:self.currentYgbm]) {
        return 45.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MonthDetailFooterView *footerView = [MonthDetailFooterView footerViewWithTableView:tableView];
    footerView.monthPlan = self.monthPlan;
    footerView.delegate = self;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.ygbm isEqualToString:self.currentYgbm] && [_monthPlan.state intValue] > 0) {
        return 130.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MonthDetailHeaderView *headerView = [MonthDetailHeaderView headerViewWithTableView:tableView];
    headerView.monthPlan = self.monthPlan;
    return headerView;
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
        _xzzj = [LoadViewController shareInstance].emp.xzzj;
    }
    return _xzzj;
}

#pragma mark MonthDetailFooterViewDelegate
- (void)monthDetailFooterViewDidClickDeleteBtn:(MonthDetailFooterView *)footerView {
    // 1.删除
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xz"] = @"2";
    params[@"action"] = @"0";
    params[@"state"] = @"0";
    params[@"fbxh"] = footerView.monthPlan.xh;
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"正在删除中..." toView:self.view];
    [GzjhManager updateOrDeletePlanWithParams:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMonthPlanRefreshing object:nil userInfo:nil];
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[NSClassFromString(@"GzjhViewController") class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
            
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)monthDetailFooterViewDidClickSaveBtn:(MonthDetailFooterView *)footerView {
    // 1. 保存
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lrr"] = self.ygbm;
    params[@"xz"] = @"2";
    if ([_monthPlan.state intValue] > 0) {
        params[@"state"] = @"1";
    }else {
        params[@"state"] = @"0";
    }
    
    params[@"kssj"] = self.beginDate;
    params[@"gzrz"] = [self.monthPlan mj_keyValues];
    [MBProgressHUD showMessage:@"正在保存中..." toView:self.view];
    [GzjhManager saveAndCommitPlanWithParams:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMonthPlanRefreshing object:nil userInfo:nil];
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[NSClassFromString(@"GzjhViewController") class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}

- (void)monthDetailFooterViewDidClickCancelBtn:(MonthDetailFooterView *)footerView {
    if ([self.xzzj intValue] <= 2) {
        [MBProgressHUD showError:@"请到月计划列表,长按某行进行提交等操作"];
        return;
    }
    if ([footerView.monthPlan.state intValue]) {
        // 1.取消提交
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"xz"] = @"2";
        params[@"action"] = @"1";
        params[@"state"] = @"0";
        params[@"fbxh"] = footerView.monthPlan.xh;
        params[@"kssj"] = self.beginDate;
        
        [MBProgressHUD showMessage:@"正在更新中..." toView:self.view];
        [GzjhManager updateOrDeletePlanWithParams:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMonthPlanRefreshing object:nil userInfo:nil];
                self.monthPlan.state = @"0";
                [self.tableView reloadData];
            }
        } failure:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常"];
        }];
        
    }else{
        // 2.保存并提交
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lrr"] = self.ygbm;
        params[@"xz"] = @"2";
        params[@"state"] = @"2";
        params[@"kssj"] = self.beginDate;
        params[@"gzrz"] = [self.monthPlan mj_keyValues];
        [MBProgressHUD showMessage:@"正在保存中..." toView:self.view];
        [GzjhManager saveAndCommitPlanWithParams:params success:^(id json) {
            [MBProgressHUD hideHUD];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMonthPlanRefreshing object:nil userInfo:nil];
                
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[NSClassFromString(@"GzjhViewController") class] ]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }
        } failure:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常"];
        }];
    }
}

#pragma mark - MonthPlanDetailCellDelegate
- (void)monthPlanDetailCellDidClickXbrBtn:(MonthPlanDetailCell *)monthPlanDetailCell {
    BrowseMultiController *browseMultiVc = [[BrowseMultiController alloc] init];
    browseMultiVc.delegate = self;
    [browseMultiVc fillXbrStr:self.monthPlan.xbr xbrmcStr:self.monthPlan.n_xbr];
    [self.navigationController pushViewController:browseMultiVc animated:YES];
}

#pragma mark - BrowseMultiControllerDelegate
- (void)browseMultiControllerDidBackLeftBarButtonItem:(BrowseMultiController *)browseMultiController {
    NSMutableString *xbr = [NSMutableString string];
    NSMutableString *n_xbr = [NSMutableString string];
    NSArray *keys = [browseMultiController.dicts allKeys];
    unsigned long count = [keys count];
    id key,value;
    for (int i = 0; i < count; i++) {
        key = [keys objectAtIndex:i];
        value = [browseMultiController.dicts objectForKey:key];
        if (i == count - 1) {
            [xbr appendString:key];
            [n_xbr appendString:value];
        }else{
            [xbr appendString:key];
            [n_xbr appendString:value];
            [xbr appendString:@","];
            [n_xbr appendString:@","];
        }
    }
    self.monthPlan.xbr = [xbr copy];
    self.monthPlan.n_xbr = [n_xbr copy];
    [self.tableView reloadData];
}

#pragma mark - MonthPlanDetailCellDelegate
- (void)monthPlanDetailCellDidClickZbrBtn:(MonthPlanDetailCell *)monthPlanDetailCell {
    BrowseController *browseVc = [[BrowseController alloc] init];
    [self.navigationController pushViewController:browseVc animated:YES];
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

