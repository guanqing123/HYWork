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

//controllers
#import "WKSliderViewController.h"

//tool
#import "Utils.h"

@interface WKHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView  *tableView;

@end

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
    // 1.tableView
    [self setupTableView];
    
    // 2.headerView
    [self setupHeaderView];
}

#pragma mark - setupHeaderView
- (void)setupHeaderView {
    WKSliderHeaderView *headerView = [WKSliderHeaderView headerView];
    headerView.frame = (CGRect){CGPointZero, CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 2 / 3)};
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
    UITableView *tableView = [[UITableView alloc] init];
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
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
