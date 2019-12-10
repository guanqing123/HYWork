//
//  FwcxNewVcViewController.m
//  HYWork
//
//  Created by information on 2017/11/28.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "FwcxNewVcViewController.h"
#import "FwcxNewView.h"

#import "FwcxManager.h"
//扫描
#import "BeforeScanSingleton.h"

@interface FwcxNewVcViewController ()<UIScrollViewDelegate,FwcxNewViewDelegate,SubLBXScanViewControllerDelegate>
@property (nonatomic, weak) UIScrollView  *bgView;
@property (nonatomic, weak) FwcxNewView  *fwcxView;
@property (nonatomic, copy) NSString *choosed;
@property (nonatomic, copy) NSString *fwtm;
@end

@implementation FwcxNewVcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _choosed = @"1";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    bgView.delegate = self;
    bgView.alwaysBounceVertical = YES;
    [self.view addSubview:bgView];
    _bgView = bgView;
    
    FwcxNewView *fwcxView = [FwcxNewView fwcxView];
    fwcxView.delegate = self;
    fwcxView.frame = bgView.bounds;
    [bgView addSubview:fwcxView];
    _fwcxView = fwcxView;
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)back {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;

    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark - FwcxNewViewDelegate
- (void)fwcxNewView:(FwcxNewView *)fwcxNewView choosed:(NSInteger)choose {
    _choosed = [NSString stringWithFormat:@"%ld",choose];
}

- (void)fwcxNewViewDidSysItem:(FwcxNewView *)fwcxNewView {
    [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
}

- (void)fwcxNewView:(FwcxNewView *)fwcxNewView didChangeTextField:(NSString *)text {
    _fwtm = text;
}

- (void)fwcxNewViewDidCheckItem:(FwcxNewView *)fwcxNewView {
    [self checkItem];
}

- (void)fwcxNewViewDidResetItem:(FwcxNewView *)fwcxNewView {
    _choosed = @"1";
    _fwtm = @"";
}

#pragma mark - SubLBXScanViewControllerDelegate
- (void)subLBXScanViewController:(SubLBXScanViewController *)subLBXScanViewController resultStr:(NSString *)result {
    self.fwcxView.fwmTextField.text = result;
    _fwtm = result;
    [self checkItem];
}

- (void)checkItem {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *fwtm = _fwtm;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gs"] = _choosed;
    params[@"fwtm"] = fwtm;
    [FwcxManager getFwcxWithUrl:url params:params success:^(id json) {
        NSDictionary *dict = [json objectForKey:@"data"];
        if (![dict isKindOfClass:[NSNull class]])
        {
            NSString *result = [dict objectForKey:@"queryResult"];
            NSString *count = [dict objectForKey:@"queryCount"];
            if ([result isEqualToString:@"鸿雁正宗产品"] ) {
                NSString *str = [NSString stringWithFormat:@"查询次数：%@",count];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.view addSubview:alertView];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.view addSubview:alertView];
                [alertView show];
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入防伪条码" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [self.view addSubview:alertView];
            [alertView show];
        }
    } fail:^{
        
    }];
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
