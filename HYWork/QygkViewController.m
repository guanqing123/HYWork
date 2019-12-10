//
//  QygkViewController.m
//  HYWork
//
//  Created by information on 16/7/6.
//  Copyright © 2016年 hongyan. All rights reserved.
//  企业概况

#import <WebKit/WebKit.h>
#import "QygkViewController.h"
#import "GyhyManager.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

@interface QygkViewController () <WKNavigationDelegate>
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, copy) NSString *content;
@end

@implementation QygkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业概况";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(HWTopNavH, 0, 0, 0);//iPhoneX这里是88
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    [self setupHeaderRefresh];
    
    //[self getQygk];
}

- (void)back {
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeaderRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getQygk)];
    [self.tableView.mj_header beginRefreshing];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)getQygk {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    [GyhyManager getQygkWithUrl:url success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        if (data) {
            NSDictionary *list = [data objectForKey:@"list"];
            self.content = [list objectForKey:@"content"];
            [self.webView loadHTMLString:_content baseURL:nil];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } fail:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - tableView dateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [cell.contentView addSubview:self.webView];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT - HWTopNavH;
}

#pragma mark - WK
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
