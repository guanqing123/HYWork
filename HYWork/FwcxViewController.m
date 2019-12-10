//
//  FwcxViewController.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "FwcxViewController.h"
#import "FwcxManager.h"

//扫描
#import "BeforeScanSingleton.h"

@interface FwcxViewController () <UITextFieldDelegate,SubLBXScanViewControllerDelegate>
- (IBAction)chooseCompany:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hzhyBtn;
@property (weak, nonatomic) IBOutlet UIButton *njptBtn;
@property (weak, nonatomic) IBOutlet UITextField *fwmTextField;
@property (nonatomic, copy) NSString *choosed;
- (IBAction)sysItem;
- (IBAction)checkItem;
- (IBAction)resetItem;
@end

@implementation FwcxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _choosed = @"1";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseCompany:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.hzhyBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
        [self.njptBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        _choosed = @"1";
    }else{
        [self.hzhyBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        [self.njptBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
        _choosed = @"2";
    }
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

//扫一扫
- (IBAction)sysItem {
    [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
}

#pragma mark -扫一扫代理
- (void)subLBXScanViewController:(SubLBXScanViewController *)subLBXScanViewController resultStr:(NSString *)result {
    self.fwmTextField.text = result;
    [self checkItem];
}

/**
 *  认证
 */
- (IBAction)checkItem {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    NSString *fwtm = self.fwmTextField.text;
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

/**
 *  重输
 */
- (IBAction)resetItem {
    [self.hzhyBtn setImage:[UIImage imageNamed:@"check2"] forState:UIControlStateNormal];
    [self.njptBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    
    self.fwmTextField.text = @"";
    
    _choosed = @"1";
}
@end
