//
//  WKMonthPlanCheckController.m
//  HYWork
//
//  Created by information on 2019/8/27.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMonthPlanCheckController.h"
#import "WKWebViewJavascriptBridge.h"
#import "LYConstans.h"
#import <WebKit/WebKit.h>

@interface WKMonthPlanCheckController () <WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) WKWebView  *webView;
@property (nonatomic, copy) NSString *xh;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, strong)  WKWebViewJavascriptBridge *bridge;
@end

@implementation WKMonthPlanCheckController

- (instancetype)initWithXh:(NSString *)xh owner:(BOOL)owner{
    if (self = [super init]) {
        _xh = xh;
        if (owner) {
            _owner = @"1";
        }else{
            _owner = @"0";
        }
        self.title = @"点检月计划";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.view.bounds;
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
    
    NSString *urlStr = [NSString stringWithFormat:@"http://dev.sge.cn/hyamd/message/list_dj.html?xh=%@&owner=%@",self.xh, self.owner];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
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
