//
//  BrowseController.m
//  HYWork
//
//  Created by information on 16/5/31.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BrowseController.h"
#import "BrowseOneDepController.h"
#import "BrowseOtherDepController.h"
#import "LoadViewController.h"

@interface BrowseController ()<UIScrollViewDelegate,LoadViewControllerDelegate>

@property (nonatomic, strong)  BrowseOneDepController *oneDepVC;
@property (nonatomic, strong)  BrowseOtherDepController *otherDepVC;
@property (nonatomic, strong)  UISegmentedControl *segmentedControl;
@property (nonatomic, strong)  NSMutableArray *viewControllers;
@property (nonatomic, strong)  UIScrollView *backgroundScrollView;

@end

@implementation BrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSegmentedControl];
    
    [self loadControllers];
    
    [self loadScrollView];
    
    //设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.extendedLayoutIncludesOpaqueBars = NO;
}

#pragma mark - 初始化 segment
- (void)loadSegmentedControl{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"同部门",@"所有人",nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0,0,180,30);
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    /*UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  更新当前用户列表
 *
 *  @param btn 按钮
 */
/*- (void)refresh:(UIButton *)btn {
    [btn setBackgroundImage:[UIImage imageNamed:@"unrefresh"] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];
    NSInteger pageIndex = [_segmentedControl selectedSegmentIndex];
    if (pageIndex == 0) {
        [_oneDepVC requestOneDepDataWithBlock:^{
            [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    } else {
        [_otherDepVC refreshAllEmpsThroughSQLServerWithBlock:^{
            [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn setUserInteractionEnabled:YES];
        }];
    }
}*/
- (void)refresh {
    NSInteger pageIndex = [_segmentedControl selectedSegmentIndex];
    if (pageIndex == 0) {
        [_oneDepVC requestOneDepDataWithBlock:^{}];
    } else {
        [_otherDepVC refreshAllEmpsThroughSQLServerWithBlock:^{}];
    }
}

- (void)segmentedControlAction:(id)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    [self.backgroundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectedIndex, 0) animated:NO];
}

#pragma mark - 初始化子控制器
- (void)loadControllers {
    _viewControllers = [[NSMutableArray alloc] init];
    
    _oneDepVC = [[BrowseOneDepController alloc] init];
    _otherDepVC = [[BrowseOtherDepController alloc] init];
    
    [self addChildViewController:_oneDepVC];
    [self addChildViewController:_otherDepVC];
    
    _viewControllers = [NSMutableArray arrayWithObjects:_oneDepVC,_otherDepVC, nil];
    
}

#pragma mark - 初始化 UIScrollView
- (void)loadScrollView{
    NSInteger viewCounts = _viewControllers.count;
    //初始化最底部的scrollView,装tableView用
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
        UIViewController *listCtrl = self.viewControllers[i];
        listCtrl.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.backgroundScrollView.frame.size.height);
        [self.backgroundScrollView addSubview:listCtrl.view];
    }
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = (NSInteger)scrollView.contentOffset.x / SCREEN_WIDTH;
    [_segmentedControl setSelectedSegmentIndex:pageIndex];
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

@end
