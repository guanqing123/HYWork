//
//  UITabBarController.m
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "TabBarController.h"
#import "WKHomeViewController.h"
//#import "ViewController.h"
#import "WKLearnViewController.h"
//#import "TxlViewController.h"
#import "WKHyShopViewController.h"
#import "GNViewController.h"
#import "MyViewController.h"
#import "NavigationController.h"

@interface  TabBarController()
@property (strong, nonatomic)  NSMutableArray *tabs;
@end

@implementation TabBarController

/**
 *  view加载完毕
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    _tabs = [NSMutableArray array];
    [self initIndexNavigation];
    [self initLearnNavigation];
//    [self initTxlNavigation];
    [self initHyShop];
//    [self initGnNavigation];
    [self initMyNavigation];
    self.viewControllers = _tabs;
    [self initTabBarStatus];
}

/**
 *  初始化首页Nav
 */
- (void)initIndexNavigation{
    _homeVc = [[WKHomeViewController alloc] init];
    _homeVc.view.backgroundColor = [UIColor whiteColor];
    //_viewController.title = @"HONYAR 鸿雁";
    UIImage *image = [UIImage imageNamed:@"honyar_logo"];
    UIImageView *new = [[UIImageView alloc] initWithImage:image];
    _homeVc.navigationItem.titleView = new;
    NavigationController *indexNav = [[NavigationController alloc] initWithRootViewController:_homeVc];

    /** 单独设置每个导航的属性
    indexNav.navigationBar.tintColor = [UIColor whiteColor];
    indexNav.navigationBar.translucent = YES;
    indexNav.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
    [indexNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
     */
    [_tabs addObject:indexNav];
    indexNav.tabBarItem.title = @"首 页";
    indexNav.tabBarItem.tag = TabBarItemTypeIndex;
}

- (void)initLearnNavigation{
    _learnVc = [[WKLearnViewController alloc] init];
    _learnVc.view.backgroundColor = [UIColor whiteColor];
    _learnVc.navigationItem.title = @"学习";
    NavigationController *learnNav = [[NavigationController alloc] initWithRootViewController:_learnVc];
    learnNav.tabBarItem.title = @"学习";
    learnNav.tabBarItem.tag = TabBarItemTypeLearning;
    [_tabs addObject:learnNav];
}

- (void)initHyShop {
    _hyshopVc = [[WKHyShopViewController alloc] init];
    _hyshopVc.view.backgroundColor = [UIColor whiteColor];
    _hyshopVc.navigationItem.title = @"鸿雁商城";
    NavigationController *hyshopNav = [[NavigationController alloc] initWithRootViewController:_hyshopVc];
    hyshopNav.tabBarItem.title = @"鸿雁商城";
    hyshopNav.tabBarItem.tag = TabBarItemTypeHyshop;
    [_tabs addObject:hyshopNav];
}

/*- (void)initTxlNavigation{
    _txlController = [[TxlViewController alloc] init];
    _txlController.view.backgroundColor = [UIColor whiteColor];
    _txlController.navigationItem.title = @"通讯录";
    NavigationController *txlNav = [[NavigationController alloc] initWithRootViewController:_txlController];
    txlNav.tabBarItem.title = @"通讯录";
    txlNav.tabBarItem.tag = TabBarItemTypeAddressList;
    [_tabs addObject:txlNav];
}*/

/**
 *  初始化功能Nav
 */
- (void)initGnNavigation{
    _gnViewController = [[GNViewController alloc] init];
    _gnViewController.view.backgroundColor = [UIColor whiteColor];
    _gnViewController.navigationItem.title = @"功 能";
    NavigationController *funcNav = [[NavigationController alloc] initWithRootViewController:_gnViewController];
    funcNav.tabBarItem.title = @"功 能";
    funcNav.tabBarItem.tag = TabBarItemTypeFunction;
    [_tabs addObject:funcNav];
}

/**
 *  初始化我的Nav
 */
- (void)initMyNavigation{
    _myViewController = [[MyViewController alloc] init];
    _myViewController.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"honyar_logo"];
    UIImageView *new = [[UIImageView alloc] initWithImage:image];
    _myViewController.navigationItem.titleView = new;
    NavigationController *myNav = [[NavigationController alloc] initWithRootViewController:_myViewController];
    myNav.tabBarItem.title = @"我 的";
    myNav.tabBarItem.tag = TabBarItemTypeMe;
    [_tabs addObject:myNav];
    //[self addChildViewController:myNav];
}

/**
 *  初始化tabbar其他的样式
 */
- (void)initTabBarStatus{
    /**
     *  设置TabBar的状态
     */
    self.tabBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
    NSArray *items = self.tabBar.items;
    /**
     *  UIImageRenderingModeAlwaysOriginal:这个枚举值是声明这张图片要按照原来的样子显示,不需要渲染成其他颜色
     */
    for (int i = 0; i < items.count; i++) {
        UITabBarItem *item = [items objectAtIndex:i];
        //item.badgeValue = [NSString stringWithFormat:@"%d",10];
        [item setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tab%d",i+1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tab%d-%d",i+1, i+1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    //ios12.1 适配
//    [self.tabBar setTranslucent:NO];
    
    // 有消息显示的小红点
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width * 1/ 8, 0.5f, 10, 10)];
//    button.backgroundColor = [UIColor redColor];
//    [button.layer masksToBounds];
//    [button.layer setCornerRadius:5];
//    [self.tabBar addSubview:button];
}

#pragma mark -屏幕旋转设置
- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

/**
 *  view即将显示到window上
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/**
 *  view显示完毕(已经显示到窗口)
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/**
 *  view即将从window上移除(即将看不见)
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

/**
 *  view从window上完全移除(完全看不见)
 */
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

/**
 *  view即将销毁的时候调用
 */
- (void)viewWillUnload{
    [super viewWillUnload];
}

/**
 *  view销毁完毕的时候调用
 */
- (void)viewDidUnload{
    [super viewDidUnload];
}

/**
 *  当接收到内存警告的时候
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
