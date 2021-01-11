//
//  WKHomeViewController.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKHomeViewController.h"

//views
#import "WKSliderHeaderView.h"
#import "WKNoticeSectionHeaderView.h"
#import "WKLineFooterView.h"

//controllers
#import "WKSliderViewController.h"
#import "LoadViewController.h"
#import "WKNoticeWebViewController.h"

//cell
#import "WKOATableViewCell.h"
#import "WKCommonTableViewCell.h"

//tool
#import "Utils.h"
#import "MJExtension.h"

@interface WKHomeViewController ()<UITableViewDataSource,UITableViewDelegate,WKNoticeSectionHeaderViewDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, weak) WKNoticeSectionHeaderView  *headerView;

/** OA办公 */
@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *oaWorks;
/** 常用 */
@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *commons;

@end

static NSString *const WKOATableViewCellID = @"WKOATableViewCell";
static NSString *const WKCommonTableViewCellID = @"WKCommonTableViewCell";

@implementation WKHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.headerView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.headerView stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 0.loadData
    [self setupData];
    
    // 1.tableView
    [self setupTableView];
    
    // 2.headerView
    [self setupHeaderView];
}

#pragma mark - setupData
- (void)setupData {
    _oaWorks = [WKHomeWork mj_objectArrayWithFilename:@"oawork.plist"];
    _commons = [WKHomeWork mj_objectArrayWithFilename:@"commons.plist"];
}

#pragma mark - setupHeaderView
- (void)setupHeaderView {
    WKSliderHeaderView *headerView = [WKSliderHeaderView headerView];
    headerView.frame = (CGRect){CGPointZero, CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 1 / 2)};
    WEAKSELF
    headerView.sliderClickBlock = ^(WKHomeSlider * _Nonnull slider) {
        WKSliderViewController *sliderVc = [[WKSliderViewController alloc] initWithIdStr:slider.idStr];
        sliderVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:sliderVc animated:YES];
    };
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - setupTableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (Utils.isIPhoneX) {
        tableView.frame = self.view.bounds;
    } else {
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWBottomTabH);
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKOATableViewCell class]) bundle:nil] forCellReuseIdentifier:WKOATableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCommonTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKCommonTableViewCellID];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else if (indexPath.section == 1) {
        return 85 * 2 + 35;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cusCell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        WKOATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKOATableViewCellID forIndexPath:indexPath];
        cell.oaWorks = _oaWorks;
        cusCell = cell;
    } else if (indexPath.section == 1) {
        WKCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKCommonTableViewCellID forIndexPath:indexPath];
        cell.commons = _commons;
        cusCell = cell;
    }
    
    return cusCell;
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 54.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        WKNoticeSectionHeaderView *headerView = [WKNoticeSectionHeaderView sectionHeaderView];
        _headerView = headerView;
        headerView.delegate = self;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 64.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        WKLineFooterView *footerView = [WKLineFooterView footerView];
        return footerView;
    }
    return nil;
}

#pragma mark - WKNoticeSectionHeaderViewDelegate
- (void)headerViewDidClick:(WKNoticeSectionHeaderView *)headerView currentNoticeId:(NSString *)noticeId {
     LoadViewController *loadController = [LoadViewController shareInstance];
     if (loadController.isLoaded) {
         WKNoticeWebViewController *baseVc = [[WKNoticeWebViewController alloc] init];
         [self.navigationController pushViewController:baseVc animated:YES];
     } else {
         [self.navigationController pushViewController:loadController animated:YES];
     }
}

#pragma mark - 屏幕横竖屏设置
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
