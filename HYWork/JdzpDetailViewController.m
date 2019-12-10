//
//  JdzpDetailViewController.m
//  HYWork
//
//  Created by information on 16/6/30.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "JdzpDetailViewController.h"

@interface JdzpDetailViewController () <WKNavigationDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong)  WKWebView *webView;
@end

@implementation JdzpDetailViewController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    WKWebView *webView = [[WKWebView alloc] init];
    webView.navigationDelegate = self;
    webView.frame = self.view.bounds;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [webView sizeToFit];
    [webView loadRequest:request];
    _webView = webView;
    [self.view addSubview:webView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationDelegate
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

@end
