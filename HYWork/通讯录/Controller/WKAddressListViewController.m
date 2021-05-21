//
//  WKAddressListViewController.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKAddressListViewController.h"
// 常用组 / 所有人
#import "WKCommonGroupViewController.h"
#import "WKAllEmpViewController.h"

#import "SearchEmpController.h"
#import "NavigationController.h"

@interface WKAddressListViewController ()

// 切换组
@property (nonatomic, weak) UISegmentedControl  *segmentedControl;
// 控制器组
@property (nonatomic, strong)  NSMutableArray *controllers;
// 常用组
@property (nonatomic, strong)  WKCommonGroupViewController *commonVc;
// 所有人
@property (nonatomic, strong)  WKAllEmpViewController *allVc;
// 底部滑动页面
@property (nonatomic, strong)  UIScrollView *backgroundScrollView;

@end

@implementation WKAddressListViewController

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
    /*UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    // 5.设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 搜索
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SearchBarHeight)];
    mySearchBar.placeholder = @"关键字搜索";
    mySearchBar.userInteractionEnabled = YES;
    mySearchBar.backgroundImage = [UIImage imageNamed:@"searchBarBackImage"];
    
    if (@available(iOS 13.0,*)) {
        mySearchBar.searchTextField.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    } else {
        UITextField *txfSearchField = [mySearchBar valueForKey:@"_searchField"];
        txfSearchField.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    }
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SearchBarHeight);
    [searchBtn addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar addSubview:searchBtn];
    [self.view addSubview:mySearchBar];
}

- (void)pushSearchViewController {
    SearchEmpController *searchVC = [[SearchEmpController alloc] init];
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            searchVC.citiesDic = [_commonVc.commonDict copy];
            break;
        default:
            searchVC.citiesDic = [_allVc.commonDict copy];
            break;
    }
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; //设置动画效果
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:nav animated:YES completion:^{}];
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

// 刷新右上角人员
/*- (void)refresh:(UIButton *)btn {
    //[btn setBackgroundImage:[UIImage imageNamed:@"unrefresh"] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];
    NSInteger pageIndex = [_segmentedControl selectedSegmentIndex];
    if (pageIndex == 0) {
        [_commonVc requestCommonGroupDataWithBlock:^{
            //[btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    } else {
        [_allVc requestAllEmpsThroughSQLServerWithBlock:^{
            //[btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    }
}*/
- (void)refresh {
    NSInteger pageIndex = [_segmentedControl selectedSegmentIndex];
    if (pageIndex == 0) {
        [_commonVc requestCommonGroupDataWithBlock:^{}];
    } else {
        [_allVc requestAllEmpsThroughSQLServerWithBlock:^{}];
    }
}

#pragma mark - 初始化子控制器
- (void)setupControllers {
    _controllers = [[NSMutableArray alloc] init];
    
    _commonVc = [[WKCommonGroupViewController alloc] init];
    _allVc = [[WKAllEmpViewController alloc] init];
    
    [self addChildViewController:_commonVc];
    [self addChildViewController:_allVc];
    
    _controllers = [NSMutableArray arrayWithObjects:_commonVc, _allVc, nil];
}

#pragma mark - 初始化 UIScrollView
- (void)setupScrollView {
    NSInteger viewCounts = _controllers.count;
    // 初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.frame = CGRectMake(0, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH - SearchBarHeight);
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
