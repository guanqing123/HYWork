//
//  WeekPlanDetailController.m
//  HYWork
//
//  Created by information on 16/5/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "WeekPlanDetailController.h"
#import "WeekPlanDetailCell.h"
#import "WeekDetailFooterView.h"
#import "CustomActionSheet.h"
#import "WeekPlan.h"
#import "GzjhManager.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "SelectPickerView.h"
#import "BrowseController.h"
#import "BrowseMultiController.h"
#import "LYConstans.h"
#import "SJLD.h"
#import "MJExtension.h"

@interface WeekPlanDetailController()<WeekPlanDetailCellDelegate,CustomActionSheetDelagate,WeekDetailFooterViewDelegate,BrowseMultiControllerDelegate,SelectPickerViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation WeekPlanDetailController

- (instancetype)initWithWeekPlan:(WeekPlan *)weekPlan beginDate:(NSString *)beginDate currentYgbm:(NSString *)currentYgbm{
    if (self = [super init]) {
        _weekPlan = weekPlan;
        _beginDate = beginDate;
        _currentYgbm = currentYgbm;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }*/
    
    // 0.初始化导航栏
    [self initNavigation];
}

#pragma mark - 初始化导航栏
- (void)initNavigation {
    // 0.设置背景和标题
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详细周计划";
    
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

#pragma mark - kBrowseCellClickNote
- (void)browseCellClick:(NSNotification *)note {
    NSDictionary *dict = note.userInfo[kBrowseCellClick];
    self.weekPlan.cbr = dict[@"ygbm"];
    self.weekPlan.n_cbr = dict[@"ygxm"];
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekPlanDetailCell *cell = [WeekPlanDetailCell cellWithTableView:tableView rowIndex:indexPath.row];
    cell.weekPlan = self.weekPlan;
    cell.sjld = self.sjld;
    cell.delegate = self;
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WeekPlanDetailCell cellHeight:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.ygbm isEqualToString:self.currentYgbm]) {
        return 45.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WeekDetailFooterView *footerView = [WeekDetailFooterView footerViewWithTableView:tableView];
    footerView.weekPlan = self.weekPlan;
    footerView.delegate = self;
    return footerView;
}

#pragma mark - 员工编码懒加载
- (NSString *)ygbm {
    if (_ygbm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygbm = loadVc.emp.ygbm;
    }
    return _ygbm;
}

#pragma mark WeekDetailFooterViewDelegate
- (void)weekDetailFooterViewDidClickDeleteBtn:(WeekDetailFooterView *)footerView {
    [self.view endEditing:YES];
    // 1.删除
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xz"] = @"1";
    params[@"action"] = @"0";
    params[@"state"] = @"0";
    params[@"fbxh"] = footerView.weekPlan.xh;
    params[@"kssj"] = self.beginDate;
    [MBProgressHUD showMessage:@"正在删除中..." toView:self.view];
    [GzjhManager updateOrDeletePlanWithParams:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeekPlanRefreshing object:nil userInfo:nil];
            
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

- (void)weekDetailFooterViewDidClickSaveBtn:(WeekDetailFooterView *)footerView {
    // 1. 保存
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lrr"] = self.ygbm;
    params[@"xz"] = @"1";
    params[@"state"] = @"0";
    params[@"kssj"] = self.beginDate;
    params[@"gzrz"] = [self.weekPlan mj_keyValues];
    [MBProgressHUD showMessage:@"正在保存中..." toView:self.view];
    [GzjhManager saveAndCommitPlanWithParams:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeekPlanRefreshing object:nil userInfo:nil];
            
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

- (void)weekDetailFooterViewDidClickCancelBtn:(WeekDetailFooterView *)footerView {
    if ([footerView.weekPlan.state intValue]) {
        // 1.取消提交
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"xz"] = @"1";
        params[@"action"] = @"1";
        params[@"fbxh"] = footerView.weekPlan.xh;
        params[@"state"] = @"0";
        params[@"kssj"] = self.beginDate;
        [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
        [GzjhManager updateOrDeletePlanWithParams:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            } else {
               [[NSNotificationCenter defaultCenter] postNotificationName:kWeekPlanRefreshing object:nil userInfo:nil];
               self.weekPlan.state = @"0";
               [self.tableView reloadData];
            }
        } failure:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常"];
        }];
    }else{
        // 2.提交
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lrr"] = self.ygbm;
        params[@"xz"] = @"1";
        params[@"state"] = @"1";
        params[@"kssj"] = self.beginDate;
        params[@"gzrz"] = [self.weekPlan mj_keyValues];
        [MBProgressHUD showMessage:@"正在提交中..." toView:self.view];
        [GzjhManager saveAndCommitPlanWithParams:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] > 1) {
                [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeekPlanRefreshing object:nil userInfo:nil];
                
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
}

#pragma mark - WeekPlanDetailCellDelegate
- (void)weekPlanDetailCellDidClickXbrBtn:(WeekPlanDetailCell *)weekPlanDetailCell {
    BrowseMultiController *browseMultiVc = [[BrowseMultiController alloc] init];
    browseMultiVc.delegate = self;
    [browseMultiVc fillXbrStr:self.weekPlan.xbr xbrmcStr:self.weekPlan.n_xbr];
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
    self.weekPlan.xbr = [xbr copy];
    self.weekPlan.n_xbr = [n_xbr copy];
    [self.tableView reloadData];
}

#pragma mark - WeekPlanDetailCellDelegate
- (void)weekPlanDetailCellDidClickZbrBtn:(WeekPlanDetailCell *)weekPlanDetailCell {
    BrowseController *browseVc = [[BrowseController alloc] init];
    [self.navigationController pushViewController:browseVc animated:YES];
}

#pragma mark WeekPlanDetailCellDelegate
- (void)weekPlanDetailCellDidClickGzlbBtn:(WeekPlanDetailCell *)weekPlanDetailCell {
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:@"工作类别" otherButtonTitles:@[@"日常工作",@"出差"]];
    sheet.delegate = self;
    [sheet show];
}

#pragma mark - CustomActionSheetDelagate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.weekPlan.jhlb = @"1";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        self.weekPlan.jhlb = @"2";
        [self.tableView reloadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
