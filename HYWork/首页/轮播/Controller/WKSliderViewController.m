//
//  WKSliderViewController.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKSliderViewController.h"
#import "WKSliderDetailViewController.h"
#import "WKSliderListViewController.h"

@interface WKSliderViewController ()

// 切换组
@property (nonatomic, weak) UISegmentedControl  *segmentedControl;
// 控制器组
@property (nonatomic, strong)  NSMutableArray *controllers;
// 轮播详情
@property (nonatomic, strong)  WKSliderDetailViewController *sliderDetailVc;
// 轮播列表
@property (nonatomic, strong)  WKSliderListViewController *sliderListVc;
// 底部滑动页面
@property (nonatomic, strong)  UIScrollView *backgroundScrollView;
// 详情ID
@property (nonatomic, copy) NSString *idStr;

@end

@implementation WKSliderViewController

#pragma mark - init
- (instancetype)initWithIdStr:(NSString *)idStr {
    if (self = [super init]) {
        _idStr = idStr;
    }
    return self;
}

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
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"详情展示",@"往期回顾",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    segmentedControl.frame = CGRectMake(0, 0, 180, 30);
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;
    
    // 3.leftItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];

    // 4.设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

// 组切换
- (void)segmentedControlAction:(id)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    [self.backgroundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectedIndex, 0) animated:NO];
}

// 回退
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化子控制器
- (void)setupControllers {
    _controllers = [[NSMutableArray alloc] init];
    
    _sliderDetailVc = [[WKSliderDetailViewController alloc] initWithIdStr:_idStr];
    _sliderListVc = [[WKSliderListViewController alloc] init];
    
    [self addChildViewController:_sliderDetailVc];
    [self addChildViewController:_sliderListVc];
    
    _controllers = [NSMutableArray arrayWithObjects:_sliderDetailVc, _sliderListVc, nil];
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
