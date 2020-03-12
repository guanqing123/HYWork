//
//  NoticePushViewController.m
//  HYWork
//
//  Created by information on 2017/12/7.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "WKPushViewController.h"
#import <WebKit/WebKit.h>

@interface WKPushViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak)  WKWebView *webView;
@property (nonatomic, copy) NSString *urlPath;
@end

@implementation WKPushViewController

- (instancetype)initWithUrlPath:(NSString *)urlPath {
    if (self = [super init]) {
        _urlPath = urlPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 2.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
//    WKWebView *webView = [[WKWebView alloc] init];
//    webView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    _webView = webView;
    [self.view addSubview:_webView];
    
//    if (@available(iOS 11.0,*)) {
//        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
//    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlPath]]];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        if (self.webView.loading) {[self.webView stopLoading];}
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //修改字体大小 300%
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.webView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end

