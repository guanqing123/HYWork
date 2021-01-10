//
//  WKSliderDetailViewController.m
//  HYWork
//
//  Created by information on 2021/1/10.
//  Copyright © 2021 hongyan. All rights reserved.
//

#import "WKSliderDetailViewController.h"
#import <WebKit/WebKit.h>

// tool
#import "WKSliderTool.h"

@interface WKSliderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) WKWebView  *webView;
// 详情ID
@property (nonatomic, copy) NSString *idStr;
@end

@implementation WKSliderDetailViewController

- (instancetype)initWithIdStr:(NSString *)idStr {
    if (self = [super init]) {
        _idStr = idStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 1.title
    self.title = @"详情展示";
    
    // 2.leftItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    // 3.webView
    // 客户端添加meta标签eg
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
    
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.minimumFontSize = 14;
    config.preferences = preference;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView = webView;
    [self.parentView addSubview:webView];
    
    // 4.loadData
    [self loadData];
}

// 回退
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.parentView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(10);
        [[make leading] trailing].equalTo([self parentView]);
        
        MASViewAttribute *bottom = [self mas_bottomLayoutGuideTop];
        #ifdef __IPHONE_11_0    // 如果有这个宏，说明Xcode版本是9开始
            if (@available(iOS 11.0, *)) {
                bottom = [[self view] mas_safeAreaLayoutGuideBottom];
            }
        #endif
        [make bottom].equalTo(bottom);
    }];
}

#pragma mark - loadData
- (void)loadData {
    [SVProgressHUD show];
    WEAKSELF
    [WKSliderTool getSliderDetail:@{@"id" : _idStr} success:^(WKSliderResult * _Nonnull result) {
        [SVProgressHUD dismiss];
        if (result.code != 200) {
            [SVProgressHUD showErrorWithStatus:result.message];
        } else {
            WKSlider *slider = result.data;
            weakSelf.titleLabel.text = slider.title;
            weakSelf.dateLabel.text = slider.createDate;
            [weakSelf.webView loadHTMLString:slider.content baseURL:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败,稍后再试"];
    }];
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
