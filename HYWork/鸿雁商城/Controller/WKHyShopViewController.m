//
//  WKHyShopViewController.m
//  HYWork
//
//  Created by information on 2020/12/16.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKHyShopViewController.h"

#import "LoadViewController.h"
#import <WebKit/WebKit.h>

#import "MBProgressHUD+MJ.h"
#import "WKHyShopTool.h"

@interface WKHyShopViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong)  WKWebView *telWebView;
// webView
@property (nonatomic, weak) WKWebView  *webView;
/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, assign) BOOL reload;

@end

@implementation WKHyShopViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    if (!_reload) {
        [self getHyShop];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    self.title = @"鸿雁商城";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.background & Nav
    [self setupView];
    
    // 2.webView
    [self setWebView];
}

#pragma mark - init
- (void)setupView {
    // 1.背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 2.左
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    // 3.右
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[close, flex, refresh];
}

- (void)close {
    self.tabBarController.selectedIndex = 0;
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if (self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (void)refresh {
    [self.webView reload];
}

#pragma mark - webView
- (void)setWebView {
    // 初始化配置对象
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // 默认是NO，这个值决定了用内嵌HTML5播放视频还是用本地的全屏控制
    configuration.allowsInlineMediaPlayback = YES;
    // 自动播放, 不需要用户采取任何手势开启播放
    if (@available(iOS 10.0, *)) {
        // WKAudiovisualMediaTypeNone 音视频的播放不需要用户手势触发, 即为自动播放
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else {
        configuration.requiresUserActionForMediaPlayback = NO;
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
//    webView.frame = CGRectMake(0, KJTopNavH, ScreenW, ScreenH - KJTopNavH);
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    _webView = webView;

    /*LoadViewController *loadVC = [LoadViewController shareInstance];
    if (loadVC.emp.ygbm) {
        NSString *requestUrl = [NSString stringWithFormat:LNURL, [DES3EncryptUtil encrypt:loadVC.emp.ygbm]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
        _reload = YES;
    }*/
    
    [self.view addSubview:webView];
    [self.view addSubview:self.myProgressView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        [[make leading] trailing].equalTo([self view]);

        MASViewAttribute *top = [self mas_topLayoutGuideBottom];
        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];

        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                top = [[self view] mas_safeAreaLayoutGuideTop];
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif

        [make top].equalTo(top);
        [make bottom].equalTo(bottom);
    }];
    
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
//    https://www.jianshu.com/p/a727b945e9a8
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, HWTopNavH, SCREEN_WIDTH, 0)];
        _myProgressView.tintColor = themeColor;
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    return _myProgressView;
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]){
        self.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 请求数据
- (void)getHyShop {
    [MBProgressHUD showMessage:@"loading..." toView:self.view];
    WEAKSELF
    [WKHyShopTool getHyShopAddress:[NSDictionary dictionaryWithObject:[LoadViewController shareInstance].emp.mobile forKey:@"telephone"] success:^(id  _Nonnull json) {
        _reload = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[json objectForKey:@"data"]]]];
    } failure:^(NSError * _Nonnull error) {
        _reload = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍候再试"];
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];
        // 防止iOS 10及其之后,拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(),^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (WKWebView *)telWebView {
    if (_telWebView == nil) {
        _telWebView = [[WKWebView alloc] init];
    }
    return _telWebView;
}

#pragma mark - delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([webView canGoBack]) {
        if (!self.navigationItem.leftBarButtonItem) {
            [self setupNavItem];
        }
    }else{
        if (self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if ([webView canGoBack]) {
        if (!self.navigationItem.leftBarButtonItem) {
            [self setupNavItem];
        }
    }else{
        if (self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (void)setupNavItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

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
