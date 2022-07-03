//
//  LoadViewController.m
//  HYWork
//
//  Created by information on 16/3/29.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "LoadViewController.h"
#import "Utils.h"
#import "MJExtension.h"

// 切换导航栏
#import "NavigationController.h"
#import "WKBusinessViewController.h"

// 阿里Push
#import <CloudPushSDK/CloudPushSDK.h>

@interface LoadViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation LoadViewController

static LoadViewController *loadViewController = nil;

+ (instancetype)shareInstance {
    // dispatch_once_t 是线程安全的,onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once 宏可以保证块代码中的指令只被执行一次
    dispatch_once(&onceToken, ^{
        // 永远只会被执行一次
        loadViewController = [[super allocWithZone:NULL] init];
        loadViewController.navigationController.title = @"登录";
    });
    return loadViewController;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LoadViewController shareInstance];
}

-(instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [LoadViewController shareInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp {
    // 1.背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 2.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    // 3.初始化 tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // IOS 11
    if(@available(iOS 11.0, *)){
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    //ios15 的 UITableView又新增了一个新属性：sectionHeaderTopPadding
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
        userLabel.text = @"用户名:";
        userLabel.textColor = [UIColor grayColor];
        _userLabel = userLabel;
        [cell.contentView addSubview:userLabel];
        
        UITextField *userTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 15, 200, 20)];
        userTextField.placeholder = @"工号";
        userTextField.borderStyle = UITextBorderStyleNone;
        userTextField.returnKeyType = UIReturnKeyDone;
        _userTextField = userTextField;
        [cell.contentView addSubview:userTextField];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        view1.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [cell.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(20, 43, self.view.frame.size.width - 20, 1)];
        view2.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [cell.contentView addSubview:view2];
    } else if(indexPath.row == 1) {
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 80, 20)];
        passwordLabel.text = @"密    码:";
        passwordLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:passwordLabel];
        
        UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 15, 200, 20)];
        passwordTextField.placeholder = @"请输入密码";
        passwordTextField.borderStyle = UITextBorderStyleNone;
        passwordTextField.returnKeyType = UIReturnKeyDone;
        passwordTextField.secureTextEntry = YES;
        _passwordTextField = passwordTextField;
        [cell.contentView addSubview:passwordTextField];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        view1.backgroundColor = GQColor(238.0f, 238.0f, 238.0f);
        [cell.contentView addSubview:view1];
    }
    return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loadBtn.frame = CGRectMake(20, 40, self.view.frame.size.width - 40, 40);
    [loadBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loadBtn.backgroundColor = GQColor(0.0f, 157.0f, 133.0f);
    [loadBtn addTarget:self action:@selector(loadAction) forControlEvents:UIControlEventTouchDown];
    [loadBtn.layer masksToBounds];
    [loadBtn.layer setCornerRadius:5];
    [footerView addSubview:loadBtn];
    return footerView;
}

#pragma mark - 登录
- (void)loadAction {
    NSString *gh = self.userTextField.text;
    NSString *mm = self.passwordTextField.text;
    if (!gh.length | !mm.length) {
        [MBProgressHUD showError:@"请填写完整的登录信息"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];
    WEAKSELF
    [LoginManager postJSONWithUrl:HYURL gh:gh mm:mm success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *data = [json objectForKey:@"data"];
            Emp *emp = [Emp mj_objectWithKeyValues:data];
            emp.mm = mm;
            weakSelf.emp = emp;
            weakSelf.loading = YES;
            
            NSString *temp = emp.ecologyid;
            NSString *ecologyid = [NSString stringWithFormat:@"%@",temp];
            [CloudPushSDK bindAccount:ecologyid withCallback:^(CloudPushCallbackResult *res) {
                if (res.success) {
                    NSLog(@"帐号%@绑定成功...",ecologyid);
                }else{
                    NSLog(@"帐号 绑定 error = %@",res.error);
                }
            }];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL  flag = [userDefaults boolForKey:@"自动登录"];
            if (flag) {
                NSData *empData = [NSKeyedArchiver archivedDataWithRootObject:emp];
                [userDefaults setObject:empData forKey:@"emp"];
            }
            self.userTextField.text = @"";
            self.passwordTextField.text = @"";
            
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(loadViewControllerFinishLogin:)]) {
                [self.delegate loadViewControllerFinishLogin:self];
            }
            
            if ([[emp.ygbm substringToIndex:2] isEqualToString:@"hy"]) {
                WKBusinessViewController *webVc = [[WKBusinessViewController alloc] initWithDesUrl:[H5URL stringByAppendingString:Bussiness]];
                NavigationController *bussinessNav = [[NavigationController alloc] initWithRootViewController:webVc];
                CATransition *transtition = [CATransition animation];
                transtition.duration = 0.5;
                transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                [UIApplication sharedApplication].keyWindow.rootViewController = bussinessNav;
                [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
            }
        }
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请稍后再试"];
    }];
}

@end
