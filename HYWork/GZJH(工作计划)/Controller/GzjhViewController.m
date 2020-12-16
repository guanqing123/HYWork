//
//  GzjhViewController.m
//  HYWork
//
//  Created by information on 16/5/16.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "GzjhViewController.h"
#import "GzjhMenuView.h"
#import "WeekPlanController.h"
#import "MonthPlanController.h"
#import "WKMonthViewController.h"
#import "LYConstans.h"
#import "GzjhManager.h"
#import "LoadViewController.h"
#import "ZjxsCheckView.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"

@interface GzjhViewController () <UIScrollViewDelegate,ZjxsCheckViewDelegate>
@property (nonatomic, strong)  WeekPlanController *weekVC;
@property (nonatomic, strong)  MonthPlanController *monthVC;
@property (nonatomic, strong)  WKMonthViewController *wkmonthVC;
@property (nonatomic, strong)  NSMutableArray *viewControllers;
@property (nonatomic, strong)  UIScrollView *backgroundScrollView;
@property (nonatomic, copy) NSString *ygbm;
@property (nonatomic, copy) NSString *xzzj;
@property (nonatomic, copy) NSString *current;
@property (nonatomic, strong) ZjxsCheckView  *zjxsView;
@property (nonatomic, assign) int selectIndex;
@property (assign, nonatomic) BOOL isAppeared;
@property (nonatomic, strong)  NSArray *zjxs;
@end

@implementation GzjhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shanxuan"] style:UIBarButtonItemStyleDone target:self action:@selector(shanxuan)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = @"我的工作计划";
    self.xzzj = [LoadViewController shareInstance].emp.xzzj;
    
    _isAppeared = NO;
    _current = self.ygbm;
    
    [self loadMenuView];
    
    [self loadControllers];
    
    [self loadScrollView];
    
    [self loadZjgx];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gzjhMenuBtnClick:) name:kGzjhMenuBtnClick object:nil];
}

- (void)back {
    if (self.pop) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shanxuan {
    if (self.zjxs.count < 1) {
        [self loadZjgx];
        [MBProgressHUD showError:@"正在加载直接下属/或无直接下属"];
        return;
    }
    if (_zjxsView == nil) {
        _zjxsView = [[ZjxsCheckView alloc] initWithFrame:CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) zjxs:self.zjxs ygbm:self.ygbm ygxm:@"我的计划" current:self.current];
        _zjxsView.backgroundColor = [UIColor lightGrayColor];
        _zjxsView.delegate = self;
        [self.view addSubview:_zjxsView];
    }
    if (!_isAppeared) {
        [UIView animateWithDuration:0.5 animations:^{
            _zjxsView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
            _zjxsView.current = self.current;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _zjxsView.frame = CGRectMake(0, - (SCREEN_HEIGHT - HWTopNavH), SCREEN_WIDTH, (SCREEN_HEIGHT - HWTopNavH));
        }];
    }
    _isAppeared = !_isAppeared;
}

- (void)zjxsCheckView:(ZjxsCheckView *)zjxsCheckView didClickCell:(ZJXS *)zjxs {
    _current = zjxs.ygbm;
    self.title = [NSString stringWithFormat:@"%@的工作计划",zjxs.ygxm];
    [self shanxuan];
    [[NSNotificationCenter defaultCenter] postNotificationName:kZjxsCheckCellClick object:nil userInfo:@{kZjxsCheckCellClick : zjxs}];
}

- (void)loadMenuView {
    GzjhMenuView *menuView = [[GzjhMenuView alloc] init];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, GzjhMenuHeight);
    [self.view addSubview:menuView];
}

- (void)loadControllers {
    
    _viewControllers = [[NSMutableArray alloc] init];
    if ([self.xzzj intValue] > 2) { // 三级以上经理
        _weekVC = [[WeekPlanController alloc] init];
        _wkmonthVC = [[WKMonthViewController alloc] init];
        
        [self addChildViewController:_weekVC];
        [self addChildViewController:_wkmonthVC];
        
        _viewControllers = [NSMutableArray arrayWithObjects:_weekVC , _wkmonthVC, nil];
    }else{
        _weekVC = [[WeekPlanController alloc] init];
        _monthVC = [[MonthPlanController alloc] init];
    
        [self addChildViewController:_weekVC];
        [self addChildViewController:_monthVC];
    
        _viewControllers = [NSMutableArray arrayWithObjects:_weekVC , _monthVC, nil];
    }
}

- (void)loadScrollView {
    
    NSInteger viewCounts = _viewControllers.count;
    
    //初始化最底部的scrollView,装tableView用
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HWTopNavH + GzjhMenuHeight, SCREEN_WIDTH, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH)];
    //self.backgroundScrollView.backgroundColor = GQColor(244.0f, 244.0f, 244.0f);
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = (id<UIScrollViewDelegate>)self;
    self.backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * viewCounts, 0);
    [self.view addSubview:self.backgroundScrollView];
    
    for (int i = 0; i < viewCounts; i++) {
        UIViewController *listCtrl = self.viewControllers[i];
        listCtrl.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - GzjhMenuHeight - HWTopNavH);
        [self.backgroundScrollView addSubview:listCtrl.view];
    }
    
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - 员工编码懒加载
- (NSString *)ygbm {
    if (_ygbm == nil) {
        LoadViewController *loadVc = [LoadViewController shareInstance];
        _ygbm = loadVc.emp.ygbm;
    }
    return _ygbm;
}

- (void)loadZjgx {
    /*NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gh"] = self.ygbm;
    __weak typeof(self) weakSelf = self;
    [GzjhManager getZjgxWithParams:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSDictionary *data = [json objectForKey:@"data"];
            NSArray *sjld = [GzjhManager sjldListToModel:[data objectForKey:@"sjld"]];
            NSArray *zjxs = [GzjhManager zjxsListToModel:[data objectForKey:@"zjxs"]];
            [weakSelf setSjld:sjld zjxs:zjxs];
        }
    } failure:^{
        [MBProgressHUD showError:@"网络异常"];
    }];*/
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ygbm"] = self.ygbm;
    __weak typeof(self) weakSelf = self;
    [GzjhManager getNewZjgxWithParams:params success:^(WKRankRelationshipResult *result) {
        if ([result.code isEqualToString:@"200"]) {
            [weakSelf setSjld:result.rankRelationship.sjld zjxs:result.rankRelationship.zjxs];
        }else{
            [MBProgressHUD showError:result.message];
        }
    } failure:^{
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)setSjld:(NSArray *)sjld zjxs:(NSArray *)zjxs {
    _zjxs = zjxs;
    self.weekVC.sjld = sjld;
    self.weekVC.zjxs = zjxs;
    if ([self.xzzj intValue] > 2) {
        self.wkmonthVC.sjld = sjld;
        self.wkmonthVC.zjxs = zjxs;
    }else{
        self.monthVC.sjld = sjld;
        self.monthVC.zjxs = zjxs;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _selectIndex = (int)pageIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGzjhScrollViewMove object:nil userInfo:@{kGzjhScrollViewMove : [NSString stringWithFormat:@"%ld",(long)pageIndex]}];
}

#pragma mark - gzjhMenuBtnClickNote
- (void)gzjhMenuBtnClick:(NSNotification *)note {
    NSString *indexNum = note.userInfo[kGzjhMenuBtnClick];
    _selectIndex = [indexNum intValue];
    [self.backgroundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * [indexNum intValue], 0) animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
