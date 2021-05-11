//
//  WKBaseWebViewController.m
//  HYWork
//
//  Created by information on 2020/12/3.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKBaseWebViewController.h"
#import "LoadViewController.h"

// webview/js bridge
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

// alipay
#import <AlipaySDK/AlipaySDK.h>

@interface WKBaseWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong)  WKWebView *telWebView;
// webView
@property (nonatomic, weak) WKWebView  *webView;
/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;
// js bridge
@property (nonatomic, strong)  WKWebViewJavascriptBridge *bridge;

@end

@implementation WKBaseWebViewController

- (instancetype)initWithDesUrl:(NSString *)desUrl {
    if (self = [super init]) {
        _desUrl = desUrl;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - lifeCicle
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    // 3.右
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)reload {
    [self.webView reload];
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
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    _webView = webView;
                            //http://dev.sge.cn/hykj/ghome/ghome.html
    LoadViewController *loadVC = [LoadViewController shareInstance];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.desUrl]]];
    NSLog(@"desUrl=%@",self.desUrl);
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

    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 1.获取token
    WEAKSELF
    [_bridge registerHandler:@"getToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *token = loadVC.emp.token;
        if (!token) {
            [weakSelf showAlertVc];
        }else{
            responseCallback(token);
        }
    }];
    
    // 2.token 过期
    [_bridge registerHandler:@"goLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf showAlertVc];
    }];
}

#pragma mark - showAlertVc
- (void)showAlertVc {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提醒" message:@"token无效,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    WEAKSELF
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clearTokenGoToLoginVc];
    }];
    [alertVc addAction:sureAction];
    [self.navigationController presentViewController:alertVc animated:YES completion:nil];
}

- (void)clearTokenGoToLoginVc {
    //清空沙盒中的token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"emp"];
    [defaults synchronize];
    
    LoadViewController *loadVc = [LoadViewController shareInstance];
    loadVc.loading = NO;
    loadVc.emp = nil;
        
    //跳转登录页
    [self.navigationController pushViewController:loadVc animated:YES];
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
    
    //新版本的H5拦截支付对老版本的获取订单串和订单支付接口进行合并，推荐使用该接口
    __weak WKBaseWebViewController* wself = self;
    BOOL isIntercepted = [[AlipaySDK defaultService]
                          payInterceptorWithUrl:[navigationAction.request.URL absoluteString]
                                                                fromScheme:@"hywork"
                          callback:^(NSDictionary *resultDic) {
        // 处理支付结果
        NSLog(@"%@", resultDic);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([resultDic[@"isProcessUrlPay"] boolValue]) {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = resultDic[@"returnUrl"];
            [wself loadWithUrlStr:urlStr];
        }
    }];
    
    if (isIntercepted) {
        NSLog(@"xx=%@",[navigationAction.request.URL absoluteString]);
        [self.myProgressView setProgress:1.0 animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.myProgressView.alpha = 0.0f;
         } completion:^(BOOL finished) {
            [self.myProgressView setProgress:0 animated:NO];
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)loadWithUrlStr:(NSString*)urlStr {
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
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
