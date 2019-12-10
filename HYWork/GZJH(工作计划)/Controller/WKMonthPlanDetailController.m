//
//  WKMonthPlanDetailController.m
//  HYWork
//
//  Created by information on 2019/8/27.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthPlanDetailController.h"
#import "LoadViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "LYConstans.h"
#import <WebKit/WebKit.h>

@interface WKMonthPlanDetailController () <WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) WKWebView  *webView;
@property (nonatomic, copy) NSString *xh;
@property (nonatomic, copy) NSString *sonPlan;
@property (nonatomic, copy) NSString *ygbm;
@property (nonatomic, copy) NSString *ygxm;
@property (nonatomic, strong)  WKWebViewJavascriptBridge *bridge;
@end

@implementation WKMonthPlanDetailController

- (instancetype)initWithXh:(NSString *)xh {
    if (self = [super init]) {
        _xh = xh;
        self.title = @"详细月计划";
    }
    return self;
}

- (instancetype)initWithXh:(NSString *)xh sonPlan:(NSString *)sonPlan {
    if (self = [super init]) {
        _xh = xh;
        _sonPlan = sonPlan;
        self.title = @"新建行动方案";
    }
    return self;
}

- (NSString *)ygbm {
    if (_ygbm == nil) {
        _ygbm = [LoadViewController shareInstance].emp.ygbm;
    }
    return _ygbm;
}

- (NSString *)ygxm {
    if (_ygxm == nil) {
        _ygxm = [LoadViewController shareInstance].emp.ygxm;
    }
    return _ygxm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.view.bounds;
    
    //写代理
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    _webView = webView;
    [self.view addSubview:webView];
    
    //开启调试信息
    //    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    //设置代理
    [self.bridge setWebViewDelegate:self];
    WEAKSELF
    [self.bridge registerHandler:@"WKMonthPlanRefreshing" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMonthPlanRefreshing object:nil userInfo:nil];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    NSString *urlStr = @"";
    if ([self.sonPlan isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"http://dev.sge.cn/hyamd/message/list.html?ygbm=%@&ygxm=%@&xh=%@&sonPlan=1",self.ygbm,self.ygxm,self.xh];
    } else {
        urlStr = [NSString stringWithFormat:@"http://dev.sge.cn/hyamd/message/list.html?ygbm=%@&ygxm=%@&xh=%@",self.ygbm,self.ygxm,self.xh];
    }
    NSString *encode = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encode]]];
    
    // 1.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
