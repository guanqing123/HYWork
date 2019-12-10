//
//  OAViewController.m
//  HYWork
//
//  Created by information on 16/7/18.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "OAViewController.h"
#import "FjViewController.h"
#import "LoadViewController.h"

@interface OAViewController () <WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, strong)  UIWebView *web;
@property (nonatomic, copy) NSString *url;
@end

@implementation OAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *lflexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *OAhomeItem = [[UIBarButtonItem alloc] initWithTitle:@"OA首页" style:UIBarButtonItemStyleDone target:self action:@selector(OAHome)];
    UIBarButtonItem *rflexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[leftItem,lflexItem,OAhomeItem,rflexItem];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭OA" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    // 设置view不要延伸
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //_webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH)];
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    
    //_web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //[self.view addSubview:_web];
    
    LoadViewController *loadVC = [LoadViewController shareInstance];
    NSString *userid = loadVC.emp.ecologyid;
    NSString *url = [NSString stringWithFormat:@"%@/web/ecology?userid=%@",OAURL,userid];
    _url = url;
    //[_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)OAHome {
    if (self.webView.loading) {[self.webView stopLoading];}
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        if (self.webView.loading) {[self.webView stopLoading];}
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close {
    if (self.webView.loading) {[self.webView stopLoading];}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSRange range = [[navigationAction.request.URL absoluteString] rangeOfString:@"viewDoc?docid"];
    if (range.location != NSNotFound) {
        FjViewController *fjVc = [[FjViewController alloc] initWithRequest:navigationAction.request Configuration:webView.configuration];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fjVc];
        [self presentViewController:nav animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
    FjViewController *fjVc = [[FjViewController alloc] initWithRequest:navigationAction.request Configuration:configuration];
   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fjVc  ];
    [self presentViewController:nav animated:YES completion:nil];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    alertVc.view.backgroundColor = [UIColor whiteColor];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertVc animated:YES completion:^{}];
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

- (void)dealloc {
    self.webView.navigationDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
