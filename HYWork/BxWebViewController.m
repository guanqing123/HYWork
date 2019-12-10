//
//  BxWebViewController.m
//  HYWork
//
//  Created by information on 16/5/11.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "BxWebViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "BxFooterView.h"
#import "LoadViewController.h"

@interface BxWebViewController () <WKNavigationDelegate,WKUIDelegate,BxFooterViewDelegate>

@property (nonatomic, strong)  WKWebView *webView;

@property (nonatomic, weak) BxFooterView  *footerView;

@property (nonatomic, strong)  WKWebViewJavascriptBridge *bridge;

@property (nonatomic, strong)  BXItem *item;

@end

@implementation BxWebViewController

- (instancetype)initWithBXItem:(BXItem *)item {
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // Do any additional setup after loading the view.
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SCREEN_WIDTH, SCREEN_HEIGHT -64.0f)];
    _webView.UIDelegate = self;
    //_webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    LoadViewController *loadVC = [LoadViewController shareInstance];
    NSString *userid = loadVC.emp.ecologyid;
    
    NSString  *url = [NSString stringWithFormat:@"%@/web/requestview/SGE00014-%@-%@-%@-%@",OAURL,self.item.newflag,self.item.requestid,self.item.currentnodeid,userid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    //SGE00014-requestid-nodeid-userid
    //http://sge.cn:9105/app/web/requestview/SGE00014-360982-1-1
    //http://sge.cn:9105/app/web/requestview/SGE00014-369209-1-1
    //http://172.30.8.90:8080/index.html
    
    // 监听键盘的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
//    BxFooterView *footerView = [[BxFooterView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 88.0f, SCREEN_WIDTH, 88.0f)];
//    _footerView = footerView;
//    _footerView.delegate = self;
//    [self.view addSubview:footerView];
    

    
//    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        responseCallback(@"Response from testObjcCallback");
//    }];
    
    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"callBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf goBackAndRefresh];
    }];
    
    //[_bridge callHandler:@"openLogPanel" data:@{ @"foo":@"before ready" }];
}

/**
 * 当键盘改变了frame(位置和尺寸)的时候调用
 */
//- (void)keyboradWillChangeFrame:(NSNotification *)note {
//    // 取出键盘动画的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    // 取得键盘最后的frame
//    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // 计算控制器的view需要平移的距离
//    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
//    
//    //if (!self.footerView.isEditing) return;
//    
//    // 执行动画
//    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
//    }];
//}


#pragma mark - BxFooterViewDelegate
- (void)footerViewSuggestBtnClick:(BxFooterView *)footerView {
//footerView.userInteractionEnabled = NO;
    [_bridge callHandler:@"openLogPanel" data:@{} responseCallback:^(id responseData) {
        //footerView.userInteractionEnabled = YES;
    }];
}

#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //NSLog(@"%s", __FUNCTION__);
}


/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    //NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //NSLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    //NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    // 如果响应的地址是百度，则允许跳转
   // if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
        
        // 允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
   // }
    // 不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    // 如果请求的是百度地址，则延迟5s以后跳转
   // if ([navigationAction.request.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
        
        //        // 延迟5s之后跳转
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        //            // 允许跳转
        //            decisionHandler(WKNavigationActionPolicyAllow);
        //        });
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
   // }
    // 不允许跳转
   // decisionHandler(WKNavigationActionPolicyCancel);
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goBackAndRefresh {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    if ([self.delegate respondsToSelector:@selector(bxWebViewControllerGoBackAndRefresh:)]) {
        [self.delegate bxWebViewControllerGoBackAndRefresh:self];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.footerView.signField resignFirstResponder];
//}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
