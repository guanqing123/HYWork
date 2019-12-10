//
//  BxViewController.m
//  HYWork
//
//  Created by information on 16/4/26.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BxViewController.h"
#import "BXGroup.h"
#import "BXItem.h"
#import "BXHeaderView.h"
#import "BXViewCell.h"
#import "LoadViewController.h"
#import "BXManager.h"
#import "Utils.h"
#import "MBProgressHUD+MJ.h"
#import "BxWebViewController.h"
#import "MJRefresh.h"

@interface BxViewController ()<UIWebViewDelegate,BXHeaderViewDelegate,BxWebViewControllerDelegate>
{
    UIView *_warningView;
}
@property (nonatomic, weak) UIWebView  *webView;

@property (nonatomic, copy) NSString *ecology_id;

@property (nonatomic, strong)  NSArray *groups;

@property (nonatomic, assign) BOOL *flag;


@end

@implementation BxViewController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self initWarningLabel];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);//iPhoneX这里是88
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    [self setupHeaderRefresh];
}

/**
 *  初始化界面
 */
- (void)initUI {
    // 每一行cell的高度
    self.tableView.rowHeight = 50;
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = 44;
    
    // 返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (NSString *)ecology_id {
    if (_ecology_id == nil) {
        LoadViewController *loadController = [LoadViewController shareInstance];
        _ecology_id = loadController.emp.ecologyid;
    }
    return _ecology_id;
}

- (void)initWarningLabel {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *warningL = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, (SCREEN_HEIGHT - 40)/2 - 64, 100, 40)];
    warningL.text = @"无报销";
    warningL.font = [UIFont systemFontOfSize:25];
    warningL.textColor = [UIColor grayColor];
    [bgView addSubview:warningL];
    [self.view addSubview:bgView];
    _warningView = bgView;
    _warningView.hidden = YES;
}

/**
 *  设置下拉刷新
 */
- (void)setupHeaderRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  获取查询数据
 */
- (void)initData {
    if (self.ecology_id == nil) {
        [MBProgressHUD showError:@"未登陆"];
        return;
    }
    _warningView.hidden = YES;
    [BXManager getBxListWithEcologyid:self.ecology_id Success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            NSArray *data = [json objectForKey:@"data"];
            self.groups = [[BXManager getBxListWithArray:data] copy];
            if (self.groups.count > 0) {
                _warningView.hidden = YES;
            }else{
                _warningView.hidden = NO;
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } Fail:^{
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    //self.webView.delegate = nil;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BXGroup *group = self.groups[section];
    return (group.isOpened ? group.items.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    BXViewCell *cell = [BXViewCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    BXGroup *group = self.groups[indexPath.section];
    cell.bxItem = group.items[indexPath.row];
    
    // 3.返回cell
    return cell;
}

#pragma mark - 代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 1.创建头部控件
    BXHeaderView *header = [BXHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    // 2.给header设置数据(给header传递模型)
    header.group = self.groups[section];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXGroup *group = self.groups[indexPath.section];
    BXItem *item = group.items[indexPath.row];
    
    BxWebViewController *bxWebVc = [[BxWebViewController alloc] initWithBXItem:item];
    bxWebVc.delegate = self;
   [self.navigationController pushViewController:bxWebVc animated:YES];
    
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    //self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; //设置动画效果
    
    //[self presentViewController:bxWebVc animated:YES completion:^{}];
}

#pragma mark - BxWebViewControllerDelegate
- (void)bxWebViewControllerGoBackAndRefresh:(BxWebViewController *)bxWebVc {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidClickedNameView:(BXHeaderView *)headerView {
    [self.tableView reloadData];
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

/**
 *   初始化webView
 */
- (void)initWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.delegate = self;
    _webView = webView;
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"http://172.30.8.37:8080/x5/UI2/v_/demo/tuniu/index.w?device"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
