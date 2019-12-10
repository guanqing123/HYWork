//
//  TxlViewController.m
//  HYWork
//
//  Created by information on 16/3/1.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "TxlViewController.h"
#import "PickOneDepController.h"
#import "PickOtherDepController.h"
#import "SearchEmpController.h"
#import "LoadViewController.h"

#import "NavigationController.h"

@interface TxlViewController ()<UIScrollViewDelegate,LoadViewControllerDelegate>

@property (nonatomic, strong)  PickOneDepController *oneDepVC;
@property (nonatomic, strong)  PickOtherDepController *otherDepVC;
@property (nonatomic, strong)  UISegmentedControl *segmentedControl;
@property (nonatomic, strong)  NSMutableArray *viewControllers;
@property (nonatomic, strong)  UIScrollView *backgroundScrollView;

@end

@implementation TxlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self loadSegmentedControl];
    
    [self loadControllers];
    
    [self loadScrollView];
    
    //设置不延伸到导航栏的区域
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SearchBarHeight);
    [btn addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar addSubview:btn];
    [self.view addSubview:mySearchBar];
//          UIView *unLoadView = [[UIView alloc] initWithFrame:self.view.bounds];
//          [self.view addSubview:unLoadView];
//
//          UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, self.view.frame.size.height / 2 - 10.0f, self.view.frame.size.width - 40.0f, 20.0f)];
//          label.text = @"登录后,方可使用通讯录功能";
//          label.textAlignment = NSTextAlignmentCenter;
//          label.textColor = [UIColor grayColor];
//          label.font = [UIFont systemFontOfSize:15.0f];
//          [unLoadView addSubview:label];
//      
//          UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50.0f, label.frame.origin.y + 40.0f, 100.0f, 30.0f)];
//          [loadButton setTitle:@"登 录" forState:UIControlStateNormal];
//          [loadButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//          loadButton.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
//          [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//          [loadButton.layer setMasksToBounds:YES];
//          [loadButton.layer setCornerRadius:15.0f];
//          [unLoadView addSubview:loadButton];

}

//- (void)loadViewControllerFinishLogin:(LoadViewController *)loadViewController {
//    [self viewDidLoad];
//}
//
//- (void)login {
//    LoadViewController *loadViewController = [LoadViewController shareInstance];
//    loadViewController.delegate = self;
//    loadViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loadViewController animated:YES];
//}

- (void)pushSearchViewController {
    SearchEmpController *searchVC = [[SearchEmpController alloc] init];
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            searchVC.citiesDic = [_oneDepVC.citiesDic copy];
            break;
        default:
            searchVC.citiesDic = [_otherDepVC.citiesDic copy];
            break;
    }
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; //设置动画效果
    
    [self presentViewController:nav animated:YES completion:^{}];
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = right;
}

/**
 *  更新当前用户列表
 *
 *  @param btn 按钮
 */
- (void)refresh:(UIButton *)btn {
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
}

- (void)segmentedControlAction:(id)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    [self.backgroundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectedIndex, 0) animated:NO];
}

#pragma mark - 初始化子控制器
- (void)loadControllers {
    _viewControllers = [[NSMutableArray alloc] init];
    
    _oneDepVC = [[PickOneDepController alloc] init];
    _otherDepVC = [[PickOtherDepController alloc] init];
    
    [self addChildViewController:_oneDepVC];
    [self addChildViewController:_otherDepVC];
    
    _viewControllers = [NSMutableArray arrayWithObjects:_oneDepVC,_otherDepVC, nil];
    
}

#pragma mark - 初始化 UIScrollView
- (void)loadScrollView{
    
    NSInteger viewCounts = _viewControllers.count;
    
    //初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = (id<UIScrollViewDelegate>)self;
    self.backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * viewCounts, 0);
    [self.view addSubview:self.backgroundScrollView];
    
    for (int i = 0; i < viewCounts; i++) {
        UIViewController *listCtrl = self.viewControllers[i];
        listCtrl.view.frame = CGRectMake(SCREEN_WIDTH * i, SearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
