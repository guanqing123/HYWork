//
//  WKBrowseViewController.m
//  HYWork
//
//  Created by information on 2018/5/19.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKBrowseViewController.h"
#import "WKBrowseCommonViewController.h"
#import "WKBrowseAllViewController.h"
#import "LYConstans.h"
#import "LoadViewController.h"

@interface WKBrowseViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UISegmentedControl  *segmentedControl;

@property (nonatomic, strong)  NSMutableArray *controllers;

@property (nonatomic, strong)  WKBrowseCommonViewController *commonVc;
@property (nonatomic, strong)  WKBrowseAllViewController *allVc;

@property (nonatomic, strong)  UIScrollView *backgroundScrollView;

@end

@implementation WKBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置导航栏
    [self setupNavBar];
    
    // 2.初始化子控制器
    [self setupControllers];
    
    // 3.初始化 UIScrollView
    [self setupScrollView];
}

#pragma mark - 设置导航栏
- (void)setupNavBar {
    // 1.背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.title
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"常用组",@"所有人",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    segmentedControl.frame = CGRectMake(0,0,180,30);
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;
    
    // 3.leftItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    // 4.rightItem
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
    
    // 5.设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)segmentedControlAction:(id)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    [self.backgroundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectedIndex, 0) animated:NO];
}

- (void)back {
    LoadViewController *loadVc = [LoadViewController shareInstance];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[loadVc.emp.ygbm,loadVc.emp.ygxm] forKeys:@[@"ygbm",@"ygxm"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:rjhBrowseCellClick object:nil userInfo:@{rjhBrowseCellClick : dict}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:@"unrefresh"] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];
    NSInteger pageIndex = [_segmentedControl selectedSegmentIndex];
    if (pageIndex == 0) {
        [_commonVc requestOneDepDataWithBlock:^{
            [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    } else {
        [_allVc refreshAllEmpsThroughSQLServerWithBlock:^{
            [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    }
}


#pragma mark - 初始化子控制器
- (void)setupControllers {
    _controllers = [[NSMutableArray alloc] init];
    
    _commonVc = [[WKBrowseCommonViewController alloc] init];
    _allVc = [[WKBrowseAllViewController alloc] init];
    
    [self addChildViewController:_commonVc];
    [self addChildViewController:_allVc];
    
    _controllers = [NSMutableArray arrayWithObjects:_commonVc, _allVc, nil];
}

#pragma mark - 初始化 UIScrollView
- (void)setupScrollView {
    NSInteger viewCounts = _controllers.count;
    // 初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = (id<UIScrollViewDelegate>)self;
    self.backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * viewCounts, 0);
    [self.view addSubview:self.backgroundScrollView];
    
    for (int i = 0; i < viewCounts; i++) {
        UIViewController *listCtrl = self.controllers[i];
        listCtrl.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.backgroundScrollView.dc_height);
        [self.backgroundScrollView addSubview:listCtrl.view];
    }
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = (NSInteger)scrollView.contentOffset.x / SCREEN_WIDTH;
    [_segmentedControl setSelectedSegmentIndex:pageIndex];
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
