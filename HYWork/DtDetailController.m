//
//  DtDetailController.m
//  HYWork
//
//  Created by information on 16/3/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "DtDetailController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface DtDetailController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak)  UIScrollView  *dynamicDetailView;
@property (nonatomic, weak)  UILabel *titleLable;
@property (nonatomic, weak)  UILabel  *timeLabel;
@property (nonatomic, weak)  WKWebView *wkWebView;
@end

@implementation DtDetailController

- (instancetype)initWithTitle:(NSString *)newsTitle time:(NSString *)newsTime content:(NSString *)newsContent imgeUrl:(NSString *)imageUrl idStr:(NSString *)idStr {
    if (self = [super init]) {
        self.newsTitle = [newsTitle isKindOfClass:[NSNull class]] ? @"" : newsTitle;
        self.newsTime  = [newsTime isKindOfClass:[NSNull class]] ? @"" : newsTime;
        //self.content = [NSString stringWithFormat:@"%@%@%@",@"<html><style type='text/css'>body p{font-size:30px}</style>",newsContent,@"</html>"];
        self.content = newsContent;
        self.imageUrl = imageUrl;
        self.idStr = idStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细新闻";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    if ([self.idStr longLongValue] !=0) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dot"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItem = right;
    }

    UIScrollView *dynamicDetailView = [[UIScrollView alloc] init];
    dynamicDetailView.frame = self.view.bounds;
    _dynamicDetailView = dynamicDetailView;
    [self.view addSubview:dynamicDetailView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10.0f, 10.0f, SCREEN_WIDTH - 2 * 10, 60);
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =  [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.text = self.newsTitle;
    _titleLable = titleLabel;
    [dynamicDetailView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(SCREEN_WIDTH / 2 - 90.0f, 70.0f, 180.0f, 20.0f);
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = self.newsTime;
    _timeLabel = timeLabel;
    [dynamicDetailView addSubview:timeLabel];
    
    // 客户端添加meta标签eg
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0f, 90.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 90.0f - HWTopNavH) configuration:config];
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    NSURL *url = [NSURL URLWithString:@"http://218.75.78.166:9101"];
    [webView loadHTMLString:self.content baseURL:url];
    _wkWebView = webView;
    [dynamicDetailView addSubview:webView];
}

#pragma mark - wkWebView delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //修改字体大小
    //[webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
}

#pragma mark - back
- (void)back {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - share
- (void)share{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"进入详情..." images:self.imageUrl url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.sge.cn:9106/app/web/shareNews/%@",self.idStr]] title:self.newsTitle type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                 switch (state) {
                                     case SSDKResponseStateSuccess:
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                         [alertView show];
                                         break;
                                     }
                                     case SSDKResponseStateFail:
                                     {
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                         [alert show];
                                         break;
                                     }
                                     default:
                                         break;
                                 }
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
