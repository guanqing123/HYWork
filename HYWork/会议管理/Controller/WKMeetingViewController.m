//
//  WKMeetingViewController.m
//  HYWork
//
//  Created by information on 2019/8/3.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKMeetingViewController.h"
#import "LoadViewController.h"

#import "BeforeScanSingleton.h"
#import "WKBaseWebViewController.h"

@interface WKMeetingViewController () <WKUIDelegate,WKNavigationDelegate,SubLBXScanViewControllerDelegate>
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, copy) NSURL *currentUrl;
@end

@implementation WKMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 2.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    // 3.扫一扫
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStyleDone target:self action:@selector(scan)];
    self.navigationItem.rightBarButtonItem = right;
    
//    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH)];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    
//    if (@available(iOS 11.0,*)) {
//        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
//    }
    
    LoadViewController *loadVC = [LoadViewController shareInstance];
    NSString *userid = loadVC.emp.ygbm;
    NSString *url = [NSString stringWithFormat:@"https://wx.hongyancloud.com/isv/meeting/?ygbm=%@",userid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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

//扫一扫
- (void)scan {
    [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
}

#pragma mark -扫一扫代理
- (void)subLBXScanViewController:(SubLBXScanViewController *)subLBXScanViewController resultStr:(NSString *)result {
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if ([result hasPrefix:@"http"] || [result hasPrefix:@"https"]) {
            WKBaseWebViewController *webVc = [[WKBaseWebViewController alloc] initWithDesUrl:result];
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
        } else {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"扫码结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
            [alertVc addAction:okAction];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    });
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
    NSLog(@"navigationAction.request.URL = %@",navigationAction.request.URL);
    NSString *destUrl = [navigationAction.request.URL absoluteString];
    NSRange range = [destUrl rangeOfString:@"meeting/meetingDetail.html?hyid="];
    NSRange srange = [destUrl rangeOfString:@"&ygbm"];
    if (range.location != NSNotFound && srange.location == NSNotFound) {
        if(![destUrl isEqualToString:[NSString stringWithFormat:@"%@", self.currentUrl]]){
            LoadViewController *loadVC = [LoadViewController shareInstance];
            NSString *newUrl = [destUrl stringByAppendingString:[NSString stringWithFormat:@"&ygbm=%@",loadVC.emp.ygbm]];
            NSLog(@"destUrl = %@,newUrl = %@",destUrl,newUrl);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl]];
            [webView loadRequest:request];
            self.currentUrl = [NSURL URLWithString:newUrl];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else{
            self.currentUrl = [NSURL URLWithString:destUrl];
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
    } else{
        self.currentUrl = [NSURL URLWithString:destUrl];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.webView.frame = CGRectMake(0, 0, size.width, size.height);
}


@end
