//
//  WKBaseWebViewController.m
//  HYWork
//
//  Created by information on 2020/12/3.
//  Copyright © 2020 hongyan. All rights reserved.
//

#import "WKBaseWebViewController.h"
#import "LoadViewController.h"
#import "FjViewController.h"

// webview/js bridge
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

// alipay
#import <AlipaySDK/AlipaySDK.h>

// scan
#import "BeforeScanSingleton.h"

@interface WKBaseWebViewController ()<WKUIDelegate, WKNavigationDelegate,SubLBXScanViewControllerDelegate>
@property (nonatomic, strong)  WKWebView *telWebView;
// webView
@property (nonatomic, weak) WKWebView  *webView;
/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;
// js bridge
@property (nonatomic, strong)  WKWebViewJavascriptBridge *bridge;

@property (nonatomic, copy) WVJBResponseCallback scanCallback;

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
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.navigationItem.rightBarButtonItems = @[close, flex, refresh];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
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
    // window.open
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
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
    
    // 3.扫一扫
    [_bridge registerHandler:@"scan" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf scan];
        weakSelf.scanCallback = responseCallback;
    }];
}

#pragma mark - 扫一扫
- (void)scan {
    [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
}

- (void)subLBXScanViewController:(SubLBXScanViewController *)subLBXScanViewController resultStr:(NSString *)result {
    self.scanCallback(@{@"result": result});
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
//    NSURL *URL = navigationAction.request.URL;
//    NSString *scheme = [URL scheme];
//    if ([scheme isEqualToString:@"tel"]) {
//        NSString *resourceSpecifier = [URL resourceSpecifier];
//        NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];
//        // 防止iOS 10及其之后,拨打电话系统弹出框延迟出现
//        dispatch_async(dispatch_get_main_queue(),^{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//        });
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
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
    if (navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
        FjViewController *fjVc = [[FjViewController alloc] initWithRequest:navigationAction.request Configuration:configuration];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fjVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    return nil;
}

- (WKWebView *)telWebView {
    if (_telWebView == nil) {
        _telWebView = [[WKWebView alloc] init];
    }
    return _telWebView;
}

//此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
//点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行 参数 message为  js 方法 alert(<message>) 中的<message>
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
//参数 message为  js 方法 confirm(<message>) 中的<message>
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
//当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理

//参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
//参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];

    [self presentViewController:alertController animated:YES completion:nil];
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
