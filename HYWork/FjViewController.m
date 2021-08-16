//
//  FjViewController.m
//  HYWork
//
//  Created by information on 16/8/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "FjViewController.h"

@interface FjViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, strong)  NSURLRequest *request;
@property (nonatomic, strong)  WKWebViewConfiguration *configure;
@end

@implementation FjViewController

- (instancetype)initWithRequest:(NSURLRequest *)request Configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super init]) {
        _request = request;
        _configure = configuration;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem  *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = left;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:_configure];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_webView loadRequest:_request];
    [self.view addSubview:_webView];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([navigationAction.request.URL.absoluteString containsString:@"wpa.qq.com"] && [navigationAction.request.URL.absoluteString containsString:@"site=qq"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'mailto:' OR SELF BEGINSWITH[cd] 'tel:' OR SELF BEGINSWITH[cd] 'telprompt:'"] evaluateWithObject:navigationAction.request.URL.absoluteString]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            if (@available(iOS 10.0, *)) {
                [UIApplication.sharedApplication openURL:navigationAction.request.URL options:@{} completionHandler:NULL];
            } else {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES[cd] 'https' OR SELF MATCHES[cd] 'http' OR SELF MATCHES[cd] 'file' OR SELF MATCHES[cd] 'about' OR SELF MATCHES[cd] 'post'"] evaluateWithObject:navigationAction.request.URL.scheme]) {
        if ([navigationAction.request.URL.scheme isEqualToString:@"wvjbscheme"]) {
            //decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        if (@available(iOS 8.0, *)) { // openURL if ios version is low then 8 , app will crash
            if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
                if (@available(iOS 10.0, *)) {
                    [UIApplication.sharedApplication openURL:navigationAction.request.URL options:@{} completionHandler:NULL];
                } else {
                    [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
                }
            }
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            }
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 屏幕横竖屏设置
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
