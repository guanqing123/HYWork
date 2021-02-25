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
#import "WKBaseWebViewController.h"

//cell
#import "WKOATableViewCell.h"
#import "WKCommonTableViewCell.h"
#import "WKDefineTableViewCell.h"

//tool
#import "Utils.h"
#import "MJExtension.h"
#import "LYConstans.h"

@interface WKHomeViewController ()<UITableViewDataSource,UITableViewDelegate,WKNoticeSectionHeaderViewDelegate,WKOATableViewCellDelegate,WKCommonTableViewCellDelegate,WKDefineTableViewCellDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, weak) WKNoticeSectionHeaderView  *headerView;

/** OA办公 */
@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *oaWorks;
/** 常用 */
@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *commons;
/** 自定义 */
@property (nonatomic, strong)  NSMutableArray<WKHomeWork *> *defines;

@end

static NSString *const WKOATableViewCellID = @"WKOATableViewCell";
static NSString *const WKCommonTableViewCellID = @"WKCommonTableViewCell";
static NSString *const WKDefineTableViewCellID = @"WKDefineTableViewCell";


@implementation WKHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    
    // 3.监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDefines) name:refreshDefines object:nil];
}

#pragma mark - refreshDefines
- (void)refreshDefines {
    [_defines removeAllObjects];
    
    NSArray *des = [NSKeyedUnarchiver unarchiveObjectWithFile:DEFINES];
    if ([des count] > 0) {
        [_defines addObjectsFromArray:des];
    }
    
    WKHomeWork *addCommon = [[WKHomeWork alloc] init];
    addCommon.gridTitle = @"添加";
    addCommon.iconImage = @"addDefine";
    addCommon.pageType = pageTypeNative;
    addCommon.destVcClass = @"WKFunsViewController";
    [_defines addObject:addCommon];
    
    [self.tableView reloadData];
}

#pragma mark - setupData
- (void)setupData {
    _oaWorks = [WKHomeWork mj_objectArrayWithFilename:@"oawork.plist"];
    _commons = [WKHomeWork mj_objectArrayWithFilename:@"commons.plist"];
    
    _defines = [NSMutableArray array];
    NSArray *des = [NSKeyedUnarchiver unarchiveObjectWithFile:DEFINES];
    if ([des count] > 0) {
        [_defines addObjectsFromArray:des];
    }
    
    WKHomeWork *addCommon = [[WKHomeWork alloc] init];
    addCommon.gridTitle = @"添加";
    addCommon.iconImage = @"addDefine";
    addCommon.pageType = pageTypeNative;
    addCommon.destVcClass = @"WKFunsViewController";
    [_defines addObject:addCommon];
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
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKOATableViewCell class]) bundle:nil] forCellReuseIdentifier:WKOATableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCommonTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKCommonTableViewCellID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WKDefineTableViewCell class]) bundle:nil] forCellReuseIdentifier:WKDefineTableViewCellID];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if (indexPath.section == 0) {
        return 120;
    } else*/ if (indexPath.section == 0) {
        return 85 * 2 + 35 + 5;
    } else if (indexPath.section == 1) {
        return (1 + (_defines.count - 1) / 4) * 85 + 35;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cusCell = [UITableViewCell new];
    
    /*if (indexPath.section == 0) {
        WKOATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKOATableViewCellID forIndexPath:indexPath];
        cell.oaWorks = _oaWorks;
        cell.delegate = self;
        cusCell = cell;
    } else */if (indexPath.section == 0) {
        WKCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKCommonTableViewCellID forIndexPath:indexPath];
        cell.commons = _commons;
        cell.delegate = self;
        cusCell = cell;
    } else if (indexPath.section == 1) {
        WKDefineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKDefineTableViewCellID forIndexPath:indexPath];
        cell.defines = _defines;
        cell.delegate = self;
        cusCell = cell;
    }
    cusCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cusCell;
}

#pragma mark - WKOATableViewCellDelegate
- (void)oaTableViewCell:(WKOATableViewCell *)tableViewCell didClickCollectionViewItem:(WKHomeWork *)homeWork {
    [self jump:homeWork];
}

#pragma mark - WKCommonTableViewCellDelegate
- (void)commonTableViewCell:(WKCommonTableViewCell *)tableViewCell didClickCollectionViewItem:(WKHomeWork *)homeWork {
    [self jump:homeWork];
}

#pragma mark - WKDefineTableViewCellDelegate
- (void)defineTableViewCell:(WKDefineTableViewCell *)tableViewCell didClickCollectionViewItem:(WKHomeWork *)homeWork {
    [self jump:homeWork];
}

- (void)jump:(WKHomeWork *)homeWork {
    if (homeWork.load) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        if (!loadVc.isLoaded) {
           loadVc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:loadVc animated:YES];
           return;
        }
    }
    switch (homeWork.pageType) {
        case pageTypeNative: {
            UIViewController *vc = [[NSClassFromString([homeWork destVcClass]) alloc] init];
            vc.title = homeWork.gridTitle;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case pageTypeH5: {
            WKBaseWebViewController *webVc = [[WKBaseWebViewController alloc] initWithDesUrl:[NSString stringWithFormat:@"%@%@",homeWork.prefix,homeWork.destVcClass]];
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80.0f;
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
    /*if (section == 2) {
        return 64.0f;
    }*/
    if (section == 1) {
        return 64.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    /*if (section == 2) {
        WKLineFooterView *footerView = [WKLineFooterView footerView];
        return footerView;
    }*/
    if (section == 1) {
        WKLineFooterView *footerView = [WKLineFooterView footerView];
        return footerView;
    }
    return nil;
}

#pragma mark - WKNoticeSectionHeaderViewDelegate
- (void)headerViewDidClick:(WKNoticeSectionHeaderView *)headerView {
    LoadViewController *loadVc = [LoadViewController shareInstance];
    if (!loadVc.isLoaded) {
        loadVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loadVc animated:YES];
        return;
    }
    WKNoticeWebViewController *noticeVc = [[WKNoticeWebViewController alloc] init];
    noticeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVc animated:YES];
}

#pragma mark 移除观察者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
